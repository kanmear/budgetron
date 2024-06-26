import 'package:objectbox/objectbox.dart';

import 'package:budgetron/utils/interfaces.dart';
import 'package:budgetron/models/budget/budget.dart';
import 'package:budgetron/models/account/account.dart';
import 'package:budgetron/models/category/category.dart';

@Entity()
class Entry implements Listable {
  int id = 0;

  @override
  double value;

  @override
  @Property(type: PropertyType.date)
  DateTime dateTime;

  final category = ToOne<EntryCategory>();
  final account = ToOne<Account>();
  final budget = ToOne<Budget>();

  Entry({required this.value, required this.dateTime});

  @override
  String toString() {
    return 'Entry {value: $value, category: $category, date: $dateTime}';
  }
}
