enum GoalStatus { ongoing, achieved, failed }

class BudgetGoal {
  final String id;
  final String name;
  final GoalStatus status;
  final String description;
  final DateTime fromDate;
  final DateTime toDate;

  BudgetGoal({
    required this.id,
    required this.name,
    required this.status,
    this.description = "",
    required this.fromDate,
    required this.toDate,
  });
}
