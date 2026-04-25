import 'package:cash_compass/widgets/add_btn.dart';
import 'package:cash_compass/widgets/expense_record.dart';
import 'package:flutter/material.dart';
import 'pages/accounts_page.dart';
import 'pages/budget_goal_page.dart';
import 'pages/categories_page.dart';
import 'pages/transaction_page.dart';
import 'widgets/appbar.dart';
import 'constants/colors.dart' as clr;
import 'constants/nav_destinations.dart';
import 'classes/transaction.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(TransactionModeAdapter());
  Hive.registerAdapter(TransactionAdapter());

  await Hive.openBox<Transaction>('transaction');

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
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const RecordsPage(),
      TransactionPage(),
      AccountsPage(),
      CategoriesPage(),
      BudgetGoalPage(),
    ];

    return Scaffold(
      appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsetsGeometry.all(10),
        child: pages[_index],
      ),
      floatingActionButton: [1, 2, 3, 4].contains(_index)
          ? null
          : AddBtn(
              onToggle: () => setState(() => _index = 1),
            ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: NavigationBar(
        backgroundColor: clr.matteblack,
        selectedIndex: _index,
        labelBehavior:
            NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (idx) =>
            setState(() => _index = idx),
        destinations: navDestinations,
      ),
    );
  }
}

class RecordsBody extends StatelessWidget {
  const RecordsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
