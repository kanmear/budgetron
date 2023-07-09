import 'package:budgetron/main.dart';
import 'package:budgetron/objectbox.g.dart';
import 'package:budgetron/models/budget.dart';

class BudgetController {
  static Stream<List<Budget>> getBudgets() {
    final builder = objectBox.budgetBox.query()
      ..order(Budget_.id, flags: Order.descending);
    return builder.watch(triggerImmediately: true).map((query) => query.find());
  }
}
