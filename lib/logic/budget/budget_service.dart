import 'package:budgetron/models/budget.dart';

class BudgetService {
  static final List<String> budgetPeriodStrings = [
    "Week",
    "Two weeks",
    "Month",
    "Six months",
    "Year"
  ];

  static void setPeriodicTask(Budget budget, int budgetId) {
    String taskName = budget.category.target!.name + budgetId.toString();
    Map<String, Budget> inputData = {taskName: budget};
    Duration frequency = _resolveFrequency(budget.budgetPeriod);
    Duration delay = _resolveDelay(budget.budgetPeriod);

    //TODO implement
  }

  //TODO solution for months and years is incomplete
  static Duration _resolveFrequency(int budgetPeriod) {
    switch (budgetPeriod) {
      case 0:
        return const Duration(days: 7);
      case 1:
        return const Duration(days: 14);
      case 2:
        return const Duration(days: 30);
      case 3:
        return const Duration(days: 180);
      case 4:
        return const Duration(days: 365);
      default:
        throw Exception('Invalid Period id');
    }
  }

  static Duration _resolveDelay(int budgetPeriod) {
    //TODO calculate closest execution time
    throw Exception('Not implemented exception');
  }
}
