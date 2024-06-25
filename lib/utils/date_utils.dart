import 'package:budgetron/globals.dart' as globals;

import 'package:flutter/material.dart';

import 'package:budgetron/utils/enums.dart';
import 'package:budgetron/models/enums/date_period.dart';

class BudgetronDateUtils {
  static List<DateTime> getDatesInPeriod(BudgetronPage page) {
    switch (page) {
      case BudgetronPage.entries:
        return _calculatePairOfDates(DatePeriod.values
            .where((p) => p.periodIndex == globals.defaultDatePeriodEntries)
            .first);
      case BudgetronPage.stats:
        return _calculatePairOfDates(DatePeriod.values
            .where((p) => p.periodIndex == globals.defaultDatePeriodStats)
            .first);
      case BudgetronPage.groups:
        return _calculatePairOfDates(DatePeriod.values
            .where((p) => p.periodIndex == globals.defaultDatePeriodGroups)
            .first);
      default:
        throw Exception('Not a valid app page.');
    }
  }

  static List<DateTime> _calculatePairOfDates(DatePeriod datePeriod) {
    var now = DateTime.now();
    DateTime endDate;

    switch (datePeriod) {
      case DatePeriod.day:
        endDate = BudgetronDateUtils.shiftToEndOfDay(now);
        return [DateTime(now.year, now.month, now.day), endDate];
      case DatePeriod.month:
        endDate = BudgetronDateUtils.shiftToEndOfMonth(now);
        return [DateTime(now.year, now.month), endDate];
      case DatePeriod.year:
        endDate = BudgetronDateUtils.shiftToEndOfYear(now);
        return [DateTime(now.year), endDate];
      default:
        throw Exception('Not a valid date period.');
    }
  }

  static DateTime shiftToStartOfWeek(DateTime date) {
    while (date.weekday != 1) {
      date = DateUtils.addDaysToDate(date, -1);
    }

    return date;
  }

  static DateTime shiftToStartOfMonth(DateTime date) {
    return DateTime(date.year, date.month);
  }

  static DateTime shiftToStartOfYear(DateTime date) {
    return DateTime(date.year);
  }

  static DateTime shiftToEndOfDay(DateTime date) {
    var startDate = DateTime(date.year, date.month, date.day);
    return DateUtils.addDaysToDate(startDate, 1)
        .add(const Duration(milliseconds: -1));
  }

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
