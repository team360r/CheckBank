/// Mock data for CheckBank — GBP currency.
library;

import 'models.dart';

const mockUser = User(
  id: 'user-1',
  name: 'Alex Johnson',
  email: 'alex@checkbank.dev',
);

final mockAccounts = [
  const Account(
    id: 'acc-1',
    name: 'Current Account',
    type: AccountType.current,
    balance: 4825.67,
  ),
  const Account(
    id: 'acc-2',
    name: 'Savings Account',
    type: AccountType.savings,
    balance: 12340.00,
  ),
  const Account(
    id: 'acc-3',
    name: 'Credit Card',
    type: AccountType.credit,
    balance: -892.15,
  ),
];

final mockTransactions = <String, List<Transaction>>{
  'acc-1': [
    Transaction(
      id: 'tx-1',
      accountId: 'acc-1',
      amount: 3200.00,
      description: 'Salary deposit',
      date: DateTime(2026, 4, 1),
      type: TransactionType.credit,
    ),
    Transaction(
      id: 'tx-2',
      accountId: 'acc-1',
      amount: 45.99,
      description: 'Grocery store',
      date: DateTime(2026, 4, 2),
      type: TransactionType.debit,
    ),
    Transaction(
      id: 'tx-3',
      accountId: 'acc-1',
      amount: 120.00,
      description: 'Electric bill',
      date: DateTime(2026, 3, 28),
      type: TransactionType.debit,
    ),
    Transaction(
      id: 'tx-4',
      accountId: 'acc-1',
      amount: 500.00,
      description: 'Transfer from savings',
      date: DateTime(2026, 3, 25),
      type: TransactionType.credit,
    ),
  ],
};

final mockNotifications = [
  AppNotification(
    id: 'notif-1',
    title: 'Payment received',
    body: 'You received £3,200.00 from Employer Ltd',
    timestamp: DateTime(2026, 4, 1, 9, 0),
  ),
  AppNotification(
    id: 'notif-2',
    title: 'Card payment',
    body: 'Card ending 4521 used for £45.99 at Tesco',
    timestamp: DateTime(2026, 4, 2, 14, 30),
  ),
  AppNotification(
    id: 'notif-3',
    title: 'Direct debit',
    body: 'Direct debit of £120.00 to British Gas',
    timestamp: DateTime(2026, 3, 28, 8, 0),
    read: true,
  ),
];
