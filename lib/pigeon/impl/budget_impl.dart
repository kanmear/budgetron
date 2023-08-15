// implementation of Flutter API that can be called from native Android

import 'package:budgetron/pigeon/budget.g.dart';

class BudgetApiImpl implements BudgetAPI {
  @override
  void resetBudget(int budgetId) {
    print('This is Flutter called from native Android: $budgetId');
  }
}
