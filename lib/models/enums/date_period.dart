enum DatePeriod { day, week, month, year }

class DatePeriodMap {
  static String getName(DatePeriod datePeriod) {
    switch (datePeriod) {
      case DatePeriod.day:
        return 'Day';
      case DatePeriod.week:
        return 'Week';
      case DatePeriod.month:
        return 'Month';
      case DatePeriod.year:
        return 'Year';
      default:
        throw Exception('Not a valid DatePeriod value.');
    }
  }
}
