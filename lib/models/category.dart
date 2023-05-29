import 'package:objectbox/objectbox.dart';

@Entity()
class EntryCategory {
  int id = 0;

  @Unique()
  String name;

  bool isExpense;

  //TODO: add usage counter and color

  EntryCategory({required this.name, required this.isExpense});

  @override
  String toString() {
    return 'Category {name: $name, isExpense: $isExpense}';
  }
}
