enum DatePeriod {
  //REFACTOR enum has indexes by default, remove these periodIndexes
  day(periodIndex: 0, name: 'Day'),
  week(periodIndex: 1, name: 'Week'),
  month(periodIndex: 2, name: 'Month'),
  year(periodIndex: 3, name: 'Year');

  final String name;
  final int periodIndex;

  const DatePeriod({required this.name, required this.periodIndex});

  @override
  toString() => name;
}
