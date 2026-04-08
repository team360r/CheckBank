import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:checkbank/screens/login_screen.dart';

void main() {
  group('Audit smoke test', () {
    testWidgets('login screen renders with semantics enabled', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: LoginScreen()),
        ),
      );

      // The app renders — but are the semantics correct?
      // We'll find out in the next chapters.
      expect(find.text('CheckBank'), findsOneWidget);
      expect(find.text('Go'), findsOneWidget);

      handle.dispose();
    });
  });
}
