import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cash_compass/classes/base_item.dart';

Future<Account?> showAccountPicker(BuildContext context) {
  return showModalBottomSheet<Account>(
    context: context,
    builder: (ctx) {
      final box = Hive.box<Account>('accounts');
      final accounts = box.values.toList();

      if (accounts.isEmpty) {
        return const Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'No accounts yet. Add one in the Accounts tab.',
          ),
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        itemCount: accounts.length,
        itemBuilder: (_, i) => ListTile(
          leading: accounts[i].imgAsset.isNotEmpty
              ? Text(
                  accounts[i].imgAsset,
                  style: const TextStyle(fontSize: 24),
                )
              : const Icon(Icons.wallet),
          title: Text(accounts[i].name),
          onTap: () => Navigator.of(ctx).pop(accounts[i]),
        ),
      );
    },
  );
}
