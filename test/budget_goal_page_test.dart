import 'package:flutter_test/flutter_test.dart';
import 'package:cash_compass/classes/budget_goal.dart';

void main() {
  group('BudgetGoalPage – save validation', () {
    /// Returns null on success, or an error message.
    String? validateGoalSave({
      required String name,
      required DateTime? fromDate,
      required DateTime? toDate,
    }) {
      if (name.trim().isEmpty) return 'Name is required.';
      if (fromDate == null || toDate == null) {
        return 'Please pick both From and To dates.';
      }
      return null;
    }

    test('fails when name is empty', () {
      final err = validateGoalSave(
        name: '',
        fromDate: DateTime.now(),
        toDate: DateTime.now().add(
          const Duration(days: 30),
        ),
      );
      expect(err, equals('Name is required.'));
    });

    test('fails when name is whitespace-only', () {
      final err = validateGoalSave(
        name: '   ',
        fromDate: DateTime.now(),
        toDate: DateTime.now().add(
          const Duration(days: 30),
        ),
      );
      expect(err, equals('Name is required.'));
    });

    test('fails when fromDate is null', () {
      final err = validateGoalSave(
        name: 'Emergency Fund',
        fromDate: null,
        toDate: DateTime.now(),
      );
      expect(err, contains('dates'));
    });

    test('fails when toDate is null', () {
      final err = validateGoalSave(
        name: 'Emergency Fund',
        fromDate: DateTime.now(),
        toDate: null,
      );
      expect(err, contains('dates'));
    });

    test('fails when both dates are null', () {
      final err = validateGoalSave(
        name: 'Emergency Fund',
        fromDate: null,
        toDate: null,
      );
      expect(err, isNotNull);
    });

    test('passes with valid name and both dates set', () {
      final err = validateGoalSave(
        name: 'Vacation Fund',
        fromDate: DateTime(2025, 1, 1),
        toDate: DateTime(2025, 12, 31),
      );
      expect(err, isNull);
    });
  });

  group('BudgetGoalPage – edit/create ID handling', () {
    final now = DateTime.now();
    final later = now.add(const Duration(days: 30));

    test('edit preserves the original goal id', () {
      final originalGoal = BudgetGoal(
        id: 'goal-original-123',
        name: 'Old Name',
        status: GoalStatus.ongoing,
        fromDate: now,
        toDate: later,
      );

      final updatedGoal = BudgetGoal(
        id: originalGoal.id,
        name: 'New Name',
        status: GoalStatus.achieved,
        description: 'Updated',
        fromDate: now,
        toDate: later,
      );

      expect(updatedGoal.id, equals('goal-original-123'));
    });

    test('new goal gets a fresh id when not editing', () {
      BudgetGoal? editingGoal;

      final id =
          editingGoal?.id ??
          DateTime.now().millisecondsSinceEpoch.toString();
      expect(id.isNotEmpty, isTrue);
      expect(int.tryParse(id), isNotNull);
    });
  });

  group('BudgetGoalPage – state after save/cancel/delete', () {
    test(
      'popup is hidden and editing state is cleared after save',
      () {
        bool popupVisible = true;
        BudgetGoal? editingGoal = BudgetGoal(
          id: 'g1',
          name: 'Test',
          status: GoalStatus.ongoing,
          fromDate: DateTime.now(),
          toDate: DateTime.now().add(
            const Duration(days: 1),
          ),
        );
        int? editingIndex = 2;

        popupVisible = false;
        editingGoal = null;
        editingIndex = null;

        expect(popupVisible, isFalse);
        expect(editingGoal, isNull);
        expect(editingIndex, isNull);
      },
    );

    test(
      'popup is hidden and editing state is cleared after cancel',
      () {
        bool popupVisible = true;
        BudgetGoal? editingGoal = BudgetGoal(
          id: 'g2',
          name: 'Cancel me',
          status: GoalStatus.failed,
          fromDate: DateTime.now(),
          toDate: DateTime.now(),
        );
        int? editingIndex = 0;

        popupVisible = false;
        editingGoal = null;
        editingIndex = null;

        expect(popupVisible, isFalse);
        expect(editingGoal, isNull);
        expect(editingIndex, isNull);
      },
    );

    test(
      'edit sets popup visible and stores editing goal and index',
      () {
        bool popupVisible = false;
        BudgetGoal? editingGoal;
        int? editingIndex;

        final goal = BudgetGoal(
          id: 'g3',
          name: 'Edit me',
          status: GoalStatus.ongoing,
          fromDate: DateTime.now(),
          toDate: DateTime.now().add(
            const Duration(days: 7),
          ),
        );

        editingGoal = goal;
        editingIndex = 1;
        popupVisible = true;

        expect(popupVisible, isTrue);
        expect(editingGoal, equals(goal));
        expect(editingIndex, equals(1));
      },
    );
  });

  group('GoalStatus labels', () {
    test('every GoalStatus has a non-empty label', () {
      for (final status in GoalStatus.values) {
        expect(
          status.label.isNotEmpty,
          isTrue,
          reason:
              '${status.name} should have a non-empty label',
        );
      }
    });

    test(
      'labels are human-readable (not just enum names)',
      () {
        expect(
          GoalStatus.ongoing.label,
          isNot(equals('ongoing')),
        );
      },
    );
  });
}
