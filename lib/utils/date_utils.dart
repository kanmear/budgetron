import 'package:flutter/material.dart';

class BudgetronDateUtils {
  static DateTime shiftToEndOfMonth(DateTime date) {
    var startDate = DateTime(date.year, date.month);
    return DateUtils.addMonthsToMonthDate(startDate, 1)
        .add(const Duration(milliseconds: -1));
  }

  static DateTime shiftToEndOfYear(DateTime date) {
    var startDate = DateTime(date.year);
    return DateUtils.addMonthsToMonthDate(startDate, 12)
        .add(const Duration(milliseconds: -1));
  }

  static DateTime stripMilliseconds(DateTime date) {
    return DateTime(
        date.year, date.month, date.day, date.hour, date.minute, date.second);
  }

  static DateTime stripTime(DateTime date) =>
      DateTime(date.year, date.month, date.day);
}
