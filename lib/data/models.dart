/// CheckBank data models.
library;

enum AccountType { current, savings, credit }

enum TransactionType { credit, debit }

class User {
  final String id;
  final String name;
  final String email;
  const User({required this.id, required this.name, required this.email});
}

class Account {
  final String id;
  final String name;
  final AccountType type;
  final double balance;
  const Account({
    required this.id,
    required this.name,
    required this.type,
    required this.balance,
  });
}

class Transaction {
  final String id;
  final String accountId;
  final double amount;
  final String description;
  final DateTime date;
  final TransactionType type;
  const Transaction({
    required this.id,
    required this.accountId,
    required this.amount,
    required this.description,
    required this.date,
    required this.type,
  });
}

class AppNotification {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  final bool read;
  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    this.read = false,
  });
}
