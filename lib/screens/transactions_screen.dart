import 'package:flutter/material.dart';

class TransactionsScreen extends StatelessWidget {
  final String accountId;
  const TransactionsScreen({super.key, required this.accountId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Transactions for $accountId')),
    );
  }
}
