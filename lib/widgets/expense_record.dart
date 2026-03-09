import 'package:flutter/material.dart';
import 'package:cash_compass/classes/transaction.dart';
import 'package:cash_compass/constants/colors.dart' as colr;

class ExpenseRecord extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onDelete;

  const ExpenseRecord({
    super.key,
    required this.transaction,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    double categoryIconHeight = 75;
    double categoryIconWidth = 75;

    return InkWell(
      onTap: () {
        debugPrint("Pressed");
      },
      child: Row(
        children: [
          Container(
            height: categoryIconHeight,
            width: categoryIconWidth,
            color: colr.greyBlue,
          ),
          const SizedBox(width: 25.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  transaction.category.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    fontFamily: "Inter",
                  ),
                ),
                Text(
                  transaction.account.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colr.greyBlue,
                    fontFamily: "Inter",
                  ),
                ),
                Row(
                  children: [
                    Text(
                      transaction.mode.label,
                      style: TextStyle(fontFamily: "Inter"),
                    ),
                    const Text(": P"),
                    Text(
                      transaction.amount.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 30.0),
          TextButton(
            onPressed: onDelete,
            style: TextButton.styleFrom(
              foregroundColor: colr.matteblack,
              iconSize: 35.0,
            ),
            child: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}
