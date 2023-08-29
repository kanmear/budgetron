import 'package:objectbox/objectbox.dart';

@Entity()
class EntryCategory {
  int id = 0;

  @Unique()
  String name;

  bool isBudgetTracked;
  bool isExpense;
  String color;
  int usages;

  EntryCategory(
      {required this.name,
      required this.isExpense,
      this.usages = 0,
      required this.color,
      this.isBudgetTracked = false});

  @override
  String toString() {
    return name;
  }
}
