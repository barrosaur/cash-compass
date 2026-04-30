import 'package:flutter/material.dart';
import 'package:cash_compass/constants/colors.dart' as clr;

class LegendBar extends StatelessWidget {
  const LegendBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                border: Border.all(color: clr.matteblack),
              ),
            ),
            const SizedBox(width: 20),
            Text("On Going"),
          ],
        ),
        const Spacer(),
        Row(
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                border: Border.all(color: clr.matteblack),
                color: clr.green,
              ),
            ),
            const SizedBox(width: 20),
            Text("Achieved"),
          ],
        ),
        const Spacer(),
        Row(
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                border: Border.all(color: clr.matteblack),
                color: clr.red,
              ),
            ),
            const SizedBox(width: 20),
            Text("Failed"),
          ],
        ),
      ],
    );
  }
}
