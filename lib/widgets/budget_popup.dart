import 'package:flutter/material.dart';
import 'package:cash_compass/constants/colors.dart' as clr;
import 'package:cash_compass/classes/budget_goal.dart';

class BudgetPopup extends StatefulWidget {
  final VoidCallback onCancel;
  final VoidCallback onSave;
  final BudgetGoal? existingGoal;

  const BudgetPopup({
    super.key,
    required this.onCancel,
    required this.onSave,
    this.existingGoal,
  });

  @override
  State<BudgetPopup> createState() => BudgetPopupState();
}

class BudgetPopupState extends State<BudgetPopup> {
  GoalStatus selectedOption = GoalStatus.ongoing;

  DateTime? fromDate;
  DateTime? toDate;
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();
  final TextEditingController goalNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  void _onOptionSelected(GoalStatus value) {
    setState(() {
      selectedOption = value;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.existingGoal != null) {
      final goal = widget.existingGoal!;

      fromDate = goal.fromDate;
      toDate = goal.toDate;

      _fromDateController.text =
          "${goal.fromDate.month}/${goal.fromDate.day}/${goal.fromDate.year}";
      _toDateController.text =
          "${goal.toDate.month}/${goal.toDate.day}/${goal.toDate.year}";
      goalNameController.text = goal.name;
      descriptionController.text = goal.description;
      selectedOption = goal.status;
    }
  }

  @override
  void dispose() {
    _fromDateController.dispose();
    _toDateController.dispose();
    goalNameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required void Function(DateTime) onPicked}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
      barrierDismissible: true,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.white,
              primary: clr.matteblack,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        onPicked(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: clr.matteblack,
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "SET BUDGET GOALS",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: widget.onCancel,
                icon: Icon(Icons.cancel, color: Colors.white, size: 30),
              ),
            ],
          ),
          TextField(
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: "Inter",
            ),
            controller: goalNameController,
            cursorColor: Colors.white,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              hintText: "Enter Goal Name",
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "From: ",
                style: TextStyle(
                  fontFamily: "Inter",
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Expanded(
                child: TextField(
                  readOnly: true,
                  expands: false,
                  style: TextStyle(color: Colors.white),
                  controller: _fromDateController,
                  decoration: InputDecoration(
                    hintText: "Pick Date",
                    hintStyle: TextStyle(color: Colors.white),
                    border: UnderlineInputBorder(),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  cursorColor: Colors.white,
                  onTap: () => _pickDate(
                    onPicked: (date) {
                      fromDate = date;
                      _fromDateController.text =
                          "${date.month}/${date.day}/${date.year}";
                    },
                  ),
                ),
              ),
              Text(
                "To: ",
                style: TextStyle(
                  fontFamily: "Inter",
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Expanded(
                child: TextField(
                  readOnly: true,
                  expands: false,
                  style: TextStyle(color: Colors.white),
                  controller: _toDateController,
                  decoration: InputDecoration(
                    hintText: "Pick Date",
                    hintStyle: TextStyle(color: Colors.white),
                    border: UnderlineInputBorder(),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  cursorColor: Colors.white,
                  onTap: () => _pickDate(
                    onPicked: (date) {
                      toDate = date;
                      _toDateController.text =
                          "${date.month}/${date.day}/${date.year}";
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 135,
            child: TextField(
              expands: true,
              minLines: null,
              maxLines: null,
              textAlignVertical: TextAlignVertical.top,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Add description...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              cursorColor: Colors.white,
              controller: descriptionController,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: GoalStatus.values
                .map(
                  (opt) => Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Checkbox(
                        activeColor: Colors.white,
                        checkColor: clr.matteblack,
                        value: selectedOption == opt,
                        onChanged: (_) => _onOptionSelected(opt),
                      ),
                      Text(opt.label, style: TextStyle(color: Colors.white)),
                    ],
                  ),
                )
                .toList(),
          ),
          SizedBox(
            width: 120,
            child: FilledButton(
              onPressed: widget.onSave,
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(clr.green),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(5),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.save, color: Colors.white),
                  const SizedBox(width: 10),
                  Text(
                    "Save",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
