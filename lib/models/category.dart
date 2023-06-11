import 'package:objectbox/objectbox.dart';

@Entity()
class EntryCategory {
  int id = 0;

  @Unique()
  String name;

  bool isExpense;
  String color;
  int usages;

  EntryCategory(
      {required this.name,
      required this.isExpense,
      required this.usages,
      required this.color});

  @override
  String toString() {
    return 'Category {name: $name, isExpense: $isExpense}';
  }
}
