import 'dart:ui';

import 'package:budgetron/models/budget.dart';
import 'package:budgetron/models/category.dart';
import 'package:budgetron/db/entry_controller.dart';
import 'package:budgetron/db/budget_controller.dart';
import 'package:budgetron/db/category_controller.dart';
import 'package:budgetron/logic/budget/budget_service.dart';

class CategoryService {
  static String colorToString(Color color) {
    String string =
        color.value.toRadixString(16).replaceAll(RegExp('^f{1,2}'), '');
    return 'ff$string';
  }

  static Color stringToColor(String string) {
    return Color(int.parse(
      string,
      radix: 16,
    ));
  }

  static void deleteCategory(EntryCategory category) async {
    if (category.isBudgetTracked) {
      Budget budget = await BudgetController.getBudgetByCategory(category.id);
      BudgetService.deleteBudget(budget);
    }

    CategoryController.deleteCategory(category.id);
  }

  static Future<bool> isCategoryUnused(EntryCategory category) async {
    return category.usages == 0 ||
        (await EntryController.getEntries(categoryFilter: [category]).first)
            .isEmpty;
  }
}
