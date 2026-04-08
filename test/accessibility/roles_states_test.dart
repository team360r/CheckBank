import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:checkbank/screens/login_screen.dart';
import 'package:checkbank/screens/settings_screen.dart';
import 'package:checkbank/screens/transactions_screen.dart';
import 'package:checkbank/widgets/transaction_tile.dart';

void main() {
  // ---------------------------------------------------------------------------
  // Login screen — button roles
  // ---------------------------------------------------------------------------
  group('Login screen — button roles', () {
    late SemanticsHandle handle;

    testWidgets('submit button has button role and tap action', (tester) async {
      handle = tester.ensureSemantics();

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: LoginScreen()),
        ),
      );

      // Find the "Go" button (the ElevatedButton)
      final button = find.widgetWithText(ElevatedButton, 'Go');
      expect(button, findsOneWidget);

      final semantics = tester.getSemantics(button);

      // ElevatedButton already provides correct semantics — this PASSES.
      // Not everything is broken. Testing confirms what works too.
      expect(
        semantics,
        matchesSemantics(
          label: 'Go',
          isButton: true,
          hasTapAction: true,
          isEnabled: true,
          isFocusable: true,
          hasEnabledState: true,
          hasFocusAction: true,
        ),
      );

      handle.dispose();
    });
  });

  // ---------------------------------------------------------------------------
  // Settings screen — toggle states
  // ---------------------------------------------------------------------------
  group('Settings screen — toggle states', () {
    late SemanticsHandle handle;

    testWidgets('biometric toggle exposes its on/off state', (tester) async {
      handle = tester.ensureSemantics();

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: SettingsScreen()),
        ),
      );

      // Find all Switch widgets — there should be 3 toggles
      final switches = find.byType(Switch);
      expect(switches, findsNWidgets(3));

      // Get the first switch (biometrics)
      final biometricSwitch = switches.first;
      final semantics = tester.getSemantics(biometricSwitch);

      // The switch itself has hasToggledState and hasTapAction,
      // but BUG: the label "Biometric login" is on a separate ListTile
      // title — not merged with the Switch's semantics node.
      // With SwitchListTile, the label and toggle state would be
      // combined into a single semantics node.
      expect(
        semantics,
        matchesSemantics(
          hasToggledState: true,
          isToggled: false, // initially off
          hasTapAction: true,
          isFocusable: true,
          label: 'Biometric login', // FAILS — Switch is separate from label
        ),
      );

      handle.dispose();
    });

    testWidgets('toggling a switch updates its semantic state', (tester) async {
      handle = tester.ensureSemantics();

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: SettingsScreen()),
        ),
      );

      // Tap the biometric switch to turn it on
      final switches = find.byType(Switch);
      await tester.tap(switches.first);
      await tester.pumpAndSettle();

      final semantics = tester.getSemantics(switches.first);

      // After tapping, the switch should report isToggled: true
      // BUG: same label problem — "Biometric login" is not on this node
      expect(
        semantics,
        matchesSemantics(
          hasToggledState: true,
          isToggled: true, // now ON
          hasTapAction: true,
          isFocusable: true,
          label: 'Biometric login', // FAILS — Switch is separate from label
        ),
      );

      handle.dispose();
    });
  });

  // ---------------------------------------------------------------------------
  // Transactions screen — filter chip selected state
  // ---------------------------------------------------------------------------
  group('Transactions screen — filter chip state', () {
    late SemanticsHandle handle;

    testWidgets('filter chips expose selected state', (tester) async {
      handle = tester.ensureSemantics();

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: TransactionsScreen(accountId: 'acc-1'),
          ),
        ),
      );

      // The "All" filter should be selected by default.
      // With a proper FilterChip, the semantics would include
      // isSelected: true or hasToggledState: true.
      // BUG: GestureDetector + Container has no selected state in semantics.
      final allChipText = find.text('All');
      expect(allChipText, findsOneWidget);

      final semantics = tester.getSemantics(allChipText);
      final data = semantics.getSemanticsData();

      // Check for any indication of selected state
      expect(
        data.hasFlag(SemanticsFlag.isSelected) ||
            data.hasFlag(SemanticsFlag.isToggled),
        isTrue,
        reason:
            'The active filter chip should expose a selected or toggled '
            'state in semantics so screen readers can announce which '
            'filter is currently active',
      );

      handle.dispose();
    });
  });

  // ---------------------------------------------------------------------------
  // Transactions screen — custom semantics actions
  // ---------------------------------------------------------------------------
  group('Transactions screen — custom actions', () {
    late SemanticsHandle handle;

    testWidgets('transaction tile has a custom delete action', (tester) async {
      handle = tester.ensureSemantics();

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: TransactionsScreen(accountId: 'acc-1'),
          ),
        ),
      );

      // Find the first TransactionTile
      final tiles = find.byType(TransactionTile);
      expect(tiles, findsWidgets);

      final firstTile = tiles.first;
      final semantics = tester.getSemantics(firstTile);

      // BUG: Dismissible provides swipe-to-delete but no
      // CustomSemanticsAction. Screen reader users cannot discover
      // the delete action through the accessibility interface.
      expect(
        semantics.getSemanticsData().customSemanticsActionIds,
        isNotEmpty,
        reason:
            'Transaction tile should expose a custom "Delete" action '
            'via CustomSemanticsAction so screen reader users can '
            'discover and invoke the delete action',
      );

      handle.dispose();
    });
  });
}
