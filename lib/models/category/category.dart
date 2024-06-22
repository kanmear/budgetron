import 'package:budgetron/utils/interfaces.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class EntryCategory implements Selectable {
  int id = 0;

  @Unique()
  String name;

  @override
  String color;

  bool isBudgetTracked;
  bool isExpense;
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

  @override
  bool operator ==(Object other) {
    return other is EntryCategory && other.id == id;
  }

  @override
  int get hashCode => Object.hash(name, id, 53, 97);
}
