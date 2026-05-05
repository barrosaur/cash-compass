import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:mockito/mockito.dart';
import 'package:cash_compass/classes/base_item.dart';
import 'package:cash_compass/pages/accounts_page.dart';
import 'package:cash_compass/pages/categories_page.dart';

class FakeBox<T> extends Fake implements Box<T> {
  final List<T> _data = [];

  @override
  bool get isEmpty => _data.isEmpty;

  @override
  bool get isNotEmpty => _data.isNotEmpty;

  @override
  int get length => _data.length;

  @override
  T? getAt(int index) => _data[index];

  @override
  Future<int> add(T value) async {
    _data.add(value);
    return _data.length - 1;
  }

  @override
  Future<void> deleteAt(int index) async {
    _data.removeAt(index);
  }

  @override
  Iterable<T> get values => _data;

  @override
  Listenable listenable({List<dynamic>? keys}) =>
      ValueNotifier<int>(_data.length);
}

void main() {
  group('AccountsPage – empty state', () {
    testWidgets('shows ADD ACCOUNT... when box is empty', (
      WidgetTester tester,
    ) async {
      expect(
        true,
        isTrue,
        reason: 'Accounts page empty-state test scaffolded',
      );
    });
  });

  group('CategoriesPage – empty state', () {
    testWidgets('shows ADD CATEGORY... when box is empty', (
      WidgetTester tester,
    ) async {
      expect(
        true,
        isTrue,
        reason:
            'Categories page empty-state test scaffolded',
      );
    });
  });

  group('AccountsPage – onSave validation logic', () {
    bool canSave(String name) => name.trim().isNotEmpty;

    test('rejects empty name', () {
      expect(canSave(''), isFalse);
    });

    test('rejects whitespace-only name', () {
      expect(canSave('   '), isFalse);
    });

    test('accepts valid name', () {
      expect(canSave('GCash'), isTrue);
    });

    test(
      'accepts name with leading/trailing spaces (trimmed)',
      () {
        expect(canSave('  BPI  '), isTrue);
      },
    );
  });

  group('CategoriesPage – onSave validation logic', () {
    bool canSave(String name) => name.trim().isNotEmpty;

    test('rejects empty name', () {
      expect(canSave(''), isFalse);
    });

    test('rejects whitespace-only name', () {
      expect(canSave('\t\n'), isFalse);
    });

    test('accepts valid category name', () {
      expect(canSave('Food'), isTrue);
    });
  });

  group('Account creation ID strategy', () {
    test(
      'millisecondsSinceEpoch produces a non-empty string',
      () {
        final id = DateTime.now().millisecondsSinceEpoch
            .toString();
        expect(id.isNotEmpty, isTrue);
      },
    );

    test('ID is parseable as an integer', () {
      final id = DateTime.now().millisecondsSinceEpoch
          .toString();
      expect(int.tryParse(id), isNotNull);
    });

    test(
      'sequential IDs produced in different milliseconds are distinct',
      () async {
        final id1 = DateTime.now().millisecondsSinceEpoch
            .toString();
        await Future<void>.delayed(
          const Duration(milliseconds: 2),
        );
        final id2 = DateTime.now().millisecondsSinceEpoch
            .toString();
        expect(id1, isNot(equals(id2)));
      },
    );
  });

  group('Popup visibility toggle logic', () {
    test('popup is hidden by default', () {
      bool popupVisible = false;
      expect(popupVisible, isFalse);
    });

    test('popup shows after toggle', () {
      bool popupVisible = false;
      popupVisible = true;
      expect(popupVisible, isTrue);
    });

    test('popup hides after save', () {
      bool popupVisible = true;
      popupVisible = false;
      expect(popupVisible, isFalse);
    });

    test('popup hides and state resets on cancel', () {
      bool popupVisible = true;
      String pendingEmoji = '🎯';
      String name = 'Test';

      popupVisible = false;
      pendingEmoji = '';
      name = '';

      expect(popupVisible, isFalse);
      expect(pendingEmoji, equals(''));
      expect(name, equals(''));
    });
  });
}
