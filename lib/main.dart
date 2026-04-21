import 'package:flutter/material.dart';
import 'constants/colors.dart' as clr;

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        navigationBarTheme: NavigationBarThemeData(
          indicatorColor: Colors.transparent,
          indicatorShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          iconTheme: WidgetStateProperty.resolveWith((
            states,
          ) {
            if (states.contains(WidgetState.selected)) {
              return IconThemeData(color: clr.greyBlue);
            }

            return IconThemeData(color: Colors.white);
          }),
          labelTextStyle: WidgetStateProperty.resolveWith((
            states,
          ) {
            if (states.contains(WidgetState.selected)) {
              return TextStyle(
                color: clr.greyBlue,
                fontWeight: FontWeight.bold,
                fontSize: 10,
                fontFamily: "Inter",
              );
            }

            return TextStyle(
              color: clr.matteblack,
              fontWeight: FontWeight.bold,
              fontSize: 10,
              fontFamily: "Inter",
            );
          }),
          labelBehavior:
              NavigationDestinationLabelBehavior.alwaysShow,
        ),
      ),
      home: const RecordsPage(),
    ),
  );
}

class RecordsPage extends StatefulWidget {
  const RecordsPage({super.key});

  @override
  State<RecordsPage> createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
