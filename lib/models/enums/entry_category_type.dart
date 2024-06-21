import 'package:budgetron/utils/interfaces.dart';

enum EntryCategoryType implements TabValue {
  expense(name: 'Expense', value: false),
  income(name: 'Income', value: true);

  final String name;
  final bool value;

  const EntryCategoryType({required this.name, required this.value});

  @override
  toString() => name;

  @override
  getValue() => value;
}
