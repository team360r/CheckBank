import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:checkbank/app.dart';

// ---------------------------------------------------------------------------
// Reusable accessibility audit helper
// ---------------------------------------------------------------------------

/// Walks the semantics tree and checks common accessibility rules.
/// Returns a list of violations found.
List<String> accessibilityAudit(WidgetTester tester) {
  final violations = <String>[];

  void walk(SemanticsNode node) {
    final data = node.getSemanticsData();

    // Rule 1: Tappable nodes must have a label or value
    if (data.hasAction(SemanticsAction.tap) &&
        data.label.isEmpty &&
        data.value.isEmpty) {
      violations
          .add('Tappable node at ${node.rect} has no label or value');
    }

    // Rule 2: Toggleable nodes must have a label
    if (data.hasAction(SemanticsAction.tap) &&
        data.hasFlag(SemanticsFlag.hasToggledState) &&
        data.label.isEmpty) {
      violations.add('Toggle at ${node.rect} has no label');
    }

    // Rule 3: Images should have a label (excludes decorative)
    if (data.hasFlag(SemanticsFlag.isImage) && data.label.isEmpty) {
      violations
          .add('Image at ${node.rect} has no semanticsLabel');
    }

    // Rule 4: Headers should exist on each screen (informational)
    // (checked at a higher level, not per-node)

    node.visitChildren(walk);
  }

  final owner = tester.binding.pipelineOwner.semanticsOwner;
  if (owner == null) {
    violations.add('Semantics owner is null — did you call ensureSemantics()?');
    return violations;
  }

  final root = owner.rootSemanticsNode;
  if (root == null) {
    violations.add('Root semantics node is null');
    return violations;
  }

  walk(root);
  return violations;
}

// ---------------------------------------------------------------------------
// Integration test: full user journey with accessibility checks
// ---------------------------------------------------------------------------

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('full user journey with accessibility audit at each screen',
      (tester) async {
    final handle = tester.ensureSemantics();

    await tester.pumpWidget(const ProviderScope(child: CheckBankApp()));
    await tester.pumpAndSettle();

    // -----------------------------------------------------------------------
    // Step 1: Login screen renders
    // -----------------------------------------------------------------------
    expect(find.text('CheckBank'), findsOneWidget);
    expect(find.text('Go'), findsOneWidget);

    // Run audit on Login screen
    final loginViolations = accessibilityAudit(tester);
    debugPrint('Login screen violations: ${loginViolations.length}');
    for (final v in loginViolations) {
      debugPrint('  - $v');
    }

    // -----------------------------------------------------------------------
    // Step 2: Sign in with valid credentials
    // -----------------------------------------------------------------------
    await tester.enterText(
      find.byWidgetPredicate(
        (w) => w is TextField && w.decoration?.hintText == 'Email address',
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
    await tester.pumpAndSettle();

    // -----------------------------------------------------------------------
    // Step 3: Dashboard renders
    // -----------------------------------------------------------------------
    expect(find.textContaining('Alex Johnson'), findsOneWidget);
    expect(find.text('Current Account'), findsOneWidget);

    // Run audit on Dashboard screen
    final dashboardViolations = accessibilityAudit(tester);
    debugPrint('Dashboard violations: ${dashboardViolations.length}');
    for (final v in dashboardViolations) {
      debugPrint('  - $v');
    }

    // -----------------------------------------------------------------------
    // Step 4: Tap an account card to navigate to Transactions
    // -----------------------------------------------------------------------
    await tester.tap(find.text('Current Account'));
    await tester.pumpAndSettle();

    expect(find.text('Transactions'), findsOneWidget);

    // Run audit on Transactions screen
    final txViolations = accessibilityAudit(tester);
    debugPrint('Transactions violations: ${txViolations.length}');
    for (final v in txViolations) {
      debugPrint('  - $v');
    }

    // -----------------------------------------------------------------------
    // Step 5: Go back to Dashboard
    // -----------------------------------------------------------------------
    final backButton = find.byTooltip('Back');
    if (backButton.evaluate().isNotEmpty) {
      await tester.tap(backButton);
      await tester.pumpAndSettle();
    }

    // -----------------------------------------------------------------------
    // Step 6: Navigate to Notifications via bottom nav
    // -----------------------------------------------------------------------
    await tester.tap(find.text('Alerts'));
    await tester.pumpAndSettle();

    expect(find.text('Notifications'), findsOneWidget);

    // Run audit on Notifications screen
    final notifViolations = accessibilityAudit(tester);
    debugPrint('Notifications violations: ${notifViolations.length}');
    for (final v in notifViolations) {
      debugPrint('  - $v');
    }

    // -----------------------------------------------------------------------
    // Summary
    // -----------------------------------------------------------------------
    final totalViolations = loginViolations.length +
        dashboardViolations.length +
        txViolations.length +
        notifViolations.length;

    debugPrint('\n=== Accessibility Audit Summary ===');
    debugPrint('Login:         ${loginViolations.length} violations');
    debugPrint('Dashboard:     ${dashboardViolations.length} violations');
    debugPrint('Transactions:  ${txViolations.length} violations');
    debugPrint('Notifications: ${notifViolations.length} violations');
    debugPrint('Total:         $totalViolations violations');
    debugPrint('===================================\n');

    handle.dispose();
  });
}
