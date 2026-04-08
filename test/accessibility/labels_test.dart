import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:checkbank/screens/login_screen.dart';
import 'package:checkbank/screens/dashboard_screen.dart';

void main() {
  // ---------------------------------------------------------------------------
  // Login screen — semantic labels
  // ---------------------------------------------------------------------------
  group('Login screen — semantic labels', () {
    late SemanticsHandle handle;

    testWidgets('email field has a floating label (not just a hint)',
        (tester) async {
      handle = tester.ensureSemantics();

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: LoginScreen()),
        ),
      );

      // Find the email TextField by its decoration
      final emailField = find.byWidgetPredicate(
        (widget) =>
            widget is TextField &&
            widget.decoration?.hintText == 'Email address',
      );
      expect(emailField, findsOneWidget);

      // Check whether the TextField uses labelText (which provides a
      // persistent, accessible label) or only hintText (which is
      // unreliable for screen readers and vanishes visually).
      //
      // RED: The TextField only has hintText — no labelText. The fix
      //      is to change hintText to labelText (or add labelText
      //      alongside hintText). labelText gives a floating label
      //      that persists both visually and in the semantics tree.
      final textField =
          tester.widget<TextField>(emailField);
      expect(
        textField.decoration?.labelText,
        isNotNull,
        reason:
            'Email field should use InputDecoration.labelText for a '
            'persistent semantic label, not just hintText',
      );

      handle.dispose();
    });

    testWidgets('password field has a floating label (not just a hint)',
        (tester) async {
      handle = tester.ensureSemantics();

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: LoginScreen()),
        ),
      );

      final passwordField = find.byWidgetPredicate(
        (widget) =>
            widget is TextField && widget.decoration?.hintText == 'Password',
      );
      expect(passwordField, findsOneWidget);

      // RED: Same bug — hintText only, no labelText.
      final textField =
          tester.widget<TextField>(passwordField);
      expect(
        textField.decoration?.labelText,
        isNotNull,
        reason:
            'Password field should use InputDecoration.labelText for a '
            'persistent semantic label, not just hintText',
      );

      handle.dispose();
    });

    testWidgets('submit button has a descriptive label', (tester) async {
      handle = tester.ensureSemantics();

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: LoginScreen()),
        ),
      );

      // The button currently says "Go". We expect a descriptive label
      // like "Sign in" that tells screen reader users what the button does.
      //
      // RED: The button's semantic label is "Go", not "Sign in".
      //      A screen reader user hears "Go, button" and has no idea
      //      what action it performs.
      final signInButton = find.bySemanticsLabel('Sign in');
      expect(
        signInButton,
        findsOneWidget,
        reason:
            'Submit button should have a descriptive semantic label '
            '"Sign in", not just "Go"',
      );

      handle.dispose();
    });
  });

  // ---------------------------------------------------------------------------
  // Dashboard screen — semantic labels
  // ---------------------------------------------------------------------------
  group('Dashboard screen — semantic labels', () {
    late SemanticsHandle handle;

    testWidgets('greeting is marked as a heading', (tester) async {
      handle = tester.ensureSemantics();

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: DashboardScreen()),
        ),
      );

      // Find the greeting text
      final greeting = find.textContaining('Good morning');
      expect(greeting, findsOneWidget);

      final semantics = tester.getSemantics(greeting);

      // RED: The greeting Text widget has headlineSmall styling but
      //      no Semantics(header: true) wrapper. Screen readers won't
      //      announce it as a heading, so users cannot navigate by
      //      headings to jump straight to the greeting.
      expect(
        semantics.hasFlag(SemanticsFlag.isHeader),
        isTrue,
        reason: 'Greeting should be marked as a heading for screen readers',
      );

      handle.dispose();
    });

    testWidgets('account card has merged semantics with descriptive label',
        (tester) async {
      handle = tester.ensureSemantics();

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: DashboardScreen()),
        ),
      );

      // Without MergeSemantics, each child of the card (icon, name,
      // balance, chevron) is announced as a separate semantics node.
      // The screen reader reads them individually — a confusing,
      // fragmented experience.
      //
      // With MergeSemantics, the card becomes a single semantics node
      // whose label combines the children, e.g.
      // "Current Account, £4,825.67".
      //
      // RED: No merged semantics on the card. There is no single node
      //      that combines the account name and balance.
      final cardFinder = find.bySemanticsLabel(
        RegExp(r'Current Account.*£4,825\.67'),
      );
      expect(
        cardFinder,
        findsOneWidget,
        reason:
            'Account card should have merged semantics combining '
            'name and balance into a single announcement',
      );

      handle.dispose();
    });

    testWidgets('decorative icons are excluded from semantics', (tester) async {
      handle = tester.ensureSemantics();

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: DashboardScreen()),
        ),
      );

      // The account-type icons (wallet, piggy bank, credit card) are
      // decorative — they repeat information already conveyed by the
      // account name. They should be excluded from the semantics tree
      // so screen readers don't waste time announcing them.
      //
      // RED: The icons are NOT wrapped in ExcludeSemantics, so they
      //      leak into the semantics tree. getSemantics succeeds when
      //      it should throw (because the node should not exist).
      final walletIcon = find.byIcon(Icons.account_balance_wallet);
      expect(walletIcon, findsOneWidget);

      bool iconExcludedFromSemantics = false;
      try {
        tester.getSemantics(walletIcon);
      } on StateError {
        // Good — no semantics node means the icon is excluded.
        iconExcludedFromSemantics = true;
      }

      expect(
        iconExcludedFromSemantics,
        isTrue,
        reason:
            'Decorative account-type icons should be excluded from the '
            'semantics tree with ExcludeSemantics',
      );

      handle.dispose();
    });
  });
}
