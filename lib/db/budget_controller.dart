import 'package:budgetron/db/object_box_helper.dart';
import 'package:budgetron/models/budget.dart';
import 'package:budgetron/objectbox.g.dart';

class BudgetController {
  static Stream<List<Budget>> getBudgets({bool? isOnMainPage}) {
    Condition<Budget>? condition;

    if (isOnMainPage != null) {
      condition = Budget_.onMainPage.equals(isOnMainPage);
    }

    final builder = _getBudgetBox().query(condition)
      ..order(Budget_.id, flags: Order.descending);

    return builder.watch(triggerImmediately: true).map((query) => query.find());
  }

  static Stream<List<Budget>> getBudgetsForMainPage() {
    return (_getBudgetBox().query(Budget_.onMainPage.equals(true))
          ..order(Budget_.id, flags: Order.descending))
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  static Future<Budget> getBudgetByCategory(int categoryId) async {
    List<Budget> queryResult = (await _getBudgetBox()
        .query(Budget_.category.equals(categoryId))
        .watch(triggerImmediately: true)
        .map((query) => query.find())
        .first);

    if (queryResult.isEmpty) {
      throw Exception('Budget with categoryId: $categoryId not found.');
    }

    return queryResult.first;
  }

  static int addBudget(Budget budget) => _getBudgetBox().put(budget);

  static void updateBudget(Budget budget) => _getBudgetBox().put(budget);

  static void clearBudgets() {
    _getBudgetBox().removeAll();
  }

  static Box<Budget> _getBudgetBox() => ObjectBox.store.box<Budget>();
}
