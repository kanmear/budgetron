import 'package:budgetron/pigeon/impl/budget_impl.dart';
import 'package:budgetron/pigeon/budget.g.dart';
import 'package:budgetron/pigeon/alarm.g.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'db/object_box_helper.dart';

import 'package:budgetron/ui/colors.dart';
import 'package:budgetron/routes/pages/stats_page.dart';
import 'package:budgetron/routes/pages/entry/entries_page.dart';
import 'package:budgetron/routes/pages/budget/budget_page.dart';

late ObjectBox objectBox;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ObjectBox.init();

  runApp(const MainApp());

  BudgetAPI.setup(BudgetApiImpl());
  await AlarmAPI().setupBudgetReset(1, 'test1', 'test2');
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AppState(),
        child: MaterialApp(
          theme: ThemeData(colorScheme: BudgetronColors.budgetronColorScheme),
          home: const Budgetron(),
        ));
  }
}

class Budgetron extends StatefulWidget {
  const Budgetron({
    super.key,
  });

  @override
  State<Budgetron> createState() => _BudgetronState();
}

class _BudgetronState extends State<Budgetron> {
  final pageViewController = PageController(initialPage: 1);
  int selectedIndex = 1;

  @override
  void dispose() {
    pageViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageViewController,
        children: [
          const EntriesPage(),
          const Center(
              child: Text(
            "Home page placeholder",
            textScaleFactor: 2,
          )),
          BudgetPage(),
          const StatsPage()
        ],
        onPageChanged: (index) => _updateIndex(index),
      ),
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: BudgetronColors.background,
          unselectedItemColor: BudgetronColors.backgroundHalfOpacity,
          type: BottomNavigationBarType.fixed,
          backgroundColor: BudgetronColors.black,
          currentIndex: selectedIndex,
          onTap: _selectPage,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Entries'),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.wallet), label: 'Budget'),
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats')
          ]),
    );
  }

  void _selectPage(index) {
    pageViewController.animateToPage(index,
        duration: const Duration(milliseconds: 200), curve: Curves.ease);
  }

  void _updateIndex(index) {
    setState(() {
      selectedIndex = index;
    });
  }
}

class AppState extends ChangeNotifier {}
