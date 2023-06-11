import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'db/object_box_helper.dart';

import 'package:budgetron/ui/colors.dart';
import 'package:budgetron/pages/stats_page.dart';
import 'package:budgetron/pages/entries_page.dart';

late ObjectBox objectBox;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  objectBox = await ObjectBox.create();

  runApp(const MainApp());
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

  void selectPage(index) {
    pageViewController.animateToPage(index,
        duration: const Duration(milliseconds: 200), curve: Curves.ease);
  }

  void updateIndex(index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageViewController,
        children: const [
          EntriesPage(),
          Center(
              child: Text(
            "Home page placeholder",
            textScaleFactor: 2,
          )),
          StatsPage()
        ],
        onPageChanged: (index) => updateIndex(index),
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: selectPage,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Entries'),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats')
          ]),
      appBar: AppBar(
        title: const Text('Budgetron a0.1'),
      ),
    );
  }
}

class AppState extends ChangeNotifier {}
