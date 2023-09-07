import 'dart:math';

import 'package:budgetron/db/budget_controller.dart';
import 'package:budgetron/db/entry_controller.dart';
import 'package:budgetron/logic/entry/entry_service.dart';
import 'package:budgetron/db/category_controller.dart';
import 'package:budgetron/models/category.dart';
import 'package:budgetron/models/entry.dart';

class MockDataGenerator {
  static void generateRandomEntries() async {
    List<EntryCategory> categories = await _generateCategories();
    DateTime now = DateTime.now();

    for (int m = 1; m <= now.month; m++) {
      for (int d = 1; d <= now.month; d++) {
        int amount = Random().nextInt(categories.length);
        for (int i = 0; i < amount; i++) {
          double value =
              double.parse((Random().nextDouble() * 50).toStringAsFixed(2));
          int categoryIndex = Random().nextInt(categories.length);

          EntryService.createEntry(
              Entry(value: value, dateTime: DateTime(2023, m, d)),
              categories.elementAt(categoryIndex));
        }
      }
    }
  }

  static Future<List<EntryCategory>>
      generateDataForBudgetServiceTesting() async {
    List<EntryCategory> categories = await _generateCategories();
    EntryCategory groceries =
        categories.where((category) => category.name == 'Groceries').first;
    EntryCategory rent =
        categories.where((category) => category.name == 'Rent').first;
    EntryCategory transport =
        categories.where((category) => category.name == 'Transport').first;
    EntryCategory utilities =
        categories.where((category) => category.name == 'Utilities').first;
    EntryCategory maintenance = categories
        .where((category) => category.name == 'House maintenance')
        .first;
    EntryCategory medicine =
        categories.where((category) => category.name == 'Medicine').first;
    EntryCategory salary =
        categories.where((category) => category.name == 'Salary').first;

    DateTime december = DateTime(2023, 12);
    DateTime january = DateTime(2023, 1);
    DateTime february = DateTime(2023, 2);
    DateTime april = DateTime(2023, 4);
    DateTime july = DateTime(2023, 7);
    DateTime august = DateTime(2023, 8);
    EntryService.createEntry(
        Entry(value: 100.10, dateTime: DateTime(2022, december.month, 15)),
        groceries);
    EntryService.createEntry(
        Entry(value: 200.20, dateTime: DateTime(2022, december.month, 31)),
        groceries);

    EntryService.createEntry(
        Entry(value: 24.99, dateTime: DateTime(2023, january.month, 1)),
        groceries);
    EntryService.createEntry(
        Entry(value: 4.24, dateTime: DateTime(2023, january.month, 19)),
        groceries);

    EntryService.createEntry(
        Entry(value: 11.03, dateTime: DateTime(2023, february.month, 4)),
        groceries);
    EntryService.createEntry(
        Entry(value: 71.49, dateTime: DateTime(2023, february.month, 9)),
        groceries);

    EntryService.createEntry(
        Entry(value: 22.33, dateTime: DateTime(2023, april.month, 2)),
        groceries);
    EntryService.createEntry(
        Entry(value: 13.80, dateTime: DateTime(2023, april.month, 7)),
        groceries);
    EntryService.createEntry(
        Entry(value: 98.17, dateTime: DateTime(2023, april.month, 21)),
        utilities);

    EntryService.createEntry(
        Entry(value: 17.22, dateTime: DateTime(2023, july.month, 21)),
        groceries);
    EntryService.createEntry(
        Entry(value: 7.19, dateTime: DateTime(2023, july.month, 31)),
        groceries);
    EntryService.createEntry(
        Entry(value: 88.14, dateTime: DateTime(2023, july.month, 21)),
        utilities);

    EntryService.createEntry(
        Entry(value: 10.12, dateTime: DateTime(2023, august.month, 1)),
        groceries);
    EntryService.createEntry(
        Entry(value: 21.34, dateTime: DateTime(2023, august.month, 3)),
        groceries);
    EntryService.createEntry(
        Entry(value: 32.44, dateTime: DateTime(2023, august.month, 8)),
        groceries);

    EntryService.createEntry(
        Entry(value: 20.22, dateTime: DateTime(2023, august.month, 8)),
        utilities);
    EntryService.createEntry(
        Entry(value: 42.81, dateTime: DateTime(2023, august.month, 3)),
        utilities);

    return categories;
  }

  static Future<List<EntryCategory>> _generateCategories() async {
    List<EntryCategory> categories =
        await CategoryController.getCategories('', null).first;

    if (categories.isNotEmpty) {
      throw Exception('Categories already exist.');
    }

    CategoryController.addCategory(
        EntryCategory(name: 'Groceries', isExpense: true, color: 'ff8bc34a'));
    CategoryController.addCategory(
        EntryCategory(name: 'Rent', isExpense: true, color: 'ffff5252'));
    CategoryController.addCategory(
        EntryCategory(name: 'Transport', isExpense: true, color: 'ff00bcd4'));
    CategoryController.addCategory(
        EntryCategory(name: 'Utilities', isExpense: true, color: 'ff00d4bb'));
    CategoryController.addCategory(EntryCategory(
        name: 'House maintenance', isExpense: true, color: 'ffaab2aa'));
    CategoryController.addCategory(
        EntryCategory(name: 'Medicine', isExpense: true, color: 'ff4a5bcd1'));

    CategoryController.addCategory(
        EntryCategory(name: 'Salary', isExpense: false, color: 'ff5bcd14a'));
    CategoryController.addCategory(
        EntryCategory(name: 'Trading', isExpense: false, color: 'ff721d8da'));

    return CategoryController.getCategories('', null).first;
  }

  static void removeAllData() {
    BudgetController.clearBudgets();
    EntryController.clearEntries();
    CategoryController.clearCategories();
  }
}
