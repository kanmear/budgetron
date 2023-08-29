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
    budget.category.target = category;
    return _getBudgetBox().put(budget);
  }

  static void cleanBudgets() {
    // _getEntryBox().removeMany([6, 5, 3, 2, 1]);
  }

  static Box<Budget> _getBudgetBox() => ObjectBox.store.box<Budget>();
}
