import 'package:flutter/material.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:cash_compass/constants/colors.dart' as clr;

class Calculator extends StatelessWidget {
  final double initialValue;
  final ValueChanged<double> onValueChanged;

  const Calculator({
    super.key,
    this.initialValue = 0,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SimpleCalculator(
        value: initialValue,
        hideExpression: false,
        onChanged: (key, value, expression) {
          if (value != null) onValueChanged(value);
        },
        theme: const CalculatorThemeData(
          numColor: Colors.white,
          operatorColor: clr.matteblack,
          commandColor: clr.greyBlue,
          equalColor: clr.matteblack,
        ),
      ),
    );
  }
}
