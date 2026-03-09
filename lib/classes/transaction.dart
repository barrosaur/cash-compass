import 'base_item.dart';

enum TransactionMode { income, expense, transfer }

extension TransactionModeLabel on TransactionMode {
  String get label => name.toUpperCase();
}

class Transaction {
  final String id;
  final Category category;
  final Account account;
  final double amount;
  final TransactionMode mode;
  final Account? transferToAccount; // when mode == transfer
  final DateTime date;
  final String description;

  Transaction({
    required this.id,
    required this.category,
    required this.account,
    required this.amount,
    required this.mode,
    this.transferToAccount,
    required this.date,
    this.description = "",
  });
}
