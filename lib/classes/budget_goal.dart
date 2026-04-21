enum GoalStatus {
  ongoing,
  achieved,
  failed;

  String get label {
    switch (this) {
      case GoalStatus.ongoing:
        return "On Going";
      case GoalStatus.achieved:
        return "Achieved";
      case GoalStatus.failed:
        return "Failed";
    }
  }
}

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
