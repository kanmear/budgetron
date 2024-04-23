import 'package:budgetron/models/budget/budget_history.dart';
import 'package:budgetron/db/object_box_helper.dart';
import 'package:budgetron/models/budget/budget.dart';
import 'package:budgetron/objectbox.g.dart';

class BudgetController {
  static Budget getBudget(int budgetId) {
    Budget? budget = _getBudgetBox().get(budgetId);
    if (budget == null) {
      throw Exception('Budget not found EC-301');
    }

    return budget;
  }

  static Stream<List<Budget>> getBudgets() {
    return (_getBudgetBox().query()..order(Budget_.id, flags: Order.descending))
        .watch(triggerImmediately: true)
        .map((query) => query.find());
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

  static void deleteBudget(int budgetId) => _getBudgetBox().remove(budgetId);

  static void clearBudgets() {
    _getBudgetBox().removeAll();
  }

  static void addBudgetHistory(BudgetHistory budgetHistory) =>
      _getBudgetHistoryBox().put(budgetHistory);

  static Box<Budget> _getBudgetBox() => ObjectBox.store.box<Budget>();

  static Box<BudgetHistory> _getBudgetHistoryBox() =>
      ObjectBox.store.box<BudgetHistory>();
}
