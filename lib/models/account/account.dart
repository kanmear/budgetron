import 'package:objectbox/objectbox.dart';

@Entity()
class Account {
  int id = 0;

  @Unique()
  String name;
  bool isDefault;

  String color;

  double balance;

  @Property(type: PropertyType.intVector)
  List<int> entriesIDs;

  Account(
      {required this.name,
      required this.isDefault,
      required this.color,
      required this.balance,
      this.entriesIDs = const []});
}
