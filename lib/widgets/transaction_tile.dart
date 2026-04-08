import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/models.dart';
import '../theme/app_colors.dart';

/// Transaction tile widget with intentional accessibility bugs.
///
/// BUG 1: Credit/debit indicator is colour-only (green/red text, no icon or
///        text label) — fails WCAG 1.4.1 Use of Color.
/// BUG 2: Swipe-to-delete via Dismissible but NO CustomSemanticsAction —
///        screen reader users have no way to discover the delete action.
/// BUG 3: Date text uses AppColors.textSecondary — fails WCAG AA contrast.
class TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onDismissed;
  const TransactionTile({
    super.key,
    required this.transaction,
    this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    final isCredit = transaction.type == TransactionType.credit;
    final amountText =
        '${isCredit ? '+' : '-'}£${transaction.amount.toStringAsFixed(2)}';
    final dateText = DateFormat('HH:mm').format(transaction.date);

    // BUG 2: Dismissible with no CustomSemanticsAction
    return Dismissible(
      key: Key(transaction.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismissed?.call(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        color: AppColors.error,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: ListTile(
        title: Text(transaction.description),
        subtitle: Text(
          dateText,
          // BUG 3: Low-contrast date text
          style: TextStyle(color: AppColors.textSecondary),
        ),
        trailing: Text(
          amountText,
          style: TextStyle(
            // BUG 1: Colour-only indicator — no icon or label for credit/debit
            color: isCredit ? AppColors.creditGreen : AppColors.debitRed,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
