import 'package:objectbox/objectbox.dart';

import 'package:budgetron/models/budget/budget.dart';

@Entity()
class BudgetHistory {
  int id = 0;

  double targetValue;

  double endValue;

  //index of budget period string values
  int budgetPeriodIndex;

  @Property(type: PropertyType.date)
  DateTime endDate;

  final budget = ToOne<Budget>();

  BudgetHistory(
      {required this.targetValue,
      required this.endValue,
      required this.budgetPeriodIndex,
      required this.endDate});
}
