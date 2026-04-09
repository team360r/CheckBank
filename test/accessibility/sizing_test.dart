import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:checkbank/screens/login_screen.dart';
import 'package:checkbank/screens/settings_screen.dart';

void main() {
  // ---------------------------------------------------------------------------
  // Touch target sizes — WCAG 2.5.8 / platform guidelines
  // ---------------------------------------------------------------------------
  group('Touch targets — minimum 48x48 dp', () {
    testWidgets('login "Go" button meets 48dp minimum height', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: LoginScreen()),
        ),
      );

      final button = find.widgetWithText(ElevatedButton, 'Go');
      expect(button, findsOneWidget);

      final size = tester.getSize(button);

      // GREEN: ElevatedButton with vertical padding 14 + text height
      // easily exceeds 48dp.
      expect(size.height, greaterThanOrEqualTo(48.0),
          reason:
              'Sign-in button height: ${size.height}dp — needs >= 48dp');
    });

    testWidgets('login email field meets 48dp minimum height',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: LoginScreen()),
        ),
      );

      final emailField = find.byWidgetPredicate(
        (widget) =>
            widget is TextField &&
            widget.decoration?.hintText == 'Email address',
      );
      expect(emailField, findsOneWidget);

      final size = tester.getSize(emailField);

      // GREEN: Material TextField default height meets 48dp minimum.
      expect(size.height, greaterThanOrEqualTo(48.0),
          reason:
              'Email field height: ${size.height}dp — needs >= 48dp');
    });

    testWidgets('forgot password link meets 48dp minimum height',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: LoginScreen()),
        ),
      );

      final forgotPassword = find.text('Forgot password?');
      expect(forgotPassword, findsOneWidget);

      final size = tester.getSize(forgotPassword);

      // RED: The GestureDetector wraps a small Text with no padding
      // or minimum size constraint. The touch target height is only
      // ~16dp — far below the 48dp minimum.
      //
      // FIX: Wrap with SizedBox(height: 48) or replace with TextButton
      // which provides a minimum 48dp tap area automatically.
      expect(size.height, greaterThanOrEqualTo(48.0),
          reason:
              'Forgot password touch target height: ${size.height}dp '
              '— needs >= 48dp (WCAG 2.5.8)');
    });

    testWidgets('forgot password link meets 48dp minimum width',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: LoginScreen()),
        ),
      );

      final forgotPassword = find.text('Forgot password?');
      expect(forgotPassword, findsOneWidget);

      final size = tester.getSize(forgotPassword);

      // RED: The text "Forgot password?" at bodySmall size is roughly
      // 100dp wide, so width passes — but height does not.
      // This test is GREEN because the text is wide enough.
      expect(size.width, greaterThanOrEqualTo(48.0),
          reason:
              'Forgot password touch target width: ${size.width}dp '
              '— needs >= 48dp (WCAG 2.5.8)');
    });
  });

  // ---------------------------------------------------------------------------
  // Text scaling — layout at 200%
  // ---------------------------------------------------------------------------
  group('Text scaling — 200% (MediaQuery)', () {
    testWidgets('login screen handles 200% text scale without overflow',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(
                textScaler: TextScaler.linear(2.0),
              ),
              child: const LoginScreen(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // GREEN: LoginScreen uses SingleChildScrollView, so content
      // can scroll when text is scaled up. No overflow errors.
      expect(tester.takeException(), isNull,
          reason:
              'Login screen should not overflow at 200% text scale');
    });

    testWidgets('settings screen handles 200% text scale without overflow',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(
                textScaler: TextScaler.linear(2.0),
              ),
              child: const SettingsScreen(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // RED: The Settings user info section uses a Column inside a
      // Container with a fixed height of 100. At 200% text scale,
      // the name and email text overflow the 100dp container.
      //
      // FIX: Remove the fixed height from the Container, or wrap the
      // Column in Expanded/Flexible so it can grow with the text.
      expect(tester.takeException(), isNull,
          reason:
              'Settings screen should not overflow at 200% text scale');
    });

    testWidgets('login screen elements remain visible at 150% text scale',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(
                textScaler: TextScaler.linear(1.5),
              ),
              child: const LoginScreen(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // GREEN: At 150%, the scrollable login screen handles scaling
      // gracefully. All key elements should still be findable.
      expect(find.text('CheckBank'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Go'), findsOneWidget);
      expect(find.text('Forgot password?'), findsOneWidget);
    });
  });
}
