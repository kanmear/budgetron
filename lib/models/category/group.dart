import 'package:budgetron/models/category/category.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class CategoryGroup {
  int id = 0;

  @Unique()
  String name;
  //TODO add orderIndex

  final categories = ToMany<EntryCategory>();

  CategoryGroup({required this.name});

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) => other is CategoryGroup && other.id == id;

  @override
  int get hashCode => Object.hash(name, id, 53, 97);
}
