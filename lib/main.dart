import 'package:flutter/material.dart';
import 'widgets/appbar.dart';
import 'pages/accounts_page.dart';
import 'pages/budget_goal_page.dart';
import 'pages/categories_page.dart';
import 'pages/transaction_page.dart';
import 'constants/nav_destinations.dart';
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
              color: Colors.white,
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
  int _index = 0;

  final List<Widget> _pages = [
    RecordsBody(),
    TransactionPage(),
    AccountsPage(),
    CategoriesPage(),
    BudgetGoalPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        backgroundColor: clr.matteblack,
        selectedIndex: _index,
        labelBehavior:
            NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (idx) {
          setState(() => _index = idx);
        },
        destinations: navDestinations,
      ),
    );
  }
}

class RecordsBody extends StatelessWidget {
  const RecordsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text("Records");
  }
}
