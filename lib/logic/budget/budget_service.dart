import 'package:flutter/material.dart';

import 'package:budgetron/db/entry_controller.dart';
import 'package:budgetron/models/budget/budget_history.dart';
import 'package:budgetron/db/category_controller.dart';
import 'package:budgetron/models/budget/budget.dart';
import 'package:budgetron/db/budget_controller.dart';
import 'package:budgetron/models/category/category.dart';
import 'package:budgetron/models/entry.dart';
import 'package:budgetron/utils/date_utils.dart';

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
  static BudgetPeriod getPeriodByIndex(int id) =>
      BudgetPeriod.values.where((p) => p.periodIndex == id).first;

  static int createBudget(Budget budget, EntryCategory category) {
    category.isBudgetTracked = true;
    CategoryController.updateCategory(category);

    budget.category.target = category;
    return BudgetController.addBudget(budget);
  }

  static void deleteBudget(Budget budget) async {
    EntryCategory category = budget.category.target!;
    category.isBudgetTracked = false;
    CategoryController.updateCategory(category);

    var histories = await BudgetController.getBudgetHistories(budget.id).first;
    for (var history in histories) {
      BudgetController.deleteHistory(history.id);
    }

    BudgetController.deleteBudget(budget.id);
  }

  static void addEntryToBudget(
      int categoryId, int entryId, double delta) async {
    Budget budget = (await BudgetController.getBudgetByCategory(categoryId));

    if (budget.isArchived) return;

    resetBudget(budget);
    budget.currentValue += delta;

    Entry entry = EntryController.getEntry(entryId);
    entry.budget.target = budget;
    EntryController.addEntry(entry);

    BudgetController.updateBudget(budget);
  }

  static void updateBudget(int categoryId, double delta) async {
    Budget budget = (await BudgetController.getBudgetByCategory(categoryId));

    if (budget.isArchived) return;

    resetBudget(budget);
    budget.currentValue += delta;

    BudgetController.updateBudget(budget);
  }

  static Future<void> deleteEntryFromBudget(
      int categoryId, int entryId, double delta) async {
    Budget budget = await BudgetController.getBudgetByCategory(categoryId);

    Entry entry = EntryController.getEntry(entryId);
    entry.budget.target = null;
    entry.budget.targetId = null;
    EntryController.addEntry(entry);

    if (!budget.isArchived) {
      resetBudget(budget);
      budget.currentValue += delta;
    }

    BudgetController.updateBudget(budget);

    var histories = await BudgetController.getBudgetHistories(budget.id).first;
    if (histories.isEmpty) return;
    for (var history in histories) {
      //FIX possible time slip
      if (entry.dateTime.isBefore(history.endDate) &&
          entry.dateTime.isAfter(history.startDate)) {
        history.endValue += delta;

        BudgetController.addBudgetHistory(history);
        return;
      }
    }
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
      _addBudgetHistory(budget, budget.resetDate);

      budget.currentValue = 0;
      budget.resetDate =
          calculateResetDate(budget.budgetPeriodIndex, budget.resetDate);

      return true;
    }

    return false;
  }

  //TODO optional argument is only needed for testing, any way to remove and keep tests?
  static List<DateTime> calculateDatePeriod(int periodIndex, {DateTime? end}) {
    end ??= DateTime.now();

    var period = getPeriodByIndex(periodIndex);
    DateTime start;

    switch (period) {
      case BudgetPeriod.month:
        start = DateTime(end.year, end.month);
        break;
      case BudgetPeriod.week:
        start = BudgetronDateUtils.shiftToStartOfWeek(end);
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
    var period = getPeriodByIndex(periodIndex);

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

  static _addBudgetHistory(Budget budget, DateTime resetDate) {
    BudgetHistory budgetHistory = BudgetHistory(
        targetValue: budget.targetValue,
        endValue: budget.currentValue,
        budgetPeriodIndex: budget.budgetPeriodIndex,
        startDate: calculateStartDate(resetDate, budget.budgetPeriodIndex),
        endDate: resetDate);
    budgetHistory.budget.target = budget;

    BudgetController.addBudgetHistory(budgetHistory);
  }

  static DateTime calculateStartDate(DateTime endDate, int periodIndex) {
    var period = getPeriodByIndex(periodIndex);

    switch (period) {
      case BudgetPeriod.week:
        return DateUtils.addDaysToDate(endDate, -7);
      case BudgetPeriod.month:
        return DateUtils.addMonthsToMonthDate(endDate, -1);
      case BudgetPeriod.year:
        return DateTime(endDate.year - 1);
      default:
        throw Exception('Not a valid period ID.');
    }
  }
}
