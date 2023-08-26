import 'package:flutter/material.dart';

class BudgetService {
  //REFACTOR use enum for switch
  static final List<String> budgetPeriodStrings = [
    "Week",
    "Two weeks",
    "Month",
    "Six months",
    "Year"
  ];

  static List<DateTime> calculateDatePeriod(String period, {DateTime? end}) {
    end ??= DateTime.now();
    DateTime start;

    switch (period) {
      case 'Month':
        start = DateTime(end.year, end.month);
        break;
      case 'Week':
        start = _getPastMonday(end);
        break;
      case 'Two weeks':
        start = _getPastMonday(end, weekMultiplier: 2);
        break;
      case 'Six months':
        start = DateUtils.addMonthsToMonthDate(end, -6);
        break;
      case 'Year':
        start = DateTime(end.year);
        break;
      default:
        throw Exception('Not a valid period value.');
    }

    return [start, end];
  }

  //REFACTOR the same switch is used twice
  static DateTime calculateResetDate(String period, DateTime fromDate) {
    switch (period) {
      case 'Month':
        return DateUtils.addMonthsToMonthDate(fromDate, 1);
      case 'Week':
        return DateUtils.addDaysToDate(fromDate, 7);
      case 'Two weeks':
        return DateUtils.addDaysToDate(fromDate, 14);
      case 'Six months':
        return DateUtils.addMonthsToMonthDate(fromDate, 6);
      case 'Year':
        return DateTime(fromDate.year + 1);
      default:
        throw Exception('Not a valid period value.');
    }
  }

  static DateTime _getPastMonday(DateTime weekStart, {int weekMultiplier = 1}) {
    while (weekStart.weekday != 1) {
      weekStart = DateUtils.addDaysToDate(weekStart, -1);
    }

    return DateUtils.addDaysToDate(weekStart, (--weekMultiplier * -7));
  }
}
