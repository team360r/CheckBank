import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../data/models.dart';
import '../providers/accounts_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/transaction_tile.dart';

/// Transactions screen with intentional accessibility bugs.
///
/// BUG 1: Filter chips use GestureDetector instead of FilterChip — missing
///        selected/unselected state in semantics.
/// BUG 2: Date section headers are NOT marked as headings in semantics.
/// BUG 3: Swipe-to-delete has no CustomSemanticsAction (see TransactionTile).
/// BUG 4: Credit/debit indicator is colour-only (see TransactionTile).
/// BUG 5: Date headers use AppColors.textSecondary — fails WCAG AA contrast.
class TransactionsScreen extends ConsumerStatefulWidget {
  final String accountId;
  const TransactionsScreen({super.key, required this.accountId});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

enum _Filter { all, credits, debits }

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  _Filter _filter = _Filter.all;
  late List<Transaction> _transactions;

  @override
  Widget build(BuildContext context) {
    final allTransactions = ref.watch(transactionsProvider(widget.accountId));
    _transactions = switch (_filter) {
      _Filter.all => allTransactions,
      _Filter.credits =>
        allTransactions.where((t) => t.type == TransactionType.credit).toList(),
      _Filter.debits =>
        allTransactions.where((t) => t.type == TransactionType.debit).toList(),
    };

    // Group transactions by date
    final grouped = <String, List<Transaction>>{};
    for (final tx in _transactions) {
      final key = DateFormat('d MMMM yyyy').format(tx.date);
      grouped.putIfAbsent(key, () => []).add(tx);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
      ),
      body: Column(
        children: [
          // BUG 1: Filter chips use GestureDetector — no selected state
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _buildFilterChip('All', _Filter.all),
                const SizedBox(width: 8),
                _buildFilterChip('Credits', _Filter.credits),
                const SizedBox(width: 8),
                _buildFilterChip('Debits', _Filter.debits),
              ],
            ),
          ),
          Expanded(
            child: _transactions.isEmpty
                ? const Center(child: Text('No transactions'))
                : ListView.builder(
                    itemCount: grouped.length,
                    itemBuilder: (context, sectionIndex) {
                      final dateKey = grouped.keys.elementAt(sectionIndex);
                      final txList = grouped[dateKey]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // BUG 2: Date header NOT marked as heading
                          // BUG 5: Low-contrast date header
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                            child: Text(
                              dateKey,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                          ...txList.map(
                            (tx) => TransactionTile(
                              transaction: tx,
                              onDismissed: () {
                                setState(() {
                                  _transactions.remove(tx);
                                });
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // BUG 1: Using GestureDetector instead of FilterChip —
  // no toggled/selected semantics state exposed
  Widget _buildFilterChip(String label, _Filter filter) {
    final isSelected = _filter == filter;
    return GestureDetector(
      onTap: () => setState(() => _filter = filter),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
