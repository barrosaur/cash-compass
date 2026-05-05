import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:cash_compass/classes/transaction.dart';
import 'package:cash_compass/classes/base_item.dart';

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

String formatDayHeader(DateTime day) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));

  final monthDay = DateFormat(
    'MMMM d, yyy',
  ).format(day).toUpperCase();
  final weekDay = DateFormat(
    'EEEE',
  ).format(day).toUpperCase();

  if (day == today) return '$monthDay: $weekDay • TODAY';
  if (day == yesterday)
    return '$monthDay: $weekDay • YESTERDAY';
  return '$monthDay: $weekDay';
}

final _account = Account(
  id: 'a',
  name: 'Wallet',
  imgAsset: '💰',
);
final _category = Category(
  id: 'c',
  name: 'Misc',
  imgAsset: '📦',
);

Transaction _txn(
  String id,
  DateTime date, {
  TransactionMode mode = TransactionMode.expense,
}) => Transaction(
  id: id,
  category: _category,
  account: _account,
  amount: 100.0,
  mode: mode,
  date: date,
);

void main() {
  group('groupByDate()', () {
    test('returns empty map for empty list', () {
      expect(groupByDate([]), isEmpty);
    });

    test('single transaction maps to its calendar day', () {
      final date = DateTime(2025, 3, 15, 9, 30);
      final t = _txn('t1', date);
      final grouped = groupByDate([t]);

      final key = DateTime(2025, 3, 15);
      expect(grouped.containsKey(key), isTrue);
      expect(grouped[key]!.length, equals(1));
    });

    test(
      'strips time component — uses midnight as key',
      () {
        final t = _txn(
          't1',
          DateTime(2025, 6, 10, 23, 59, 59),
        );
        final grouped = groupByDate([t]);
        final key = DateTime(2025, 6, 10);
        expect(grouped.containsKey(key), isTrue);
      },
    );

    test(
      'two transactions on the same day share one key',
      () {
        final t1 = _txn('t1', DateTime(2025, 6, 10, 8, 0));
        final t2 = _txn('t2', DateTime(2025, 6, 10, 20, 0));
        final grouped = groupByDate([t1, t2]);

        expect(grouped.length, equals(1));
        expect(
          grouped[DateTime(2025, 6, 10)]!.length,
          equals(2),
        );
      },
    );

    test(
      'transactions on different days produce different keys',
      () {
        final t1 = _txn('t1', DateTime(2025, 6, 10));
        final t2 = _txn('t2', DateTime(2025, 6, 11));
        final t3 = _txn('t3', DateTime(2025, 7, 1));
        final grouped = groupByDate([t1, t2, t3]);

        expect(grouped.length, equals(3));
      },
    );

    test(
      'within a day transactions are sorted newest first',
      () {
        final t1 = _txn('am', DateTime(2025, 5, 20, 7, 0));
        final t2 = _txn(
          'noon',
          DateTime(2025, 5, 20, 12, 0),
        );
        final t3 = _txn('pm', DateTime(2025, 5, 20, 18, 0));

        final grouped = groupByDate([t1, t3, t2]);
        final list = grouped[DateTime(2025, 5, 20)]!;

        expect(list[0].id, equals('pm'));
        expect(list[1].id, equals('noon'));
        expect(list[2].id, equals('am'));
      },
    );

    test(
      'mixed income and expense transactions are grouped together',
      () {
        final t1 = _txn(
          'income',
          DateTime(2025, 1, 1, 9, 0),
          mode: TransactionMode.income,
        );
        final t2 = _txn(
          'expense',
          DateTime(2025, 1, 1, 18, 0),
          mode: TransactionMode.expense,
        );

        final grouped = groupByDate([t1, t2]);
        expect(
          grouped[DateTime(2025, 1, 1)]!.length,
          equals(2),
        );
      },
    );

    test(
      'large number of transactions across many days',
      () {
        final transactions = List.generate(
          30,
          (i) =>
              _txn('t$i', DateTime(2025, 1, i + 1, 10, 0)),
        );

        final grouped = groupByDate(transactions);
        expect(grouped.length, equals(30));
      },
    );
  });

  group('formatDayHeader()', () {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(
      const Duration(days: 1),
    );

    test('appends • TODAY for today', () {
      final header = formatDayHeader(today);
      expect(header.endsWith('• TODAY'), isTrue);
    });

    test('appends • YESTERDAY for yesterday', () {
      final header = formatDayHeader(yesterday);
      expect(header.endsWith('• YESTERDAY'), isTrue);
    });

    test(
      'does not append TODAY or YESTERDAY for older dates',
      () {
        final older = today.subtract(
          const Duration(days: 2),
        );
        final header = formatDayHeader(older);
        expect(header.contains('TODAY'), isFalse);
        expect(header.contains('YESTERDAY'), isFalse);
      },
    );

    test('header is in all uppercase', () {
      final older = today.subtract(const Duration(days: 5));
      final header = formatDayHeader(older);
      expect(header, equals(header.toUpperCase()));
    });

    test('header contains the full month name', () {
      final specific = DateTime(2025, 3, 15);
      final header = formatDayHeader(specific);
      expect(header.contains('MARCH'), isTrue);
    });

    test('header contains the day of week', () {
      final specific = DateTime(2025, 3, 15);
      final header = formatDayHeader(specific);
      expect(header.contains('SATURDAY'), isTrue);
    });

    test(
      'today header contains the month and day number',
      () {
        final header = formatDayHeader(today);
        final dayNum = today.day.toString();
        expect(header.contains(dayNum), isTrue);
      },
    );

    test(
      'header separator uses a colon between date and weekday',
      () {
        final older = today.subtract(
          const Duration(days: 10),
        );
        final header = formatDayHeader(older);
        expect(header.contains(':'), isTrue);
      },
    );
  });

  group('sortedDays – newest day first', () {
    test('days are sorted in descending order', () {
      final t1 = _txn('t1', DateTime(2025, 1, 1));
      final t2 = _txn('t2', DateTime(2025, 3, 1));
      final t3 = _txn('t3', DateTime(2025, 2, 1));

      final grouped = groupByDate([t1, t2, t3]);
      final sortedDays = grouped.keys.toList()
        ..sort((a, b) => b.compareTo(a));

      expect(sortedDays[0], equals(DateTime(2025, 3, 1)));
      expect(sortedDays[1], equals(DateTime(2025, 2, 1)));
      expect(sortedDays[2], equals(DateTime(2025, 1, 1)));
    });
  });
}
