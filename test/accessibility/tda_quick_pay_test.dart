import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:checkbank/widgets/quick_pay.dart';

void main() {
  // ---------------------------------------------------------------------------
  // Quick Pay — accessibility requirements (written BEFORE the widget)
  // ---------------------------------------------------------------------------
  group('Quick Pay — accessibility requirements', () {
    late SemanticsHandle handle;

    testWidgets('has a heading', (tester) async {
      handle = tester.ensureSemantics();

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: Scaffold(body: QuickPay())),
        ),
      );

      // The heading text "Quick Pay" should exist
      final heading = find.bySemanticsLabel('Quick Pay');
      expect(heading, findsOneWidget,
          reason: 'Quick Pay heading should exist');

      // It should be marked as a header in semantics
      final semantics = tester.getSemantics(heading);
      expect(
        semantics.getSemanticsData().hasFlag(SemanticsFlag.isHeader),
        isTrue,
        reason: 'Quick Pay should be marked as a heading for screen readers',
      );

      handle.dispose();
    });

    testWidgets('each payee has a descriptive label', (tester) async {
      handle = tester.ensureSemantics();

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: Scaffold(body: QuickPay())),
        ),
      );

      // Each payee card should have a merged label like "Pay John Smith"
      expect(find.bySemanticsLabel(RegExp(r'^Pay .+')), findsNWidgets(3),
          reason: 'Each of the 3 payees should have a "Pay <name>" label');

      handle.dispose();
    });

    testWidgets('pay button has button role and tap action', (tester) async {
      handle = tester.ensureSemantics();

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: Scaffold(body: QuickPay())),
        ),
      );

      // Find the first payee's semantics node
      final payButtons = find.bySemanticsLabel(RegExp(r'^Pay .+'));
      expect(payButtons, findsNWidgets(3));

      // Each should be a button with a tap action
      for (var i = 0; i < 3; i++) {
        final semantics = tester.getSemantics(payButtons.at(i));
        final data = semantics.getSemanticsData();

        expect(
          data.hasFlag(SemanticsFlag.isButton),
          isTrue,
          reason: 'Payee card $i should have button semantics',
        );
        expect(
          data.hasAction(SemanticsAction.tap),
          isTrue,
          reason: 'Payee card $i should be tappable',
        );
      }

      handle.dispose();
    });

    testWidgets('payment confirmation uses live region', (tester) async {
      handle = tester.ensureSemantics();

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: Scaffold(body: QuickPay())),
        ),
      );

      // Tap the first payee's Pay button
      final payButtons = find.bySemanticsLabel(RegExp(r'^Pay .+'));
      await tester.tap(payButtons.first);
      await tester.pump();

      // A confirmation message should appear
      final confirmation = find.textContaining('Payment sent');
      expect(confirmation, findsOneWidget,
          reason: 'Confirmation text should appear after tapping Pay');

      // The confirmation should be in a live region
      final semantics = tester.getSemantics(confirmation);
      expect(
        semantics.getSemanticsData().hasFlag(SemanticsFlag.isLiveRegion),
        isTrue,
        reason:
            'Confirmation should be a live region so screen readers '
            'announce it automatically',
      );

      handle.dispose();
    });
  });
}
