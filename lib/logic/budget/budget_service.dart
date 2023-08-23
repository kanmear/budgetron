import 'package:flutter/material.dart';

class BudgetService {
  static final List<String> budgetPeriodStrings = [
    "Week",
    "Two weeks",
    "Month",
    "Six months",
    "Year"
  ];

  static DateTime calculateResetDate(int budgetPeriodIndex, {DateTime? date}) {
    date ??= DateTime.now();

    switch (budgetPeriodIndex) {
      case 1:
        return _findNextMonday(date);
      case 2:
        return _findNextMonday(date, mondayMultiplier: 2);
      //TODO the rest of periods
      default:
        throw Exception('Not a valid period index value');
    }
  }

  static DateTime _findNextMonday(DateTime date, {int mondayMultiplier = 1}) {
    int weekDay = date.weekday;
    int shift = 0;

    while (weekDay != 1) {
      weekDay++;
      shift++;

      if (weekDay == 8) weekDay = 1;
    }

    shift = shift == 0 ? 7 : shift;

    return DateUtils.addDaysToDate(date, shift + (--mondayMultiplier * 7));
  }
}
