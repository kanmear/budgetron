// ignore_for_file: unused_import

import 'dart:io';

import 'globals.dart' as globals;
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'db/object_box_helper.dart';
import 'package:budgetron/db/mock_data_generator.dart';

import 'package:budgetron/app_data.dart';
import 'package:budgetron/ui/data/fonts.dart';
import 'package:budgetron/ui/data/icons.dart';
import 'package:budgetron/ui/data/colors.dart';
import 'package:budgetron/ui/classes/drawer.dart';
import 'package:budgetron/ui/classes/app_bar.dart';
import 'package:budgetron/db/settings_controller.dart';
import 'package:budgetron/ui/classes/navigation_bar.dart';
import 'package:budgetron/routes/pages/home/home_page.dart';
import 'package:budgetron/routes/pages/stats/stats_page.dart';
import 'package:budgetron/routes/pages/entry/entries_page.dart';
import 'package:budgetron/logic/settings/settings_service.dart';
import 'package:budgetron/routes/pages/budget/budgets_page.dart';
import 'package:budgetron/models/enums/entry_category_type.dart';
import 'package:budgetron/routes/pages/entry/new_entry_page.dart';
import 'package:budgetron/routes/pages/category/category_page.dart';

late ObjectBox objectBox;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ObjectBox.init();

  //TODO setup should be handled during first app launch
  await SettingsController.setupSettings();

  await SettingsService.loadDataToGlobals();

  //TODO these should be buttons in app in debug mode
  // MockDataGenerator.removeAllData();
  // await MockDataGenerator.generateRandomEntries();

  runApp(ChangeNotifierProvider(
      create: (context) => AppData(), child: const MainApp()));
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
  bool isPageViewAnimating = false;

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
        children: [
          EntriesPage(),
          const HomePage(),
          const BudgetsPage(),
          StatsPage()
        ],
        onPageChanged: (index) => _updateIndex(index),
      ),
      bottomNavigationBar: BudgetronNavigationBar(
          selectPage: _selectPage,
          isCurrentlySelected: _isCurrentlySelected,
          navigateToEntryCreation: _navigateToEntryCreation),
    );
  }

  void _updateIndex(index) {
    if (isPageViewAnimating) return;

    setState(() {
      selectedIndex = index;
      selectedTitle = pageTitles[index];
    });
  }

  void _selectPage(index) {
    _updateIndex(index);

    isPageViewAnimating = true;
    pageViewController
        .animateToPage(index,
            duration: const Duration(milliseconds: 200), curve: Curves.ease)
        .then((value) {
      isPageViewAnimating = false;
    });
  }

  bool _isCurrentlySelected(int index) => selectedIndex == index;

  Future<void> _navigateToEntryCreation(BuildContext context) async {
    //NOTE should it return to Entries page?
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => NewEntryPage()));

    if (!mounted) return;
  }
}

class AppState extends ChangeNotifier {}
