import 'package:objectbox/objectbox.dart';

@Entity()
class Category {
  int id = 0;

  @Unique()
  String name;

  bool isExpense;

  Category({required this.name, required this.isExpense});

  @override
  String toString() {
    return 'Category {name: $name, isExpense: $isExpense}';
  }
}
