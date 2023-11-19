import 'dart:ui';

import 'package:budgetron/models/budget.dart';
import 'package:budgetron/db/budget_controller.dart';
import 'package:budgetron/db/category_controller.dart';
import 'package:budgetron/logic/budget/budget_service.dart';

class CategoryService {
  //TODO write tests
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

  static void deleteCategory(int categoryId) async {
    Budget budget = await BudgetController.getBudgetByCategory(categoryId);
    BudgetService.deleteBudget(budget);

    CategoryController.deleteCategory(categoryId);
  }
}
