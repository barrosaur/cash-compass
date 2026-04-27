import 'package:cash_compass/classes/base_item.dart';
import 'package:flutter/material.dart';
import 'package:cash_compass/widgets/add_popup.dart';
import 'package:cash_compass/widgets/title.dart';
import 'package:cash_compass/widgets/add_btn.dart';
import 'package:cash_compass/constants/colors.dart' as clr;
import 'package:hive_flutter/hive_flutter.dart';

import 'package:cash_compass/widgets/category_account_tile.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() =>
      _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  bool _popupVisible = false;
  final TextEditingController categoryName =
      TextEditingController();
  String _pendingEmoji = "";

  late final Box<Category> categoryBox;

  @override
  void initState() {
    super.initState();
    categoryBox = Hive.box<Category>('categories');
  }

  void _onSave() {
    final name = categoryName.text.trim();
    if (name.isEmpty) return;

    final newCategory = Category(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      imgAsset: _pendingEmoji,
    );

    categoryBox.add(newCategory);

    setState(() => _popupVisible = false);
    categoryName.clear();
    _pendingEmoji = "";
  }

  void _onDelete(int hiveIndex) {
    categoryBox.deleteAt(hiveIndex);
    setState(() {});
  }

  @override
  void dispose() {
    categoryName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTitle(title: "CATEGORIES"),
              const SizedBox(height: 20.0),
              if (categoryBox.isEmpty)
                Center(
                  child: Text(
                    "ADD CATEGORY...",
                    style: TextStyle(
                      fontSize: 25,
                      color: clr.textGreyBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              else
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: categoryBox
                        .listenable(),
                    builder:
                        (context, Box<Category> box, _) {
                          return ListView.builder(
                            itemCount: box.length,
                            itemBuilder: (context, index) {
                              final cat = box.getAt(index)!;
                              return CategoryAccountTile(
                                emoji: cat.imgAsset,
                                name: cat.name,
                                onDelete: () =>
                                    _onDelete(index),
                              );
                            },
                          );
                        },
                  ),
                ),
            ],
          ),
          if (_popupVisible)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                child: AddPopup(
                  popupTitle: "ADD CATEGORY",
                  hintText: "Enter Category Name...",
                  controller: categoryName,
                  onSave: _onSave,
                  onCancel: () {
                    setState(() => _popupVisible = false);
                    categoryName.clear();
                    _pendingEmoji = '';
                  },
                  onEmojiSelected: (emoji) =>
                      _pendingEmoji = emoji,
                ),
              ),
            ),
        ],
      ),

      floatingActionButton: Visibility(
        visible: !_popupVisible,
        child: AddBtn(
          onToggle: () =>
              setState(() => _popupVisible = true),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endDocked,
    );
  }
}