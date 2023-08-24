import 'dart:math';

import 'package:budgetron/logic/entry/entry_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Get date period method', () {
    const String week = 'Week';
    const String twoWeeks = 'Two weeks';
    const String month = 'Month';
    const String sixMonths = 'Six months';
    const String year = 'Year';

    test('Date period should be calculated properly (1 week)', () {
      expect(EntryService.getDatePeriod(week, end: DateTime(2023, 8, 5)),
          [DateTime(2023, 7, 31), DateTime(2023, 8, 5)]);
      expect(EntryService.getDatePeriod(week, end: DateTime(2023, 8, 7)),
          [DateTime(2023, 8, 7), DateTime(2023, 8, 7)]);
      expect(EntryService.getDatePeriod(week, end: DateTime(2023, 8, 8)),
          [DateTime(2023, 8, 7), DateTime(2023, 8, 8)]);
    });

    test('Date period should be calculated properly (2 weeks)', () {
      expect(EntryService.getDatePeriod(twoWeeks, end: DateTime(2023, 8, 5)),
          [DateTime(2023, 7, 24), DateTime(2023, 8, 5)]);
      expect(EntryService.getDatePeriod(twoWeeks, end: DateTime(2023, 8, 7)),
          [DateTime(2023, 7, 31), DateTime(2023, 8, 7)]);
      expect(EntryService.getDatePeriod(twoWeeks, end: DateTime(2023, 8, 8)),
          [DateTime(2023, 7, 31), DateTime(2023, 8, 8)]);
    });

    test('Date period should be calculated properly (month)', () {
      expect(EntryService.getDatePeriod(month, end: DateTime(2023, 8, 5)),
          [DateTime(2023, 8, 1), DateTime(2023, 8, 5)]);
      expect(EntryService.getDatePeriod(month, end: DateTime(2023, 8, 1)),
          [DateTime(2023, 8, 1), DateTime(2023, 8, 1)]);
      expect(EntryService.getDatePeriod(month, end: DateTime(2023, 8, 31)),
          [DateTime(2023, 8, 1), DateTime(2023, 8, 31)]);
    });

    test('Date period should be calculated properly (6 months)', () {
      expect(EntryService.getDatePeriod(sixMonths, end: DateTime(2023, 5, 5)),
          [DateTime(2022, 11, 1), DateTime(2023, 5, 5)]);
      expect(EntryService.getDatePeriod(sixMonths, end: DateTime(2023, 8, 10)),
          [DateTime(2023, 2, 1), DateTime(2023, 8, 10)]);
      expect(EntryService.getDatePeriod(sixMonths, end: DateTime(2023, 8, 31)),
          [DateTime(2023, 2, 1), DateTime(2023, 8, 31)]);
    });

    test('Date period should be calculated properly (year)', () {
      expect(EntryService.getDatePeriod(year, end: DateTime(2023, 5, 5)),
          [DateTime(2023, 1, 1), DateTime(2023, 5, 5)]);
      expect(EntryService.getDatePeriod(year, end: DateTime(2023, 1, 1)),
          [DateTime(2023, 1, 1), DateTime(2023, 1, 1)]);
    });
  });
}
