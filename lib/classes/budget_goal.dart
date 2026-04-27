import 'package:hive/hive.dart';
part 'budget_goal.g.dart';

@HiveType(typeId: 4)
enum GoalStatus {
  @HiveField(0)
  ongoing,
  @HiveField(1)
  achieved,
  @HiveField(2)
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

@HiveType(typeId: 5)
class BudgetGoal {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final GoalStatus status;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final DateTime fromDate;

  @HiveField(5)
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
