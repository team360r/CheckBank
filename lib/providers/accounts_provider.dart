import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/mock_data.dart';
import '../data/models.dart';

final accountsProvider = Provider<List<Account>>((ref) => mockAccounts);

final transactionsProvider =
    Provider.family<List<Transaction>, String>((ref, accountId) {
  return mockTransactions[accountId] ?? [];
});
