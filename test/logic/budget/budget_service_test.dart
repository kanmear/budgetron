import 'package:budgetron/logic/budget/budget_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Get date period method', () {
    const String week = 'Week';
    const String twoWeeks = 'Two weeks';
    const String month = 'Month';
    const String sixMonths = 'Six months';
    const String year = 'Year';

    test('Date period should be calculated properly (1 week)', () {
      expect(BudgetService.calculateDatePeriod(week, end: DateTime(2023, 8, 5)),
          [DateTime(2023, 7, 31), DateTime(2023, 8, 5)]);
      expect(BudgetService.calculateDatePeriod(week, end: DateTime(2023, 8, 7)),
          [DateTime(2023, 8, 7), DateTime(2023, 8, 7)]);
      expect(BudgetService.calculateDatePeriod(week, end: DateTime(2023, 8, 8)),
          [DateTime(2023, 8, 7), DateTime(2023, 8, 8)]);
    });

    test('Date period should be calculated properly (2 weeks)', () {
      expect(
          BudgetService.calculateDatePeriod(twoWeeks,
              end: DateTime(2023, 8, 5)),
          [DateTime(2023, 7, 24), DateTime(2023, 8, 5)]);
      expect(
          BudgetService.calculateDatePeriod(twoWeeks,
              end: DateTime(2023, 8, 7)),
          [DateTime(2023, 7, 31), DateTime(2023, 8, 7)]);
      expect(
          BudgetService.calculateDatePeriod(twoWeeks,
              end: DateTime(2023, 8, 8)),
          [DateTime(2023, 7, 31), DateTime(2023, 8, 8)]);
    });

    test('Date period should be calculated properly (month)', () {
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

    test('Date period should be calculated properly (6 months)', () {
      expect(
          BudgetService.calculateDatePeriod(sixMonths,
              end: DateTime(2023, 5, 5)),
          [DateTime(2022, 11, 1), DateTime(2023, 5, 5)]);
      expect(
          BudgetService.calculateDatePeriod(sixMonths,
              end: DateTime(2023, 8, 10)),
          [DateTime(2023, 2, 1), DateTime(2023, 8, 10)]);
      expect(
          BudgetService.calculateDatePeriod(sixMonths,
              end: DateTime(2023, 8, 31)),
          [DateTime(2023, 2, 1), DateTime(2023, 8, 31)]);
    });

    test('Date period should be calculated properly (year)', () {
      expect(BudgetService.calculateDatePeriod(year, end: DateTime(2023, 5, 5)),
          [DateTime(2023, 1, 1), DateTime(2023, 5, 5)]);
      expect(BudgetService.calculateDatePeriod(year, end: DateTime(2023, 1, 1)),
          [DateTime(2023, 1, 1), DateTime(2023, 1, 1)]);
    });
  });
}
