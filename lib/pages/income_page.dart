import 'package:flutter/material.dart';
import 'package:cash_compass/widgets/calculator.dart';
import 'package:cash_compass/widgets/cstm_btn.dart';
import 'package:cash_compass/constants/colors.dart' as clr;
import 'package:cash_compass/classes/base_item.dart';
import 'package:cash_compass/widgets/account_picker.dart';
import 'package:cash_compass/widgets/category_picker.dart';

class IncomePage extends StatefulWidget {
  final Account? selectedAccount;
  final Category? selectedCategory;
  final double amount;
  final String description;
  final ValueChanged<Account?> onAccountChanged;
  final ValueChanged<Category?> onCategoryChanged;
  final ValueChanged<double> onAmountChanged;
  final ValueChanged<String> onDescriptionChanged;

  const IncomePage({
    super.key,
    required this.selectedAccount,
    required this.selectedCategory,
    required this.amount,
    required this.description,
    required this.onAccountChanged,
    required this.onCategoryChanged,
    required this.onAmountChanged,
    required this.onDescriptionChanged,
  });

  @override
  State<IncomePage> createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.description,
    );
  }

  @override
  void didUpdateWidget(covariant IncomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync controller when parent resets description
    if (widget.description != oldWidget.description &&
        widget.description != _controller.text) {
      _controller.text = widget.description;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CstmBtn(
                btnLabel:
                    widget.selectedAccount?.name ??
                    "Account",
                emoji: widget.selectedAccount?.imgAsset,
                icon: Icons.wallet,
                bgColor: clr.matteblack,
                txtColor: Colors.white,
                onPressed: () async {
                  final picked = await showAccountPicker(
                    context,
                  );
                  if (picked != null)
                    widget.onAccountChanged(picked);
                },
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: CstmBtn(
                btnLabel:
                    widget.selectedCategory?.name ??
                    "Category",
                emoji: widget.selectedCategory?.imgAsset,
                icon: Icons.category,
                bgColor: clr.matteblack,
                txtColor: Colors.white,
                onPressed: () async {
                  final picked = await showCategoryPicker(
                    context,
                  );
                  if (picked != null)
                    widget.onCategoryChanged(picked);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 125,
          child: TextField(
            expands: true,
            minLines: null,
            maxLines: null,
            textAlignVertical: TextAlignVertical.top,
            decoration: InputDecoration(
              hintText: "Add description...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: clr.matteblack,
                ),
              ),
            ),
            cursorColor: clr.matteblack,
            controller: _controller,
            onChanged: widget.onDescriptionChanged,
          ),
        ),
        const SizedBox(height: 10),
        Calculator(
          initialValue: widget.amount,
          onValueChanged: widget.onAmountChanged,
        ),
      ],
    );
  }
}
