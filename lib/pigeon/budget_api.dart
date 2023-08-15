import 'package:budgetron/pigeon/budget.g.dart';

class BudgetApiImpl implements BudgetAPI {
  @override
  void resetBudget(int budgetId) {
    print('This is Flutter called from native Android: $budgetId');
  }
}
