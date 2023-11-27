// ignore_for_file: unused_import

import 'dart:io';

import 'package:budgetron/ui/classes/drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'db/object_box_helper.dart';
import 'package:budgetron/db/mock_data_generator.dart';

import 'package:budgetron/ui/data/fonts.dart';
import 'package:budgetron/ui/data/icons.dart';
import 'package:budgetron/ui/data/colors.dart';
import 'package:budgetron/ui/classes/app_bar.dart';
import 'package:budgetron/routes/pages/home/home_page.dart';
import 'package:budgetron/routes/pages/stats/stats_page.dart';
import 'package:budgetron/routes/pages/entry/entries_page.dart';
import 'package:budgetron/routes/pages/budget/budget_page.dart';
import 'package:budgetron/models/enums/entry_category_type.dart';
import 'package:budgetron/routes/pages/category/category_page.dart';

late ObjectBox objectBox;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ObjectBox.init();

  // MockDataGenerator.removeAllData();
  // MockDataGenerator.generateRandomEntries();

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
  final List<String> pageTitles = ['Entries', 'Home', 'Budget', 'Stats'];
  String selectedTitle = 'Home';

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
      appBar: BudgetronAppBar(
          leading: Builder(builder: (context) {
            return MenuIconButton(
                onTap: () => Scaffold.of(context).openDrawer());
          }),
          title: selectedTitle),
      drawer: const BudgetronDrawer(),
      body: PageView(
        controller: pageViewController,
        children: [EntriesPage(), const HomePage(), BudgetPage(), StatsPage()],
        onPageChanged: (index) => _updateIndex(index),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(3)),
          child: BottomNavigationBar(
              selectedItemColor: Theme.of(context).colorScheme.surface,
              unselectedItemColor: Theme.of(context).colorScheme.tertiary,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Theme.of(context).colorScheme.primary,
              currentIndex: selectedIndex,
              onTap: _selectPage,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.list), label: 'Entries'),
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.wallet), label: 'Budget'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.bar_chart), label: 'Stats')
              ]),
        ),
      ),
    );
  }

  void _selectPage(index) {
    selectedTitle = pageTitles[index];
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
