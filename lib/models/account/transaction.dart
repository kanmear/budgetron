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

enum TransactionType {
  credit(name: 'Credit'),
  debit(name: 'Debit');

  final String name;

  const TransactionType({required this.name});

  @override
  toString() => name;
}
