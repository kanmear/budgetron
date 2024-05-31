import 'package:objectbox/objectbox.dart';

import 'package:budgetron/models/account/account.dart';

@Entity()
class Transaction {
  int id = 0;

  double value;

  @Property(type: PropertyType.date)
  DateTime dateTime;

  final account = ToOne<Account>();

  Transaction({required this.value, required this.dateTime});
}
