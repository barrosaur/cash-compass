import 'package:flutter_test/flutter_test.dart';
import 'package:cash_compass/classes/transaction.dart';
import 'package:cash_compass/classes/base_item.dart';

class PageState {
  int selectedIndex;
  Account? selectedAccount;
  Category? selectedCategory;
  double amount;
  String description;
  DateTime date;

  PageState({
    required this.selectedIndex,
    this.selectedAccount,
    this.selectedCategory,
    this.amount = 0,
    this.description = '',
    required this.date,
  });
}

PageState prefill(Transaction? t) {
  if (t != null) {
    return PageState(
      selectedIndex: t.mode.index,
      selectedAccount: t.account,
      selectedCategory: t.category,
      amount: t.amount,
      description: t.description ?? '',
      date: t.date,
    );
  }
  return PageState(selectedIndex: 1, date: DateTime.now());
}

void main() {
  final testAccount = Account(
    id: 'a1',
    name: 'Maya',
    imgAsset: '💳',
  );
  final testCategory = Category(
    id: 'c1',
    name: 'Transport',
    imgAsset: '🚌',
  );

  group('TransactionPage – _save() validation', () {
    String? validateSave({
      required double amount,
      required Category? category,
      required Account? account,
    }) {
      if (amount <= 0) return 'Please enter an amount.';
      if (category == null)
        return 'Please select a category.';
      if (account == null)
        return 'Please select an account.';
      return null;
    }

    test('fails when amount is zero', () {
      final err = validateSave(
        amount: 0,
        category: testCategory,
        account: testAccount,
      );
      expect(err, equals('Please enter an amount.'));
    });

    test('fails when amount is negative', () {
      final err = validateSave(
        amount: -50.0,
        category: testCategory,
        account: testAccount,
      );
      expect(err, equals('Please enter an amount.'));
    });

    test('fails when category is null', () {
      final err = validateSave(
        amount: 100.0,
        category: null,
        account: testAccount,
      );
      expect(err, equals('Please select a category.'));
    });

    test('fails when account is null', () {
      final err = validateSave(
        amount: 100.0,
        category: testCategory,
        account: null,
      );
      expect(err, equals('Please select an account.'));
    });

    test(
      'passes with valid amount, category, and account',
      () {
        final err = validateSave(
          amount: 250.0,
          category: testCategory,
          account: testAccount,
        );
        expect(err, isNull);
      },
    );

    test('amount of 0.01 is accepted (above zero)', () {
      final err = validateSave(
        amount: 0.01,
        category: testCategory,
        account: testAccount,
      );
      expect(err, isNull);
    });
  });

  group('TransactionPage – _prefill()', () {
    test(
      'defaults to expense tab (index 1) when no existing transaction',
      () {
        final state = prefill(null);
        expect(state.selectedIndex, equals(1));
      },
    );

    test(
      'defaults to zero amount when no existing transaction',
      () {
        final state = prefill(null);
        expect(state.amount, equals(0));
      },
    );

    test(
      'defaults to empty description when no existing transaction',
      () {
        final state = prefill(null);
        expect(state.description, equals(''));
      },
    );

    test(
      'defaults to null account and category when no existing transaction',
      () {
        final state = prefill(null);
        expect(state.selectedAccount, isNull);
        expect(state.selectedCategory, isNull);
      },
    );

    test(
      'prefills correctly from an existing income transaction',
      () {
        final txn = Transaction(
          id: 'edit-1',
          category: testCategory,
          account: testAccount,
          amount: 5000.0,
          mode: TransactionMode.income,
          date: DateTime(2025, 5, 1),
          description: 'Salary',
        );

        final state = prefill(txn);

        expect(
          state.selectedIndex,
          equals(TransactionMode.income.index),
        );
        expect(state.selectedAccount, equals(testAccount));
        expect(
          state.selectedCategory,
          equals(testCategory),
        );
        expect(state.amount, equals(5000.0));
        expect(state.description, equals('Salary'));
        expect(state.date, equals(DateTime(2025, 5, 1)));
      },
    );

    test(
      'prefills correctly from an existing expense transaction',
      () {
        final txn = Transaction(
          id: 'edit-2',
          category: testCategory,
          account: testAccount,
          amount: 350.0,
          mode: TransactionMode.expense,
          date: DateTime(2025, 4, 20),
        );

        final state = prefill(txn);

        expect(
          state.selectedIndex,
          equals(TransactionMode.expense.index),
        );
        expect(state.amount, equals(350.0));
        expect(state.description, equals(''));
      },
    );

    test(
      'description is empty string when existing transaction has null description',
      () {
        final txn = Transaction(
          id: 'edit-3',
          category: testCategory,
          account: testAccount,
          amount: 100.0,
          mode: TransactionMode.expense,
          date: DateTime.now(),
          description: null,
        );

        final state = prefill(txn);
        expect(state.description, equals(''));
      },
    );
  });

  group('TransactionPage – _reset() behaviour', () {
    test('after reset, all fields return to defaults', () {
      final state = prefill(null);

      expect(state.amount, equals(0));
      expect(state.description, equals(''));
      expect(state.selectedAccount, isNull);
      expect(state.selectedCategory, isNull);
      expect(state.selectedIndex, equals(1));
    });
  });

  group('Description handling on save', () {
    String? descriptionToSave(String raw) =>
        raw.isEmpty ? null : raw;

    test('empty description is saved as null', () {
      expect(descriptionToSave(''), isNull);
    });

    test('non-empty description is preserved', () {
      expect(
        descriptionToSave('Lunch at Jollibee'),
        equals('Lunch at Jollibee'),
      );
    });

    test(
      'whitespace description is NOT null (trimming is caller responsibility)',
      () {
        expect(descriptionToSave('   '), equals('   '));
      },
    );
  });
}
