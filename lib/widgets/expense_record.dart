import 'package:flutter/material.dart';
import 'package:cash_compass/classes/transaction.dart';
import 'package:cash_compass/constants/colors.dart' as clr;

class ExpenseRecord extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onDelete;
  final VoidCallback? onTap;

  const ExpenseRecord({
    super.key,
    required this.transaction,
    required this.onDelete,
    this.onTap,
  });

  Color get _amountColor {
    switch (transaction.mode) {
      case TransactionMode.income:
        return clr.green;
      case TransactionMode.expense:
        return clr.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    const double iconSize = 55;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              height: iconSize,
              width: iconSize,
              decoration: BoxDecoration(
                color: clr.greyBlue,
                borderRadius: BorderRadius.circular(6),
              ),
              alignment: Alignment.center,
              child:
                  transaction.category.imgAsset.isNotEmpty
                  ? Text(
                      transaction.category.imgAsset,
                      style: const TextStyle(fontSize: 28),
                    )
                  : Icon(
                      Icons.category,
                      color: clr.greyBlue,
                      size: 28,
                    ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.category.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: "Inter",
                    ),
                  ),
                  Text(
                    transaction.account.name,
                    style: TextStyle(
                      color: clr.greyBlue,
                      fontSize: 12,
                      fontFamily: "Inter",
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "${transaction.mode.label}: ",
                        style: const TextStyle(
                          fontFamily: "Inter",
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        "P${transaction.mode.label}: ",
                        style: const TextStyle(
                          fontFamily: "Inter",
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        "P${transaction.amount.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _amountColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            //delete
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete),
              color: clr.matteblack,
              iconSize: 26,
            ),
          ],
        ),
      ),
    );
  }
}
