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
        child: MaterialApp(
          home: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                bottom: const TabBar(tabs: [
                  Tab(icon: Icon(Icons.add)),
                  Tab(icon: Icon(Icons.bar_chart))
                ]),
                title: const Text('Tabs'),
              ),
              body: const TabBarView(children: [EntriesPage(), StatsPage()]),
            ),
          ),
        ));
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
