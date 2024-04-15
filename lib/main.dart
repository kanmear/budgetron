// ignore_for_file: unused_import

import 'dart:io';
import 'globals.dart' as globals;

import 'package:budgetron/db/settings_controller.dart';
import 'package:budgetron/logic/settings/settings_service.dart';
import 'package:budgetron/routes/pages/entry/new_entry_page.dart';
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

  // SettingsController.setupSettings();
  globals.currency = await SettingsService.getCurrency();
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
      bottomNavigationBar: Container(
          height: 72,
          clipBehavior: Clip.hardEdge,
          padding: const EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              boxShadow: [
                BoxShadow(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 12,
                    offset: const Offset(0, -3))
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.list),
                color: selectedIndex == 0
                    ? Theme.of(context).colorScheme.surface
                    : Theme.of(context).colorScheme.tertiary,
                onPressed: () => _selectPage(0),
              ),
              IconButton(
                icon: const Icon(Icons.home),
                color: selectedIndex == 1
                    ? Theme.of(context).colorScheme.surface
                    : Theme.of(context).colorScheme.tertiary,
                onPressed: () => _selectPage(1),
              ),
              InkWell(
                  onTap: () => _navigateToEntryCreation(context),
                  child: Icon(Icons.add_circle_outlined,
                      size: 50, color: Theme.of(context).colorScheme.surface)),
              IconButton(
                icon: const Icon(Icons.wallet),
                color: selectedIndex == 2
                    ? Theme.of(context).colorScheme.surface
                    : Theme.of(context).colorScheme.tertiary,
                onPressed: () => _selectPage(2),
              ),
              IconButton(
                icon: const Icon(Icons.bar_chart),
                color: selectedIndex == 3
                    ? Theme.of(context).colorScheme.surface
                    : Theme.of(context).colorScheme.tertiary,
                onPressed: () => _selectPage(3),
              ),
            ],
          )),
    );
  }

  void _selectPage(index) {
    pageViewController.animateToPage(index,
        duration: const Duration(milliseconds: 200), curve: Curves.ease);
  }

  void _updateIndex(index) {
    setState(() {
      selectedIndex = index;
      selectedTitle = pageTitles[index];
    });
  }

  Future<void> _navigateToEntryCreation(BuildContext context) async {
    //NOTE should it return to Entries page?
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => NewEntryPage()));

    if (!mounted) return;
  }
}

class AppState extends ChangeNotifier {}
