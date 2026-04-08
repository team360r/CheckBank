import 'package:flutter/material.dart';
import '../data/models.dart';
import '../theme/app_colors.dart';

/// Account card widget with intentional accessibility bugs.
///
/// BUG 1: No merged semantics — screen reader reads each text node separately
///        instead of a single coherent announcement.
/// BUG 2: Balance announced as raw number with no "pounds" context.
/// BUG 3: Decorative account-type icon is NOT excluded from semantics tree.
/// BUG 4: Subtitle uses AppColors.textSecondary — fails WCAG AA contrast.
class AccountCard extends StatelessWidget {
  final Account account;
  final VoidCallback onTap;
  const AccountCard({super.key, required this.account, required this.onTap});

  IconData _iconForType(AccountType type) {
    switch (type) {
      case AccountType.current:
        return Icons.account_balance_wallet;
      case AccountType.savings:
        return Icons.savings;
      case AccountType.credit:
        return Icons.credit_card;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // BUG 3: Decorative icon NOT excluded from semantics
              Icon(
                _iconForType(account.type),
                size: 32,
                color: AppColors.primary,
              ),
              const SizedBox(width: 16),
              // BUG 1: No merged semantics — each Text is read individually
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      account.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    // BUG 2: Raw number — no currency context for screen readers
                    // BUG 4: Low-contrast secondary text
                    Text(
                      '${account.balance < 0 ? '-' : ''}£${account.balance.abs().toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
