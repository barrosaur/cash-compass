import 'package:flutter/material.dart';
import 'package:cash_compass/widgets/transaction_nav.dart';
import 'package:cash_compass/pages/income_page.dart';
import 'package:cash_compass/pages/expense_page.dart';
import 'package:cash_compass/widgets/title.dart';
import 'package:cash_compass/constants/colors.dart' as clr;
import 'package:cash_compass/classes/transaction.dart';
import 'package:cash_compass/classes/base_item.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

class TransactionPage extends StatefulWidget {
  final Transaction? existing;
  final VoidCallback?
  onSaved; // called after save so parent can switch tab

  const TransactionPage({
    super.key,
    this.existing,
    this.onSaved,
  });

  @override
  State<TransactionPage> createState() =>
      _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  late int _selectedIndex;
  Account? _selectedAccount;
  Category? _selectedCategory;
  double _amount = 0;
  String _description = '';
  DateTime _date = DateTime.now();

  @override
  void initState() {
    super.initState();
    _prefill(widget.existing);
  }

  void _prefill(Transaction? t) {
    if (t != null) {
      _selectedIndex = t.mode.index;
      _selectedAccount = t.account;
      _selectedCategory = t.category;
      _amount = t.amount;
      _description = t.description ?? '';
      _date = t.date;
    } else {
      _selectedIndex = 1;
      _selectedAccount = null;
      _selectedCategory = null;
      _amount = 0;
      _description = '';
      _date = DateTime.now();
    }
  }

  void _reset() {
    setState(() => _prefill(null));
  }

  List<Widget> get _pages => [
    IncomePage(
      selectedAccount: _selectedAccount,
      selectedCategory: _selectedCategory,
      amount: _amount,
      description: _description,
      onAccountChanged: (a) =>
          setState(() => _selectedAccount = a),
      onCategoryChanged: (c) =>
          setState(() => _selectedCategory = c),
      onAmountChanged: (v) => setState(() => _amount = v),
      onDescriptionChanged: (s) =>
          setState(() => _description = s),
    ),
    ExpensePage(
      selectedAccount: _selectedAccount,
      selectedCategory: _selectedCategory,
      amount: _amount,
      description: _description,
      onAccountChanged: (a) =>
          setState(() => _selectedAccount = a),
      onCategoryChanged: (c) =>
          setState(() => _selectedCategory = c),
      onAmountChanged: (v) => setState(() => _amount = v),
      onDescriptionChanged: (s) =>
          setState(() => _description = s),
    ),
  ];

  Future<void> _save() async {
    if (_amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an amount.'),
        ),
      );
      return;
    }
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a category.'),
        ),
      );
      return;
    }
    if (_selectedAccount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an account.'),
        ),
      );
      return;
    }

    final mode = TransactionMode.values[_selectedIndex];
    final box = Hive.box<Transaction>('transaction');

    if (widget.existing != null) {
      final key = box.keys.firstWhere(
        (k) => box.get(k)?.id == widget.existing!.id,
        orElse: () => null,
      );
      if (key != null) {
        await box.put(
          key,
          Transaction(
            id: widget.existing!.id,
            category: _selectedCategory!,
            account: _selectedAccount!,
            amount: _amount,
            mode: mode,
            date: _date,
            description: _description.isEmpty
                ? null
                : _description,
          ),
        );
      }
      if (mounted) Navigator.of(context).pop();
    } else {
      await box.add(
        Transaction(
          id: const Uuid().v4(),
          category: _selectedCategory!,
          account: _selectedAccount!,
          amount: _amount,
          mode: mode,
          date: _date,
          description: _description.isEmpty
              ? null
              : _description,
        ),
      );
      _reset();
      widget.onSaved?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            CustomTitle(title: "TRANSACTIONS"),
            const Spacer(),
            IconButton(
              onPressed: _save,
              icon: Icon(
                Icons.save,
                color: clr.matteblack,
                size: 30,
              ),
            ),
          ],
        ),
        TransactionNav(
          labels: const ['INCOME', 'EXPENSE'],
          selectedIndex: _selectedIndex,
          onTap: (idx) =>
              setState(() => _selectedIndex = idx),
        ),
        Expanded(child: _pages[_selectedIndex]),
      ],
    );
  }
}
