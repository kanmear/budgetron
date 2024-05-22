enum EntryCategoryType {
  expense(name: 'Expense'),
  income(name: 'Income');

  final String name;

  const EntryCategoryType({required this.name});

  @override
  toString() => name;
}
