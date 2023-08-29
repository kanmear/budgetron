import 'package:budgetron/db/category_controller.dart';
import 'package:budgetron/db/object_box_helper.dart';
import 'package:budgetron/models/category.dart';
import 'package:budgetron/models/budget.dart';
import 'package:budgetron/objectbox.g.dart';

class BudgetController {
  static Stream<List<Budget>> getBudgets() {
    final builder = _getBudgetBox().query()
      ..order(Budget_.id, flags: Order.descending);
    return builder.watch(triggerImmediately: true).map((query) => query.find());
  }

  static int addBudget(Budget budget, EntryCategory category) {
    category.isBudgetTracked = true;
    CategoryController.updateCategory(category);

    budget.category.target = category;
    return _getBudgetBox().put(budget);
  }

  static void updateBudget(EntryCategory entryCategory, String value) async {
    List<Budget> queryResult = (await _getBudgetBox()
        .query(Budget_.category.equals(entryCategory.id))
        .watch(triggerImmediately: true)
        .map((query) => query.find())
        .first);

    if (queryResult.isEmpty) {
      throw Exception(
          'Category.isBudgetTracked: ${entryCategory.isBudgetTracked}, but budget does not exist');
    }

    Budget budget = queryResult.first;
    budget.currentValue += double.parse(value);
    _getBudgetBox().put(budget);
  }

  static void clearBudgets() {
    _getBudgetBox().removeAll();
  }

  static Box<Budget> _getBudgetBox() => ObjectBox.store.box<Budget>();
}
