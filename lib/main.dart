import 'package:cash_compass/classes/base_item.dart';
import 'package:flutter/material.dart';
import 'widgets/expense_record.dart';
import 'classes/transaction.dart';
import 'widgets/appbar.dart';

void main() {
  runApp(MaterialApp(home: const RecordsPage()));
}

class RecordsPage extends StatelessWidget {
  const RecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    Transaction sample = Transaction(
      id: "1",
      category: Category(
        name: "Food",
        imgAsset: "assets/images/cash-on-hand.svg",
        id: "1",
      ),
      account: Account(
        name: "Cash On Hand",
        imgAsset: "assets/images/cash-on-hand",
        id: "1",
      ),
      amount: 3500,
      mode: TransactionMode.income,
      date: DateTime.now(),
    );

    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(
          vertical: 20.0,
          horizontal: 10.0,
        ),
        child: Column(
          children: [
            ExpenseRecord(
              transaction: sample,
              onDelete: () {
                debugPrint("DELETED!");
              },
            ),
            const SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}
