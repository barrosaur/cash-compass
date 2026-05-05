import 'package:flutter_test/flutter_test.dart';
import 'package:cash_compass/classes/base_item.dart';

void main() {
  group('Account', () {
    test('creates with all required fields', () {
      final account = Account(
        id: 'acc-001',
        name: 'Cash Wallet',
        imgAsset: '💵',
      );

      expect(account.id, equals('acc-001'));
      expect(account.name, equals('Cash Wallet'));
      expect(account.imgAsset, equals('💵'));
    });

    test('name can be any non-empty string', () {
      final account = Account(
        id: 'acc-002',
        name: 'My Bank Account - Savings',
        imgAsset: '🏦',
      );

      expect(
        account.name,
        equals('My Bank Account - Savings'),
      );
    });

    test('imgAsset can be empty string', () {
      final account = Account(
        id: 'acc-003',
        name: 'Unnamed',
        imgAsset: '',
      );

      expect(account.imgAsset, equals(''));
    });

    test('id is stored as-is (no mutation)', () {
      const rawId = '1748000000000';
      final account = Account(
        id: rawId,
        name: 'Test',
        imgAsset: '🧪',
      );

      expect(account.id, equals(rawId));
    });

    test(
      'two accounts with different ids are independent',
      () {
        final a1 = Account(
          id: 'a1',
          name: 'GCash',
          imgAsset: '📱',
        );
        final a2 = Account(
          id: 'a2',
          name: 'BDO',
          imgAsset: '🏦',
        );

        expect(a1.id, isNot(equals(a2.id)));
        expect(a1.name, isNot(equals(a2.name)));
      },
    );
  });

  group('Category', () {
    test('creates with all required fields', () {
      final category = Category(
        id: 'cat-001',
        name: 'Food',
        imgAsset: '🍔',
      );

      expect(category.id, equals('cat-001'));
      expect(category.name, equals('Food'));
      expect(category.imgAsset, equals('🍔'));
    });

    test('imgAsset supports various emoji strings', () {
      final emojis = ['🍕', '🚗', '🏠', '💊', '🎮'];
      for (final emoji in emojis) {
        final cat = Category(
          id: 'c',
          name: 'Test',
          imgAsset: emoji,
        );
        expect(cat.imgAsset, equals(emoji));
      }
    });

    test('name supports unicode characters', () {
      final category = Category(
        id: 'cat-unicode',
        name: 'Pagkain', // Filipino word for food
        imgAsset: '🍚',
      );

      expect(category.name, equals('Pagkain'));
    });

    test(
      'two categories with same name but different ids are distinct',
      () {
        final c1 = Category(
          id: 'c1',
          name: 'Transport',
          imgAsset: '🚌',
        );
        final c2 = Category(
          id: 'c2',
          name: 'Transport',
          imgAsset: '🚗',
        );

        expect(c1.id, isNot(equals(c2.id)));
        expect(c1.imgAsset, isNot(equals(c2.imgAsset)));
      },
    );
  });

  group('Account vs Category', () {
    test('Account and Category are different types', () {
      final account = Account(
        id: 'a1',
        name: 'Wallet',
        imgAsset: '👛',
      );
      final category = Category(
        id: 'c1',
        name: 'Wallet',
        imgAsset: '👛',
      );

      expect(account, isA<Account>());
      expect(account, isNot(isA<Category>()));
      expect(category, isA<Category>());
      expect(category, isNot(isA<Account>()));
    });

    test('both extend BaseItem', () {
      final account = Account(
        id: 'a',
        name: 'A',
        imgAsset: '',
      );
      final category = Category(
        id: 'c',
        name: 'C',
        imgAsset: '',
      );

      expect(account, isA<BaseItem>());
      expect(category, isA<BaseItem>());
    });
  });
}
