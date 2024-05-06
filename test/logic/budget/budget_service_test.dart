import 'package:budgetron/logic/budget/budget_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Get date period method', () {
    var week = BudgetPeriod.week.periodIndex;
    var month = BudgetPeriod.month.periodIndex;
    var year = BudgetPeriod.year.periodIndex;

    test('Date period should be calculated properly for weeks', () {
      expect(BudgetService.calculateDatePeriod(week, end: DateTime(2023, 8, 5)),
          [DateTime(2023, 7, 31), DateTime(2023, 8, 5)]);
      expect(BudgetService.calculateDatePeriod(week, end: DateTime(2023, 8, 7)),
          [DateTime(2023, 8, 7), DateTime(2023, 8, 7)]);
      expect(BudgetService.calculateDatePeriod(week, end: DateTime(2023, 8, 8)),
          [DateTime(2023, 8, 7), DateTime(2023, 8, 8)]);
    });

    test('Date period should be calculated properly for months', () {
      expect(
          BudgetService.calculateDatePeriod(month, end: DateTime(2023, 8, 5)),
          [DateTime(2023, 8, 1), DateTime(2023, 8, 5)]);
      expect(
          BudgetService.calculateDatePeriod(month, end: DateTime(2023, 8, 1)),
          [DateTime(2023, 8, 1), DateTime(2023, 8, 1)]);
      expect(
          BudgetService.calculateDatePeriod(month, end: DateTime(2023, 8, 31)),
          [DateTime(2023, 8, 1), DateTime(2023, 8, 31)]);
    });

    test('Date period should be calculated properly for years', () {
      expect(BudgetService.calculateDatePeriod(year, end: DateTime(2023, 5, 5)),
          [DateTime(2023, 1, 1), DateTime(2023, 5, 5)]);
      expect(BudgetService.calculateDatePeriod(year, end: DateTime(2023, 1, 1)),
          [DateTime(2023, 1, 1), DateTime(2023, 1, 1)]);
    });
  });
}
