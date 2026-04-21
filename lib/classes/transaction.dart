import 'base_item.dart';

enum TransactionMode { income, expense }

extension TransactionModelLabel on TransactionMode {
  String get label => name.toUpperCase();
}

class Transaction {
  final String id;
  final Category category;
  final Account account;
  final double amount;
  final TransactionMode mode;
  final DateTime date;
  final String? description;

  Transaction({
    required this.id,
    required this.category,
    required this.account,
    required this.amount,
    required this.mode,
    required this.date,
    this.description,
  });
}
