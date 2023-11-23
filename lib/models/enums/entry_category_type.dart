enum EntryCategoryType { expense, income }

class EntryCategoryMap {
  static String getName(EntryCategoryType category) {
    switch (category) {
      case EntryCategoryType.expense:
        return 'Expense';
      case EntryCategoryType.income:
        return 'Income';
      default:
        throw Exception('Not a valid EntryCategoryType value.');
    }
  }
}
