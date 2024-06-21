import 'package:budgetron/utils/interfaces.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Account implements Selectable {
  int id = 0;

  @Unique()
  String name;
  String color;
  bool isDefault;
  double balance;

  @Property(type: PropertyType.date)
  DateTime earliestOperationDate;

  Account(
      {required this.name,
      required this.color,
      required this.balance,
      required this.isDefault,
      required this.earliestOperationDate});

  @override
  String toString() {
    return name;
  }

  @override
  bool operator ==(Object other) {
    return other is Account && other.id == id;
  }

  @override
  int get hashCode => Object.hash(name, id, 53, 97);

  @override
  String getColor() => color;
}
