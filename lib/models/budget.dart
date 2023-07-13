import 'package:budgetron/models/category.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Budget {
  int id = 0;

  int targetValue;

  int currentValue;

  //TODO how this should be implemented?
  int budgetPeriod;

  //TODO add isOnMainPage boolean

  final category = ToOne<EntryCategory>();

  Budget(
      {required this.targetValue,
      required this.currentValue,
      required this.budgetPeriod});
}
