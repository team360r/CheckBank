import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../data/mock_data.dart';
import '../providers/accounts_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/account_card.dart';

/// Dashboard screen with intentional accessibility bugs.
///
/// BUG 1: Greeting text is NOT marked as a heading in semantics.
/// BUG 2: Account cards have no merged semantics (see AccountCard).
/// BUG 3: Balance has no "pounds" context (see AccountCard).
/// BUG 4: Decorative icon not excluded from semantics (see AccountCard).
/// BUG 5: Subtitle uses AppColors.textSecondary — fails WCAG AA contrast.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(accountsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('CheckBank'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // BUG 1: Greeting is NOT marked as a heading in semantics
                Text(
                  'Good morning, ${mockUser.name}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                // BUG 5: Low-contrast secondary text
                Text(
                  'Here are your accounts',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...accounts.map(
            (account) => AccountCard(
              account: account,
              onTap: () => context.go('/transactions/${account.id}'),
            ),
          ),
        ],
      ),
    );
  }
}
