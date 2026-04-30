import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cash_compass/classes/base_item.dart';

Future<Category?> showCategoryPicker(BuildContext context) {
  return showModalBottomSheet<Category>(
    context: context,
    builder: (ctx) {
      final box = Hive.box<Category>('categories');
      final categories = box.values.toList();

      if (categories.isEmpty) {
        return const Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'No categories yet. Add one in the Categories tab.',
          ),
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        itemCount: categories.length,
        itemBuilder: (_, i) => ListTile(
          leading: categories[i].imgAsset.isNotEmpty
              ? Text(
                  categories[i].imgAsset,
                  style: const TextStyle(fontSize: 24),
                )
              : const Icon(Icons.category),
          title: Text(categories[i].name),
          onTap: () => Navigator.of(ctx).pop(categories[i]),
        ),
      );
    },
  );
}
