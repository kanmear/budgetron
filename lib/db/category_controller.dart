import 'package:budgetron/main.dart';
import 'package:budgetron/objectbox.g.dart';
import 'package:budgetron/models/category.dart';
import 'package:budgetron/models/enums/entry_category_type.dart';

class CategoryController {
  static Stream<List<EntryCategory>> getCategories(
      String nameFilter, EntryCategoryType? typeFilter) {
    QueryBuilder<EntryCategory> queryBuilder;
    if (typeFilter != null) {
      bool isExpense = typeFilter == EntryCategoryType.expense;
      queryBuilder = objectBox.categoryBox
          .query(EntryCategory_.isExpense.equals(isExpense) &
              EntryCategory_.name.contains(nameFilter, caseSensitive: false))
          .order(EntryCategory_.id, flags: Order.descending);
    } else {
      queryBuilder = objectBox.categoryBox
          .query(EntryCategory_.name.contains(nameFilter, caseSensitive: false))
          .order(EntryCategory_.id, flags: Order.descending);
    }
    return queryBuilder
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  static int addCategory(EntryCategory category) =>
      objectBox.categoryBox.put(category);

  //HACK dev tool
  static void clearCategories() {
    // categoryBox.removeMany([12, 13, 14, 15]);
  }
}
