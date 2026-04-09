import 'package:flutter/material.dart';

/// A "Quick Pay" widget showing frequent payees with accessible pay buttons.
///
/// Built using Test-Driven Accessibility (TDA) — the tests were written
/// before this widget existed, and the widget was built to pass them.
///
/// Accessibility features:
/// - Heading marked with Semantics(header: true)
/// - Each payee card uses MergeSemantics with a descriptive "Pay <name>" label
/// - Each card has button semantics and a tap action
/// - Payment confirmation uses Semantics(liveRegion: true) so screen readers
///   announce it automatically
class QuickPay extends StatefulWidget {
  const QuickPay({super.key});

  @override
  State<QuickPay> createState() => _QuickPayState();
}

class _QuickPayState extends State<QuickPay> {
  static const _payees = [
    _Payee(name: 'John Smith', initials: 'JS'),
    _Payee(name: 'Sarah Connor', initials: 'SC'),
    _Payee(name: 'Maria Garcia', initials: 'MG'),
  ];

  String? _confirmationMessage;

  void _pay(_Payee payee) {
    setState(() {
      _confirmationMessage = 'Payment sent to ${payee.name}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Heading — marked as a header for screen readers
          Semantics(
            header: true,
            child: Text(
              'Quick Pay',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(height: 12),

          // Payee cards
          Row(
            children: _payees.map((payee) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: _PayeeCard(
                    payee: payee,
                    onPay: () => _pay(payee),
                  ),
                ),
              );
            }).toList(),
          ),

          // Confirmation message — live region for screen reader announcement
          if (_confirmationMessage != null) ...[
            const SizedBox(height: 12),
            Semantics(
              liveRegion: true,
              child: Text(
                _confirmationMessage!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PayeeCard extends StatelessWidget {
  final _Payee payee;
  final VoidCallback onPay;

  const _PayeeCard({required this.payee, required this.onPay});

  @override
  Widget build(BuildContext context) {
    // MergeSemantics merges the child tree into a single semantics node.
    // The Semantics wrapper provides the label and button role.
    return Semantics(
      button: true,
      label: 'Pay ${payee.name}',
      child: InkWell(
        onTap: onPay,
        borderRadius: BorderRadius.circular(12),
        // ExcludeSemantics prevents the child text from creating
        // separate semantics nodes — the parent Semantics label
        // already describes the entire card.
        child: ExcludeSemantics(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 20,
                  child: Text(payee.initials),
                ),
                const SizedBox(height: 8),
                Text(
                  payee.name,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Pay',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Payee {
  final String name;
  final String initials;

  const _Payee({required this.name, required this.initials});
}
