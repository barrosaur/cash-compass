import 'package:flutter/material.dart';
import 'package:cash_compass/constants/colors.dart' as clr;

class TransactionNav extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const TransactionNav({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 5,
      ),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: clr.greyBlue,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: List.generate(labels.length, (idx) {
          final isSelected = selectedIndex == idx;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(idx),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? clr.hoverGreyBlue
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  labels[idx],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    fontFamily: "InriaSans",
                    color: isSelected
                        ? clr.matteblack
                        : clr.textGreyBlue,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
