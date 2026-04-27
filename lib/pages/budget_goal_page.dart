import 'package:cash_compass/classes/budget_goal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cash_compass/widgets/legend.dart';
import 'package:cash_compass/widgets/title.dart';
import 'package:cash_compass/widgets/add_btn.dart';
import 'package:cash_compass/widgets/budget_popup.dart';
import 'package:cash_compass/widgets/budget_goal_tile.dart';
import 'package:cash_compass/constants/colors.dart' as clr;
import 'package:hive_flutter/hive_flutter.dart';

class BudgetGoalPage extends StatefulWidget {
  const BudgetGoalPage({super.key});

  @override
  State<BudgetGoalPage> createState() => _BudgetGoalPageState();
}

class _BudgetGoalPageState extends State<BudgetGoalPage> {
  bool _popupVisible = false;
  BudgetGoal? _editingGoal;
  int? _editingIndex;

  late final Box<BudgetGoal> _budgetGoalBox;
  final GlobalKey<BudgetPopupState> _popupKey = GlobalKey<BudgetPopupState>();

  @override
  void initState() {
    super.initState();
    _budgetGoalBox = Hive.box<BudgetGoal>('budgetGoals');
  }

  void _onSave() {
    final state = _popupKey.currentState;
    if (state == null) return;

    final name = state.goalNameController.text.trim();
    if (name.isEmpty) return;
    if (state.fromDate == null || state.toDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please pick both From and To Dates.")),
      );
      return;
    }

    final goal = BudgetGoal(
      id: _editingGoal?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),

      name: name,
      description: state.descriptionController.text.trim(),
      status: state.selectedOption,
      fromDate: state.fromDate!,
      toDate: state.toDate!,
    );

    if (_editingIndex != null) {
      _budgetGoalBox.putAt(_editingIndex!, goal);
    } else {
      _budgetGoalBox.add(goal);
    }

    setState(() {
      _popupVisible = false;
      _editingGoal = null;
      _editingIndex = null;
    });
  }

  void _onDelete(int index) {
    _budgetGoalBox.deleteAt(index);
    setState(() {});
  }

  void _onEdit(int index, BudgetGoal goal) {
    setState(() {
      _editingGoal = goal;
      _editingIndex = index;
      _popupVisible = true;
    });
  }

  void _onCancel() {
    setState(() {
      _popupVisible = false;
      _editingGoal = null;
      _editingIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTitle(title: "BUDGET GOAL"),
              const SizedBox(height: 20),
              LegendBar(),
              const SizedBox(height: 20),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: _budgetGoalBox.listenable(),
                  builder: (context, Box<BudgetGoal> box, _) {
                    if (box.isEmpty) {
                      return Center(
                        child: Text(
                          "NO GOALS SET",
                          style: TextStyle(
                            color: clr.textGreyBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                      );
                    }
                    return ListView.separated(
                      itemBuilder: (context, index) {
                        final goal = box.getAt(index)!;
                        return BudgetGoalTile(
                          budgetGoalTile: goal,
                          onTap: () => _onEdit(index, goal),
                          onDelete: () => _onDelete(index),
                        );
                      },
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemCount: box.length,
                    );
                  },
                ),
              ),
            ],
          ),
          if (_popupVisible)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: BudgetPopup(
                  key: _popupKey,
                  onCancel: _onCancel,
                  onSave: _onSave,
                  existingGoal: _editingGoal,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: Visibility(
        visible: !_popupVisible,
        child: AddBtn(onToggle: () => setState(() => _popupVisible = true)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
