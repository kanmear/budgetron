import 'package:objectbox/objectbox.dart';

import 'package:budgetron/utils/interfaces.dart';
import 'package:budgetron/models/account/account.dart';

@Entity()
class Transaction implements Listable {
  int id = 0;

  @override
  double value;

  @override
  @Property(type: PropertyType.date)
  DateTime dateTime;

  final account = ToOne<Account>();

  Transaction({required this.value, required this.dateTime});

  @override
  String toString() => 'Transaction';
}

//TODO figure out where enums should be, because CategoryType is not bundled with Category
enum TransactionType implements TabValue {
  credit(name: 'Credit', value: false),
  debit(name: 'Debit', value: true);

  final String name;

  final bool value;

  const TransactionType({required this.name, required this.value});

  @override
  toString() => name;

  @override
  getValue() => value;
}
