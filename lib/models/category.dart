import 'package:objectbox/objectbox.dart';

@Entity()
class EntryCategory {
  int id = 0;

  @Unique()
  String name;

  bool isExpense;

  EntryCategory({required this.name, required this.isExpense});

  @override
  String toString() {
    return 'Category {name: $name, isExpense: $isExpense}';
  }
}
