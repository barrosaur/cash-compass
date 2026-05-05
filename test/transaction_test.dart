import 'package:flutter_test/flutter_test.dart';
import 'package:cash_compass/classes/transaction.dart';
import 'package:cash_compass/classes/base_item.dart';

void main() {
  // Shared fixtures
  final testAccount = Account(
    id: 'acc-1',
    name: 'GCash',
    imgAsset: '📱',
  );

  final testCategory = Category(
    id: 'cat-1',
    name: 'Food',
    imgAsset: '🍔',
  );

  final testDate = DateTime(2025, 1, 15, 10, 30);

  group('TransactionMode', () {
    test('income has index 0', () {
      expect(TransactionMode.income.index, equals(0));
    });

    test('expense has index 1', () {
      expect(TransactionMode.expense.index, equals(1));
    });

    test('label returns uppercased name for income', () {
      expect(
        TransactionMode.income.label,
        equals('INCOME'),
      );
    });

    test('label returns uppercased name for expense', () {
      expect(
        TransactionMode.expense.label,
        equals('EXPENSE'),
      );
    });

    test('values contains exactly income and expense', () {
      expect(TransactionMode.values.length, equals(2));
      expect(
        TransactionMode.values,
        contains(TransactionMode.income),
      );
      expect(
        TransactionMode.values,
        contains(TransactionMode.expense),
      );
    });

    test('can recover mode from index via values', () {
      expect(
        TransactionMode.values[0],
        equals(TransactionMode.income),
      );
      expect(
        TransactionMode.values[1],
        equals(TransactionMode.expense),
      );
    });
  });

  group('Transaction', () {
    test('creates with all required fields', () {
      final t = Transaction(
        id: 'txn-001',
        category: testCategory,
        account: testAccount,
        amount: 150.0,
        mode: TransactionMode.expense,
        date: testDate,
      );

      expect(t.id, equals('txn-001'));
      expect(t.category, equals(testCategory));
      expect(t.account, equals(testAccount));
      expect(t.amount, equals(150.0));
      expect(t.mode, equals(TransactionMode.expense));
      expect(t.date, equals(testDate));
      expect(t.description, isNull);
    });

    test(
      'description defaults to null when not provided',
      () {
        final t = Transaction(
          id: 'txn-002',
          category: testCategory,
          account: testAccount,
          amount: 500.0,
          mode: TransactionMode.income,
          date: testDate,
        );

        expect(t.description, isNull);
      },
    );

    test('creates with optional description', () {
      final t = Transaction(
        id: 'txn-003',
        category: testCategory,
        account: testAccount,
        amount: 200.0,
        mode: TransactionMode.expense,
        date: testDate,
        description: 'Jollibee dinner',
      );

      expect(t.description, equals('Jollibee dinner'));
    });

    test('amount can be a decimal value', () {
      final t = Transaction(
        id: 'txn-004',
        category: testCategory,
        account: testAccount,
        amount: 99.99,
        mode: TransactionMode.expense,
        date: testDate,
      );

      expect(t.amount, closeTo(99.99, 0.001));
    });

    test('amount can be zero', () {
      final t = Transaction(
        id: 'txn-005',
        category: testCategory,
        account: testAccount,
        amount: 0.0,
        mode: TransactionMode.expense,
        date: testDate,
      );

      expect(t.amount, equals(0.0));
    });

    test('income mode is stored correctly', () {
      final t = Transaction(
        id: 'txn-006',
        category: testCategory,
        account: testAccount,
        amount: 15000.0,
        mode: TransactionMode.income,
        date: testDate,
      );

      expect(t.mode, equals(TransactionMode.income));
      expect(t.mode.label, equals('INCOME'));
    });

    test('date is stored with full precision', () {
      final precise = DateTime(
        2025,
        6,
        15,
        14,
        30,
        45,
        123,
      );
      final t = Transaction(
        id: 'txn-007',
        category: testCategory,
        account: testAccount,
        amount: 100.0,
        mode: TransactionMode.expense,
        date: precise,
      );

      expect(t.date, equals(precise));
    });

    test('holds reference to its account', () {
      final t = Transaction(
        id: 'txn-008',
        category: testCategory,
        account: testAccount,
        amount: 300.0,
        mode: TransactionMode.expense,
        date: testDate,
      );

      expect(t.account.name, equals('GCash'));
      expect(t.account.imgAsset, equals('📱'));
    });

    test('holds reference to its category', () {
      final t = Transaction(
        id: 'txn-009',
        category: testCategory,
        account: testAccount,
        amount: 300.0,
        mode: TransactionMode.expense,
        date: testDate,
      );

      expect(t.category.name, equals('Food'));
      expect(t.category.imgAsset, equals('🍔'));
    });

    test(
      'description can be an empty string when explicitly set',
      () {
        final t = Transaction(
          id: 'txn-010',
          category: testCategory,
          account: testAccount,
          amount: 50.0,
          mode: TransactionMode.expense,
          date: testDate,
          description: '',
        );

        // Empty string is distinct from null
        expect(t.description, equals(''));
      },
    );
  });

  group(
    'Transaction grouping by date (RecordsBody logic)',
    () {
      Map<DateTime, List<Transaction>> groupByDate(
        List<Transaction> all,
      ) {
        final map = <DateTime, List<Transaction>>{};
        for (final t in all) {
          final day = DateTime(
            t.date.year,
            t.date.month,
            t.date.day,
          );
          map.putIfAbsent(day, () => []).add(t);
        }
        for (final list in map.values) {
          list.sort((a, b) => b.date.compareTo(a.date));
        }
        return map;
      }

      test('groups transactions by calendar day', () {
        final t1 = Transaction(
          id: 't1',
          category: testCategory,
          account: testAccount,
          amount: 100,
          mode: TransactionMode.expense,
          date: DateTime(2025, 1, 15, 9, 0),
        );
        final t2 = Transaction(
          id: 't2',
          category: testCategory,
          account: testAccount,
          amount: 200,
          mode: TransactionMode.expense,
          date: DateTime(2025, 1, 15, 18, 0),
        );
        final t3 = Transaction(
          id: 't3',
          category: testCategory,
          account: testAccount,
          amount: 300,
          mode: TransactionMode.income,
          date: DateTime(2025, 1, 16, 12, 0),
        );

        final grouped = groupByDate([t1, t2, t3]);

        expect(grouped.length, equals(2));
        expect(
          grouped[DateTime(2025, 1, 15)]?.length,
          equals(2),
        );
        expect(
          grouped[DateTime(2025, 1, 16)]?.length,
          equals(1),
        );
      });

      test(
        'within a day, transactions are sorted newest-first',
        () {
          final morning = Transaction(
            id: 'am',
            category: testCategory,
            account: testAccount,
            amount: 50,
            mode: TransactionMode.expense,
            date: DateTime(2025, 3, 10, 8, 0),
          );
          final afternoon = Transaction(
            id: 'pm',
            category: testCategory,
            account: testAccount,
            amount: 80,
            mode: TransactionMode.expense,
            date: DateTime(2025, 3, 10, 15, 30),
          );

          final grouped = groupByDate([morning, afternoon]);
          final list = grouped[DateTime(2025, 3, 10)]!;

          expect(list.first.id, equals('pm'));
          expect(list.last.id, equals('am'));
        },
      );

      test('empty transaction list produces empty map', () {
        final grouped = groupByDate([]);
        expect(grouped, isEmpty);
      });
    },
  );
}
