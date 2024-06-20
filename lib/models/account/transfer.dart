import 'package:objectbox/objectbox.dart';

import 'package:budgetron/utils/interfaces.dart';
import 'package:budgetron/models/account/account.dart';

@Entity()
class Transfer implements Listable {
  int id = 0;

  @override
  double value;

  @override
  @Property(type: PropertyType.date)
  DateTime dateTime;

  final fromAccount = ToOne<Account>();
  final toAccount = ToOne<Account>();

  Transfer({required this.value, required this.dateTime});

  @override
  String toString() => 'Transfer';
}
