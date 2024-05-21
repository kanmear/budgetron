import 'package:budgetron/models/enums/entry_category_type.dart';
import 'package:budgetron/db/object_box_helper.dart';
import 'package:budgetron/models/category/category.dart';
import 'package:budgetron/objectbox.g.dart';

class CategoryController {
  static Stream<List<EntryCategory>> getCategories(
      String nameFilter, EntryCategoryType? typeFilter) {
    QueryBuilder<EntryCategory> queryBuilder;
    if (typeFilter != null) {
      bool isExpense = typeFilter == EntryCategoryType.expense;
      queryBuilder = _getCategoryBox()
          .query(EntryCategory_.isExpense.equals(isExpense) &
              EntryCategory_.name.contains(nameFilter, caseSensitive: false))
          .order(EntryCategory_.id, flags: Order.descending);
    } else {
      queryBuilder = _getCategoryBox()
          .query(EntryCategory_.name.contains(nameFilter, caseSensitive: false))
          .order(EntryCategory_.id, flags: Order.descending);
    }
    return queryBuilder
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  static Stream<List<EntryCategory>> getUntrackedExpenseCategories() {
    return _getCategoryBox()
        .query(EntryCategory_.isExpense.equals(true) &
            EntryCategory_.isBudgetTracked.equals(false))
        .order(EntryCategory_.id, flags: Order.descending)
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  static int addCategory(EntryCategory category) =>
      _getCategoryBox().put(category);

  static void updateCategory(EntryCategory category) =>
      _getCategoryBox().put(category);

  static void deleteCategory(int id) => _getCategoryBox().remove(id);

  static void clearCategories() => _getCategoryBox().removeAll();

  static Box<EntryCategory> _getCategoryBox() =>
      ObjectBox.store.box<EntryCategory>();
}
