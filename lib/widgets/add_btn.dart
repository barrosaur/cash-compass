import 'package:flutter/material.dart';
import 'package:cash_compass/constants/colors.dart' as clr;

class AddBtn extends StatelessWidget {
  final VoidCallback onToggle;

  const AddBtn({super.key, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onToggle,
      backgroundColor: clr.matteblack,
      foregroundColor: Colors.white,
      shape: const CircleBorder(),
      child: const Icon(Icons.add, size: 35.0),
    );
  }
}
