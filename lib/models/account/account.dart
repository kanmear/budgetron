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
}
