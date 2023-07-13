import 'package:objectbox/objectbox.dart';

import 'package:budgetron/models/category.dart';

@Entity()
class Budget {
  int id = 0;

  int targetValue;

  int currentValue;

  //index of budget period string values
  int budgetPeriod;

  bool onMainPage;

  final category = ToOne<EntryCategory>();

  Budget(
      {required this.targetValue,
      required this.currentValue,
      required this.budgetPeriod,
      required this.onMainPage});
}
