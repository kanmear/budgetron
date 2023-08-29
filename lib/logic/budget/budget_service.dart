import 'package:budgetron/db/budget_controller.dart';
import 'package:budgetron/models/budget.dart';
import 'package:budgetron/models/category.dart';
import 'package:budgetron/objectbox.g.dart';
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

  static void updateBudgetValue(int categoryId, String value) async {
    Budget budget = await BudgetController.getBudgetByCategory(categoryId);
    resetBudget(budget);
    budget.currentValue += double.parse(value);

    BudgetController.updateBudget(budget);
  }

  static bool resetBudget(Budget budget) {
    DateTime now = DateTime.now();
    if (now.isAfter(budget.resetDate)) {
      budget.currentValue = 0;
      budget.resetDate = calculateResetDate(
          budgetPeriodStrings[budget.budgetPeriodIndex], now);
      return true;
    }

    return false;
  }

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
