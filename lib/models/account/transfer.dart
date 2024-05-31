import 'package:objectbox/objectbox.dart';

import 'package:budgetron/models/account/account.dart';

@Entity()
class Transfer {
  int id = 0;

  double value;

  @Property(type: PropertyType.date)
  DateTime dateTime;

  final fromAccount = ToOne<Account>();
  final toAccount = ToOne<Account>();

  Transfer({required this.value, required this.dateTime});
}
