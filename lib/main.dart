import 'package:budgetron/entry.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:budgetron/stats_page.dart';
import 'package:budgetron/entries_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AppState(),
        child: const MaterialApp(
          home: Budgetron(),
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
          Text("Home page placeholder"),
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

class AppState extends ChangeNotifier {
  var entries = <Entry>[];
  var isChecked = false;

  void addEntry(Entry entry) {
    entries.add(entry);
    notifyListeners();
  }

  void clearEntries() {
    entries.clear();
    notifyListeners();
  }

  void updateCheck(bool value) {
    isChecked = value;
    notifyListeners();
  }
}
