import 'package:objectbox/objectbox.dart';

@Entity()
class Account {
  int id = 0;

  @Unique()
  String name;
  String color;
  bool isDefault;
  double balance;

  Account(
      {required this.name,
      required this.color,
      required this.balance,
      required this.isDefault});

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
}
