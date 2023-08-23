import 'package:budgetron/logic/budget/budget_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Reset date method', () {
    test('Reset date should be calculated correctly for 1 week period', () {
      DateTime date1 = DateTime(2023, 8, 21);
      DateTime dateNext1 = DateTime(2023, 8, 28);
      expect(BudgetService.calculateResetDate(1, date: date1), dateNext1);

      DateTime date2 = DateTime(2023, 8, 20);
      DateTime dateNext2 = DateTime(2023, 8, 21);
      expect(BudgetService.calculateResetDate(1, date: date2), dateNext2);

      DateTime date3 = DateTime(2023, 8, 23);
      DateTime dateNext3 = DateTime(2023, 8, 28);
      expect(BudgetService.calculateResetDate(1, date: date3), dateNext3);
    });

    test('Month jump should be handled correctly', () {
      DateTime date1 = DateTime(2023, 8, 28);
      DateTime dateNext1 = DateTime(2023, 9, 4);
      expect(BudgetService.calculateResetDate(1, date: date1), dateNext1);

      DateTime date2 = DateTime(2023, 8, 30);
      DateTime dateNext2 = DateTime(2023, 9, 4);
      expect(BudgetService.calculateResetDate(1, date: date2), dateNext2);
    });

    test('Reset date should be calculated correctly for 2 weeks period', () {
      DateTime date1 = DateTime(2023, 8, 21);
      DateTime dateNext1 = DateTime(2023, 9, 4);
      expect(BudgetService.calculateResetDate(2, date: date1), dateNext1);

      DateTime date2 = DateTime(2023, 8, 20);
      DateTime dateNext2 = DateTime(2023, 8, 28);
      expect(BudgetService.calculateResetDate(2, date: date2), dateNext2);

      DateTime date3 = DateTime(2023, 8, 23);
      DateTime dateNext3 = DateTime(2023, 9, 4);
      expect(BudgetService.calculateResetDate(2, date: date3), dateNext3);
    });
  });
}
