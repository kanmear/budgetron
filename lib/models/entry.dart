import 'package:objectbox/objectbox.dart';

import 'package:budgetron/models/account/account.dart';
import 'package:budgetron/models/category/category.dart';

@Entity()
class Entry {
  int id = 0;

  double value;

  @Property(type: PropertyType.date)
  DateTime dateTime;

  final category = ToOne<EntryCategory>();
  final account = ToOne<Account>();

  Entry({required this.value, required this.dateTime});

  @override
  String toString() {
    return 'Entry {value: $value, category: $category, date: $dateTime}';
  }
}
