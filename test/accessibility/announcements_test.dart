import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:checkbank/screens/login_screen.dart';
import 'package:checkbank/screens/notifications_screen.dart';
import 'package:checkbank/providers/auth_provider.dart';

void main() {
  // ---------------------------------------------------------------------------
  // Live regions — Login screen error message
  // ---------------------------------------------------------------------------
  group('Login screen — error live region', () {
    late SemanticsHandle handle;

    testWidgets('error message appears after invalid login', (tester) async {
      handle = tester.ensureSemantics();

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: LoginScreen()),
        ),
      );

      // Submit with wrong credentials
      await tester.enterText(
        find.byWidgetPredicate(
          (w) =>
              w is TextField && w.decoration?.hintText == 'Email address',
        ),
        'wrong@email.com',
      );
      await tester.enterText(
        find.byWidgetPredicate(
          (w) => w is TextField && w.decoration?.hintText == 'Password',
        ),
        'wrongpassword',
      );
      await tester.tap(find.widgetWithText(ElevatedButton, 'Go'));
      await tester.pump();

      // GREEN: The error message text appears on screen.
      final errorText = find.text('Invalid email or password');
      expect(errorText, findsOneWidget,
          reason: 'Error message should appear after invalid login');

      handle.dispose();
    });

    testWidgets('error message is in a live region', (tester) async {
      handle = tester.ensureSemantics();

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: LoginScreen()),
        ),
      );

      // Submit with wrong credentials
      await tester.enterText(
        find.byWidgetPredicate(
          (w) =>
              w is TextField && w.decoration?.hintText == 'Email address',
        ),
        'wrong@email.com',
      );
      await tester.enterText(
        find.byWidgetPredicate(
          (w) => w is TextField && w.decoration?.hintText == 'Password',
        ),
        'wrongpassword',
      );
      await tester.tap(find.widgetWithText(ElevatedButton, 'Go'));
      await tester.pump();

      // RED: The error Text widget is NOT wrapped in
      // Semantics(liveRegion: true). Screen readers will not
      // automatically announce it when it appears.
      //
      // FIX: Wrap the error Text in Semantics(liveRegion: true, child: ...)
      final errorText = find.text('Invalid email or password');
      expect(errorText, findsOneWidget);

      final semantics = tester.getSemantics(errorText);
      expect(
        semantics.getSemanticsData().hasFlag(SemanticsFlag.isLiveRegion),
        isTrue,
        reason:
            'Error message should be a live region so screen readers '
            'announce it automatically when it appears',
      );

      handle.dispose();
    });

    testWidgets('successful login does not show error', (tester) async {
      handle = tester.ensureSemantics();

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: LoginScreen()),
        ),
      );

      // Submit with correct credentials
      await tester.enterText(
        find.byWidgetPredicate(
          (w) =>
              w is TextField && w.decoration?.hintText == 'Email address',
        ),
        'alex@checkbank.dev',
      );
      await tester.enterText(
        find.byWidgetPredicate(
          (w) => w is TextField && w.decoration?.hintText == 'Password',
        ),
        'password',
      );
      await tester.tap(find.widgetWithText(ElevatedButton, 'Go'));
      await tester.pump();

      // GREEN: No error message should appear for valid credentials.
      final errorText = find.text('Invalid email or password');
      expect(errorText, findsNothing,
          reason: 'No error should appear with valid credentials');

      handle.dispose();
    });
  });

  // ---------------------------------------------------------------------------
  // Live regions — Notifications screen unread count
  // ---------------------------------------------------------------------------
  group('Notifications screen — unread count live region', () {
    late SemanticsHandle handle;

    testWidgets('unread count is displayed', (tester) async {
      handle = tester.ensureSemantics();

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: NotificationsScreen()),
        ),
      );

      // GREEN: The unread count text should be visible.
      // Mock data has 2 unread notifications.
      final unreadText = find.textContaining('unread');
      expect(unreadText, findsOneWidget,
          reason: 'Unread count should be displayed');

      handle.dispose();
    });

    testWidgets('unread count is a live region', (tester) async {
      handle = tester.ensureSemantics();

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: NotificationsScreen()),
        ),
      );

      // RED: The unread count text is NOT wrapped in
      // Semantics(liveRegion: true). When the count changes
      // (e.g. after tapping "Mark all read"), screen readers
      // will not announce the updated count.
      //
      // FIX: Wrap the "$unread unread" Text in
      // Semantics(liveRegion: true, child: ...)
      final unreadText = find.textContaining('unread');
      expect(unreadText, findsOneWidget);

      final semantics = tester.getSemantics(unreadText);
      expect(
        semantics.getSemanticsData().hasFlag(SemanticsFlag.isLiveRegion),
        isTrue,
        reason:
            'Unread count should be a live region so screen readers '
            'announce changes when notifications are marked as read',
      );

      handle.dispose();
    });

    testWidgets('mark all read updates unread count', (tester) async {
      handle = tester.ensureSemantics();

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: NotificationsScreen()),
        ),
      );

      // Initially 2 unread
      expect(find.text('2 unread'), findsOneWidget);

      // Tap "Mark all read" button in the AppBar
      await tester.tap(find.byIcon(Icons.done_all));
      await tester.pump();

      // GREEN: After marking all read, count should be 0.
      expect(find.text('0 unread'), findsOneWidget,
          reason: 'Unread count should update to 0 after marking all read');

      handle.dispose();
    });
  });
}
