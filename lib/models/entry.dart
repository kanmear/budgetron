import 'package:objectbox/objectbox.dart';

import 'package:budgetron/models/category/category.dart';

@Entity()
class Entry {
  int id = 0;

  double value;

  final category = ToOne<EntryCategory>();

  @Property(type: PropertyType.date)
  DateTime dateTime;

  Entry({required this.value, required this.dateTime});

  @override
  String toString() {
    return 'Entry {value: $value, category: $category, date: $dateTime}';
  }
}
