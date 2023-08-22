// implementation of Flutter API that can be called from native Android

import 'package:budgetron/db/entry_controller.dart';
import 'package:budgetron/models/category.dart';
import 'package:budgetron/models/entry.dart';
import 'package:budgetron/pigeon/budget.g.dart';

class BudgetApiImpl implements BudgetAPI {
  @override
  void resetBudget(int budgetId) {
    print('This is Flutter called from native Android: $budgetId');
    print(DateTime.now());

    EntryCategory category = EntryCategory(
        name: 'TAA at${DateTime.now()}',
        isExpense: true,
        usages: 0,
        color: 'ffffffff');
    Entry entry = Entry(value: 1, dateTime: DateTime.now());
    EntryController.addEntry(entry, category);
  }
}
