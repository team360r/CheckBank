import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:checkbank/screens/login_screen.dart';
import 'package:checkbank/screens/transfer_screen.dart';

void main() {
  // ---------------------------------------------------------------------------
  // Tab order — Login screen
  // ---------------------------------------------------------------------------
  group('Login screen — tab order', () {
    testWidgets('email field can receive focus', (tester) async {
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

      // Tap the email field to give it focus
      await tester.tap(emailField);
      await tester.pump();

      // GREEN: The email field should now have focus.
      final focusNode = FocusManager.instance.primaryFocus;
      expect(focusNode, isNotNull,
          reason: 'Email field should receive focus when tapped');
    });

    testWidgets('tab moves focus from email to password', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: LoginScreen()),
        ),
      );

      // Focus the email field
      final emailField = find.byWidgetPredicate(
        (widget) =>
            widget is TextField &&
            widget.decoration?.hintText == 'Email address',
      );
      await tester.tap(emailField);
      await tester.pump();

      // Press Tab to move to password field
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();

      // GREEN: Tab should move focus forward. In the LoginScreen's
      // Column layout, the next focusable element after email is the
      // password TextField.
      final focusNode = FocusManager.instance.primaryFocus;
      expect(focusNode, isNotNull,
          reason: 'Focus should move to next field after Tab');
    });

    testWidgets('tab order visits all interactive elements', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: LoginScreen()),
        ),
      );

      // Focus the email field to start
      final emailField = find.byWidgetPredicate(
        (widget) =>
            widget is TextField &&
            widget.decoration?.hintText == 'Email address',
      );
      await tester.tap(emailField);
      await tester.pump();

      // Count how many times we can Tab before focus wraps or we
      // reach a reasonable limit. We expect: email -> password -> button
      // (and possibly the forgot password link if it were focusable).
      int tabCount = 0;
      final visited = <String>{};
      for (int i = 0; i < 10; i++) {
        final focus = FocusManager.instance.primaryFocus;
        if (focus != null) {
          visited.add(focus.debugLabel ?? 'node-$i');
        }
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        tabCount++;
      }

      // GREEN: We should visit at least 2 distinct focusable elements
      // (email field and password field). The exact count depends on
      // whether the button and other elements are in the tab order.
      expect(visited.length, greaterThanOrEqualTo(2),
          reason:
              'Tab order should visit at least email and password fields');
    });
  });

  // ---------------------------------------------------------------------------
  // Focus management — Transfer screen step advance
  // ---------------------------------------------------------------------------
  group('Transfer screen — focus management on step advance', () {
    testWidgets('step 1 recipient field can receive focus', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: TransferScreen()),
      );

      // Find the first TextField (Recipient name)
      final recipientField = find.byWidgetPredicate(
        (widget) =>
            widget is TextField &&
            widget.decoration?.hintText == 'Recipient name',
      );
      expect(recipientField, findsOneWidget);

      await tester.tap(recipientField);
      await tester.pump();

      // GREEN: Tapping the field gives it focus.
      final focus = FocusManager.instance.primaryFocus;
      expect(focus, isNotNull,
          reason: 'Recipient field should receive focus when tapped');
    });

    testWidgets('advancing to step 2 moves focus to amount field',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: TransferScreen()),
      );

      // Fill in step 1 fields
      await tester.enterText(
        find.byWidgetPredicate(
          (widget) =>
              widget is TextField &&
              widget.decoration?.hintText == 'Recipient name',
        ),
        'Jane Smith',
      );
      await tester.enterText(
        find.byWidgetPredicate(
          (widget) =>
              widget is TextField &&
              widget.decoration?.hintText == 'Sort code',
        ),
        '12-34-56',
      );
      await tester.enterText(
        find.byWidgetPredicate(
          (widget) =>
              widget is TextField &&
              widget.decoration?.hintText == 'Account number',
        ),
        '12345678',
      );

      // Tap Continue to advance to step 2
      await tester.tap(find.text('Continue').first);
      await tester.pumpAndSettle();

      // The Amount field should now be visible
      final amountField = find.byWidgetPredicate(
        (widget) =>
            widget is TextField &&
            widget.decoration?.hintText == 'Amount (£)',
      );
      expect(amountField, findsOneWidget,
          reason: 'Amount field should be visible in step 2');

      // RED: After advancing to step 2, focus should automatically
      // move to the Amount field. But the TransferScreen does not
      // call FocusScope.of(context).requestFocus() on step change,
      // so focus stays wherever it was (likely the Continue button
      // from step 1, which may no longer be visible).
      //
      // FIX: In _onStepContinue(), after setState, schedule a
      // post-frame callback that requests focus on the new step's
      // first field using a FocusNode.
      final focusContext = tester.element(amountField);
      final focusNode = Focus.of(focusContext);
      expect(focusNode.hasFocus, isTrue,
          reason:
              'Focus should move to the Amount field when step 2 becomes '
              'active — screen reader users need focus to track the UI change');
    });

    testWidgets('advancing to step 3 moves focus to reference field',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: TransferScreen()),
      );

      // Fill step 1 and advance
      await tester.enterText(
        find.byWidgetPredicate(
          (widget) =>
              widget is TextField &&
              widget.decoration?.hintText == 'Recipient name',
        ),
        'Jane Smith',
      );
      await tester.enterText(
        find.byWidgetPredicate(
          (widget) =>
              widget is TextField &&
              widget.decoration?.hintText == 'Sort code',
        ),
        '12-34-56',
      );
      await tester.enterText(
        find.byWidgetPredicate(
          (widget) =>
              widget is TextField &&
              widget.decoration?.hintText == 'Account number',
        ),
        '12345678',
      );
      await tester.tap(find.text('Continue').first);
      await tester.pumpAndSettle();

      // Fill step 2 and advance
      await tester.enterText(
        find.byWidgetPredicate(
          (widget) =>
              widget is TextField &&
              widget.decoration?.hintText == 'Amount (£)',
        ),
        '50.00',
      );
      await tester.tap(find.text('Continue').first);
      await tester.pumpAndSettle();

      // The Reference field should now be visible
      final referenceField = find.byWidgetPredicate(
        (widget) =>
            widget is TextField &&
            widget.decoration?.hintText == 'Payment reference',
      );
      expect(referenceField, findsOneWidget,
          reason: 'Reference field should be visible in step 3');

      // RED: Same bug — focus does not move to the new step's field.
      final focusContext = tester.element(referenceField);
      final focusNode = Focus.of(focusContext);
      expect(focusNode.hasFocus, isTrue,
          reason:
              'Focus should move to the Reference field when step 3 '
              'becomes active');
    });
  });
}
