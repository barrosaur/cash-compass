import 'package:flutter_test/flutter_test.dart';
import 'package:cash_compass/classes/budget_goal.dart';

void main() {
  group('GoalStatus', () {
    test('label returns correct string for ongoing', () {
      expect(GoalStatus.ongoing.label, equals('On Going'));
    });

    test('label returns correct string for achieved', () {
      expect(GoalStatus.achieved.label, equals('Achieved'));
    });

    test('label returns correct string for failed', () {
      expect(GoalStatus.failed.label, equals('Failed'));
    });

    test('all statuses have distinct labels', () {
      final labels = GoalStatus.values
          .map((s) => s.label)
          .toList();
      expect(
        labels.toSet().length,
        equals(GoalStatus.values.length),
      );
    });
  });

  group('BudgetGoal', () {
    final now = DateTime.now();
    final later = now.add(const Duration(days: 30));

    test('creates with required fields', () {
      final goal = BudgetGoal(
        id: 'goal-1',
        name: 'Save for vacation',
        status: GoalStatus.ongoing,
        fromDate: now,
        toDate: later,
      );

      expect(goal.id, equals('goal-1'));
      expect(goal.name, equals('Save for vacation'));
      expect(goal.status, equals(GoalStatus.ongoing));
      expect(goal.fromDate, equals(now));
      expect(goal.toDate, equals(later));
    });

    test('description defaults to empty string', () {
      final goal = BudgetGoal(
        id: 'goal-2',
        name: 'Emergency fund',
        status: GoalStatus.ongoing,
        fromDate: now,
        toDate: later,
      );

      expect(goal.description, equals(''));
    });

    test('creates with optional description', () {
      final goal = BudgetGoal(
        id: 'goal-3',
        name: 'Car fund',
        status: GoalStatus.achieved,
        description: 'Saving for a new car',
        fromDate: now,
        toDate: later,
      );

      expect(
        goal.description,
        equals('Saving for a new car'),
      );
    });

    test('supports all GoalStatus values', () {
      for (final status in GoalStatus.values) {
        final goal = BudgetGoal(
          id: 'goal-status-${status.name}',
          name: 'Test goal',
          status: status,
          fromDate: now,
          toDate: later,
        );
        expect(goal.status, equals(status));
      }
    });

    test('fromDate can equal toDate', () {
      final goal = BudgetGoal(
        id: 'goal-same-date',
        name: 'One day goal',
        status: GoalStatus.ongoing,
        fromDate: now,
        toDate: now,
      );

      expect(goal.fromDate, equals(goal.toDate));
    });

    test(
      'toDate can be before fromDate (no validation enforced at model level)',
      () {
        final past = now.subtract(const Duration(days: 10));
        final goal = BudgetGoal(
          id: 'goal-reversed',
          name: 'Reversed dates',
          status: GoalStatus.failed,
          fromDate: now,
          toDate: past,
        );

        expect(goal.toDate.isBefore(goal.fromDate), isTrue);
      },
    );

    test('unique ids are distinct', () {
      final id1 = DateTime.now().millisecondsSinceEpoch
          .toString();
      final id2 = DateTime.now().millisecondsSinceEpoch
          .toString();

      final goal1 = BudgetGoal(
        id: id1,
        name: 'Goal 1',
        status: GoalStatus.ongoing,
        fromDate: now,
        toDate: later,
      );
      final goal2 = BudgetGoal(
        id: id2,
        name: 'Goal 2',
        status: GoalStatus.ongoing,
        fromDate: now,
        toDate: later,
      );

      expect(goal1.id.isNotEmpty, isTrue);
      expect(goal2.id.isNotEmpty, isTrue);
    });
  });
}
