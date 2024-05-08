import 'package:budgetron/models/budget/budget_history.dart';
import 'package:budgetron/db/category_controller.dart';
import 'package:budgetron/models/budget/budget.dart';
import 'package:budgetron/db/budget_controller.dart';
import 'package:budgetron/models/category.dart';
import 'package:flutter/material.dart';

enum BudgetPeriod {
  week(periodIndex: 0, name: 'Week'),
  month(periodIndex: 1, name: 'Month'),
  year(periodIndex: 2, name: 'Year');

  final String name;
  final int periodIndex;

  const BudgetPeriod({required this.name, required this.periodIndex});

  @override
  toString() => name;
}

class BudgetService {
  //TODO rename to getPeriodByIndex
  static BudgetPeriod getPeriodById(int id) =>
      BudgetPeriod.values.where((p) => p.periodIndex == id).first;

  static void createBudget(Budget budget, EntryCategory category) {
    category.isBudgetTracked = true;
    CategoryController.updateCategory(category);

    budget.category.target = category;
    BudgetController.addBudget(budget);
  }

  static void deleteBudget(Budget budget) {
    EntryCategory category = budget.category.target!;
    category.isBudgetTracked = false;
    CategoryController.updateCategory(category);

    BudgetController.deleteBudget(budget.id);
  }

  static void addEntryToBudget(
      int categoryId, int entryId, double delta) async {
    Budget budget = (await BudgetController.getBudgetByCategory(categoryId));

    if (budget.isArchived) return;

    resetBudget(budget);
    budget.currentValue += delta;
    budget.entriesIDs.add(entryId);

    BudgetController.updateBudget(budget);
  }

  static void updateBudget(int categoryId, double delta) async {
    Budget budget = (await BudgetController.getBudgetByCategory(categoryId));

    if (budget.isArchived) return;

    resetBudget(budget);
    budget.currentValue += delta;

    BudgetController.updateBudget(budget);
  }

  static void deleteEntryFromBudget(
      int categoryId, int entryId, double delta) async {
    Budget budget = (await BudgetController.getBudgetByCategory(categoryId));
    budget.entriesIDs.remove(entryId);

    if (!budget.isArchived) {
      resetBudget(budget);
      budget.currentValue += delta;
    }

    BudgetController.updateBudget(budget);
  }

  static void changeBudgetDetails(
      int budgetId,
      int newBudgetPeriodIndex,
      double newTargetValue,
      double recalculatedCurrentValue,
      DateTime resetDate,
      bool isOnMainPage) {
    Budget budget = BudgetController.getBudget(budgetId);

    budget.targetValue = newTargetValue;
    budget.budgetPeriodIndex = newBudgetPeriodIndex;
    budget.currentValue = recalculatedCurrentValue;
    budget.resetDate = resetDate;
    budget.onMainPage = isOnMainPage;

    BudgetController.updateBudget(budget);
  }

  static bool resetBudget(Budget budget) {
    DateTime now = DateTime.now();
    if (now.isAfter(budget.resetDate)) {
      _addBudgetHistory(budget, now);

      budget.currentValue = 0;
      budget.resetDate =
          calculateResetDate(budget.budgetPeriodIndex, budget.resetDate);

      return true;
    }

    return false;
  }

  static List<DateTime> calculateDatePeriod(int periodIndex, {DateTime? end}) {
    end ??= DateTime.now();

    var period = getPeriodById(periodIndex);
    DateTime start;

    switch (period) {
      case BudgetPeriod.month:
        start = DateTime(end.year, end.month);
        break;
      case BudgetPeriod.week:
        start = _getPastMonday(end);
        break;
      case BudgetPeriod.year:
        start = DateTime(end.year);
        break;
      default:
        throw Exception('Not a valid period ID.');
    }

    return [start, end];
  }

  static DateTime calculateResetDate(int periodIndex, DateTime fromDate) {
    var period = getPeriodById(periodIndex);

    switch (period) {
      case BudgetPeriod.week:
        return DateUtils.addDaysToDate(fromDate, 7);
      case BudgetPeriod.month:
        return DateUtils.addMonthsToMonthDate(fromDate, 1);
      case BudgetPeriod.year:
        return DateTime(fromDate.year + 1);
      default:
        throw Exception('Not a valid period ID.');
    }
  }

  static List<int> getDatePeriods(List<Budget> budgets) {
    List<int> datePeriods = [];
    for (var budget in budgets) {
      if (!datePeriods.contains(budget.budgetPeriodIndex)) {
        datePeriods.add(budget.budgetPeriodIndex);
      }
    }

    datePeriods.sort((a, b) => a.compareTo(b));
    return datePeriods;
  }

  static String calculateRemainingDays(DateTime resetDate) {
    int remainingDays = resetDate.difference(DateTime.now()).inDays;

    if (remainingDays >= 30) {
      int remainingMonths = remainingDays ~/ 30;
      int leftoverDays = remainingDays % 30;
      return '$remainingMonths ${remainingMonths == 1 ? 'month' : 'months'} '
          'and $leftoverDays ${leftoverDays == 1 ? 'day' : 'days'} left';
    }

    return remainingDays == 1
        ? '$remainingDays day left'
        : '$remainingDays days left';
  }

  static DateTime _getPastMonday(DateTime weekStart) {
    while (weekStart.weekday != 1) {
      weekStart = DateUtils.addDaysToDate(weekStart, -1);
    }

    return weekStart;
  }

  static _addBudgetHistory(Budget budget, DateTime endDate) {
    BudgetHistory budgetHistory = BudgetHistory(
        targetValue: budget.targetValue,
        endValue: budget.currentValue,
        budgetPeriodIndex: budget.budgetPeriodIndex,
        endDate: endDate);
    budgetHistory.budget.target = budget;
    BudgetController.addBudgetHistory(budgetHistory);
  }
}
