import 'package:objectbox/objectbox.dart';

@Entity()
class Entry {
  @Id()
  int id = 0;

  @Property()
  int value;

  @Property()
  bool isExpense;

  @Property()
  String section;

  Entry({required this.value, required this.isExpense, required this.section});

  @override
  String toString() {
    return 'Entry {value: $value, isExpense: $isExpense, section: $section}';
  }
}
