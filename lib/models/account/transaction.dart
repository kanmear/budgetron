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

enum TransactionType {
  credit(name: 'Credit'),
  debit(name: 'Debit');

  final String name;

  const TransactionType({required this.name});

  @override
  toString() => name;
}
