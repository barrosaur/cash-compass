import 'package:flutter/material.dart';
import 'package:cash_compass/widgets/title.dart';
import 'package:cash_compass/widgets/add_btn.dart';
import 'package:cash_compass/widgets/category_account_tile.dart';
import 'package:cash_compass/widgets/add_popup.dart';
import 'package:cash_compass/constants/colors.dart' as clr;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cash_compass/classes/base_item.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({super.key});

  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  bool _popupVisible = false;
  final TextEditingController accName =
      TextEditingController();
  String _pendingEmoji = "";
  late final Box<Account> _accountBox;

  @override
  void initState() {
    super.initState();
    _accountBox = Hive.box<Account>('accounts');
  }

  void _onSave() {
    final name = accName.text.trim();
    if (name.isEmpty) return;

    final newAccount = Account(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      imgAsset: _pendingEmoji,
    );

    _accountBox.add(newAccount);

    setState(() {
      _popupVisible = false;
    });
    accName.clear();
    _pendingEmoji = "";
  }

  void _onDelete(int hiveIndex) {
    _accountBox.deleteAt(hiveIndex);
    setState(() {});
  }

  @override
  void dispose() {
    accName.dispose();
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
              CustomTitle(title: "ACCOUNTS"),
              const SizedBox(height: 20.0),
              if (_accountBox.isEmpty)
                Center(
                  child: Text(
                    "ADD ACCOUNT...",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: clr.textGreyBlue,
                    ),
                  ),
                )
              else
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: _accountBox
                        .listenable(),
                    builder:
                        (context, Box<Account> box, _) {
                          return ListView.builder(
                            itemCount: box.length,
                            itemBuilder: (context, index) {
                              final acc = box.getAt(index)!;
                              return CategoryAccountTile(
                                emoji: acc.imgAsset,
                                name: acc.name,
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
                  popupTitle: "ADD ACCOUNT",
                  hintText: "Enter Account Name...",
                  controller: accName,
                  onSave: _onSave,
                  onCancel: () {
                    setState(() => _popupVisible = false);
                    accName.clear();
                    _pendingEmoji = "";
                  },
                  onEmojiSelected: (emoji) {
                    _pendingEmoji = emoji;
                  },
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