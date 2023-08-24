import 'dart:math';

import 'package:budgetron/db/category_controller.dart';
import 'package:budgetron/db/entry_controller.dart';
import 'package:budgetron/models/category.dart';
import 'package:budgetron/models/entry.dart';

class MockDataGenerator {
  static void generateMockData() async {
    List<EntryCategory> categories =
        await CategoryController.getCategories('', null).first;

    if (categories.isNotEmpty) {
      return;
    }

    CategoryController.addCategory(EntryCategory(
        name: 'Groceries', isExpense: true, usages: 0, color: 'ff8bc34a'));
    CategoryController.addCategory(EntryCategory(
        name: 'Rent', isExpense: true, usages: 0, color: 'ffff5252'));
    CategoryController.addCategory(EntryCategory(
        name: 'Transport', isExpense: true, usages: 0, color: 'ff00bcd4'));
    CategoryController.addCategory(EntryCategory(
        name: 'Utilities', isExpense: true, usages: 0, color: 'ff00d4bb'));

    categories = await CategoryController.getCategories('', null).first;

    for (int m = 1; m < 8; m++) {
      for (int d = 1; d < 28; d++) {
        int amount = Random().nextInt(5);
        for (int i = 0; i < amount; i++) {
          double value =
              double.parse((Random().nextDouble() * 50).toStringAsFixed(2));
          int categoryIndex = Random().nextInt(4);

          EntryController.addEntry(
              Entry(value: value, dateTime: DateTime(2023, m, d)),
              categories.elementAt(categoryIndex));
        }
      }
    }
  }
}
