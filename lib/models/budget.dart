import 'package:budgetron/models/category.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Budget {
  int id = 0;

  int targetValue;

  int currentValue;

  int budgetPeriod;

  final category = ToOne<EntryCategory>();

  Budget(
      {required this.targetValue,
      required this.currentValue,
      required this.budgetPeriod});
}
