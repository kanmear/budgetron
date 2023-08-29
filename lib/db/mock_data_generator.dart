import 'dart:math';

import 'package:budgetron/logic/entry/entry_service.dart';
import 'package:budgetron/db/category_controller.dart';
import 'package:budgetron/models/category.dart';
import 'package:budgetron/models/entry.dart';

class MockDataGenerator {
  static void generateMockData() async {
    List<EntryCategory> categories =
        await CategoryController.getCategories('', null).first;

    if (categories.isNotEmpty) {
      return;
    }

    CategoryController.addCategory(
        EntryCategory(name: 'Groceries', isExpense: true, color: 'ff8bc34a'));
    CategoryController.addCategory(
        EntryCategory(name: 'Rent', isExpense: true, color: 'ffff5252'));
    CategoryController.addCategory(
        EntryCategory(name: 'Transport', isExpense: true, color: 'ff00bcd4'));
    CategoryController.addCategory(
        EntryCategory(name: 'Utilities', isExpense: true, color: 'ff00d4bb'));

    categories = await CategoryController.getCategories('', null).first;

    for (int m = 1; m < 8; m++) {
      for (int d = 1; d < 28; d++) {
        int amount = Random().nextInt(5);
        for (int i = 0; i < amount; i++) {
          double value =
              double.parse((Random().nextDouble() * 50).toStringAsFixed(2));
          int categoryIndex = Random().nextInt(4);

          EntryService.createEntry(
              Entry(value: value, dateTime: DateTime(2023, m, d)),
              categories.elementAt(categoryIndex));
        }
      }
    }
  }
}
