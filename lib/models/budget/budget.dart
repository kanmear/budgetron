import 'package:objectbox/objectbox.dart';

import 'package:budgetron/models/category/category.dart';

@Entity()
class Budget {
  int id = 0;

  double targetValue;
  double currentValue;

  //index of budget period string values
  int budgetPeriodIndex;

  //REFACTOR move dates out of budgets
  @Property(type: PropertyType.date)
  DateTime startDate;
  @Property(type: PropertyType.date)
  DateTime resetDate;

  bool onMainPage;
  bool isArchived;

  final category = ToOne<EntryCategory>();

  Budget(
      {required this.targetValue,
      required this.currentValue,
      required this.budgetPeriodIndex,
      required this.onMainPage,
      required this.startDate,
      required this.resetDate,
      this.isArchived = false});
}
