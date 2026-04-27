import 'package:cash_compass/classes/budget_goal.dart';
import 'package:cash_compass/classes/base_item.dart';
import 'package:cash_compass/widgets/add_btn.dart';
import 'package:flutter/material.dart';
import 'pages/accounts_page.dart';
import 'pages/budget_goal_page.dart';
import 'pages/categories_page.dart';
import 'pages/transaction_page.dart';
import 'widgets/appbar.dart';
import 'constants/colors.dart' as clr;
import 'constants/nav_destinations.dart';
import 'classes/transaction.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cash_compass/widgets/expense_record.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(TransactionModeAdapter());
  Hive.registerAdapter(TransactionAdapter());
  Hive.registerAdapter(BudgetGoalAdapter());

  await Hive.openBox<Transaction>('transaction');
  await Hive.openBox<BudgetGoal>('budgetGoals');
  Hive.registerAdapter(AccountAdapter());

  await Hive.openBox<Transaction>('transaction');
  await Hive.openBox<Account>('accounts');

  runApp(
    MaterialApp(
      theme: ThemeData(
        navigationBarTheme: NavigationBarThemeData(
          indicatorColor: Colors.transparent,
          indicatorShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return IconThemeData(color: clr.greyBlue);
            }

            return IconThemeData(color: Colors.white);
          }),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
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
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
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
          : AddBtn(onToggle: () => setState(() => _index = 1)),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: NavigationBar(
        backgroundColor: clr.matteblack,
        selectedIndex: _index,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (idx) => setState(() => _index = idx),
        destinations: navDestinations,
      ),
    );
  }
}

class RecordsBody extends StatelessWidget {
  const RecordsBody({super.key});

  Map<DateTime, List<Transaction>> _groupByDate(List<Transaction> all) {
    final map = <DateTime, List<Transaction>>{};
    for (final t in all) {
      final day = DateTime(t.date.year, t.date.month, t.date.day);
      map.putIfAbsent(day, () => []).add(t);
    }
    for (final list in map.values) {
      list.sort((a, b) => b.date.compareTo(a.date));
    }
    return map;
  }

  String _formatDayHeader(DateTime day) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final monthDay = DateFormat('MMMM d, yyy').format(day).toUpperCase();
    final weekDay = DateFormat('EEEE').format(day).toUpperCase();

    if (day == today) return "$monthDay: $weekDay • TODAY";
    if (day == yesterday) return "$monthDay: $weekDay • YESTERDAY";
    return "$monthDay: $weekDay";
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<Transaction>('transaction').listenable(),
      builder: (context, Box<Transaction> box, _) {
        final all = box.values.toList();

        if (all.isEmpty) {
          return const Center(
            child: Text(
              "No transactions yet.\nClick + to add one.",
              textAlign: TextAlign.center,
              style: TextStyle(color: clr.textGreyBlue),
            ),
          );
        }

        final grouped = _groupByDate(all);
        final sortedDays = grouped.keys.toList()
          ..sort((a, b) => b.compareTo(a));

        return ListView.builder(
          itemCount: sortedDays.length,
          itemBuilder: (context, i) {
            final day = sortedDays[i];
            final transactions = grouped[day]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 6),
                  child: Text(
                    _formatDayHeader(day),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      fontFamily: "Inter",
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const Divider(height: 1),
                const SizedBox(height: 4),
                ...transactions.map((t) {
                  final key = box.keys.firstWhere(
                    (k) => box.get(k)?.id == t.id,
                    orElse: () => null,
                  );
                  return ExpenseRecord(
                    transaction: t,
                    onDelete: () {
                      if (key != null) box.delete(key);
                    },
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => Scaffold(
                            appBar: AppBar(
                              title: const Text("Edit Transaction"),
                              backgroundColor: Colors.white,
                              foregroundColor: clr.matteblack,
                              elevation: 0,
                            ),
                            body: Padding(
                              padding: const EdgeInsets.all(10),
                              child: TransactionPage(),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ],
            );
          },
        );
      },
    );
  }
}
