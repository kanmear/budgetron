import 'package:objectbox/objectbox.dart';

@Entity()
class Entry {
  int id = 0;

  int value;

  final section = ToOne<Section>();

  @Property(type: PropertyType.date)
  DateTime dateTime;

  Entry({required this.value, required this.dateTime});

  @override
  String toString() {
    return 'Entry {value: $value, section: $section, date: $dateTime}';
  }
}

@Entity()
class Section {
  int id = 0;

  @Unique()
  String name;

  bool isExpense;

  Section({required this.name, required this.isExpense});

  @override
  String toString() {
    return 'Section {name: $name, isExpense: $isExpense}';
  }
}
