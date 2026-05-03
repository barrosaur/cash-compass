import 'base_item.dart';
import 'package:hive/hive.dart';
part 'transaction.g.dart';

@HiveType(typeId: 1)
enum TransactionMode {
  @HiveField(0)
  income,

  @HiveField(1)
  expense,
}

extension TransactionModelLabel on TransactionMode {
  String get label => name.toUpperCase();
}

@HiveType(typeId: 6)
class Transaction {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final Category category;

  @HiveField(2)
  final Account account;

  @HiveField(3)
  final double amount;

  @HiveField(4)
  final TransactionMode mode;

  @HiveField(5)
  final DateTime date;

  @HiveField(6)
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
