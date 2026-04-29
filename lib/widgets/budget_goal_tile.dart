import 'package:flutter/material.dart';
import 'package:cash_compass/classes/budget_goal.dart';
import 'package:cash_compass/constants/colors.dart' as clr;

class BudgetGoalTile extends StatelessWidget {
  final BudgetGoal budgetGoalTile;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const BudgetGoalTile({
    super.key,
    required this.budgetGoalTile,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    Color _colorPicker() {
      switch (budgetGoalTile.status) {
        case GoalStatus.achieved:
          return clr.green;
        case GoalStatus.failed:
          return clr.red;
        default:
          return Colors.white;
      }
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: clr.matteblack, width: 1),
        borderRadius: BorderRadius.circular(5),
        color: _colorPicker(),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsetsGeometry.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      budgetGoalTile.name,
                      style: TextStyle(
                        fontFamily: "Inter",
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Text("From: ", style: TextStyle(fontFamily: "Inter")),
                        Text(
                          "${budgetGoalTile.fromDate.month}/${budgetGoalTile.fromDate.day}/${budgetGoalTile.fromDate.year}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: clr.textGreyBlue,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Text("To: ", style: TextStyle(fontFamily: "Inter")),
                        Text(
                          "${budgetGoalTile.toDate.month}/${budgetGoalTile.toDate.day}/${budgetGoalTile.toDate.year}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: clr.textGreyBlue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onDelete,
                child: Icon(Icons.delete, color: clr.matteblack, size: 35),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
