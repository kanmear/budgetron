import 'package:budgetron/db/object_box_helper.dart';
import 'package:budgetron/models/budget/budget.dart';
import 'package:budgetron/models/category/category.dart';
import 'package:budgetron/models/entry.dart';
import 'package:budgetron/objectbox.g.dart';

class EntryController {
  static Entry getEntry(int id) => _getEntryBox().get(id)!;

  //TODO remove null checks, add default values for optional arguments instead
  static Stream<List<Entry>> getEntries(
      {List<DateTime>? period,
      List<EntryCategory>? categoryFilter,
      Budget? budgetFilter,
      List<int>? ids,
      bool? isExpense,
      int? accountId}) {
    QueryBuilder<Entry> queryBuilder;
    Condition<Entry>? condition;

    if (period != null) {
      condition =
          Entry_.dateTime.greaterOrEqual(period[0].millisecondsSinceEpoch) &
              Entry_.dateTime.lessOrEqual(period[1].millisecondsSinceEpoch);
    }

    if (ids != null) {
      var idCondition = Entry_.id.oneOf(ids);
      if (condition != null) {
        condition.and(idCondition);
      } else {
        condition = idCondition;
      }
    }

    queryBuilder = _getEntryBox().query(condition);

    if (budgetFilter != null) {
      queryBuilder.link(Entry_.budget, Budget_.id.equals(budgetFilter.id));
    }

    if (categoryFilter != null) {
      queryBuilder.link(Entry_.category,
          EntryCategory_.id.oneOf(categoryFilter.map((e) => e.id).toList()));
    }

    if (isExpense != null) {
      queryBuilder.link(
          Entry_.category, EntryCategory_.isExpense.equals(isExpense));
    }

    if (accountId != null) {
      queryBuilder.link(Entry_.account, Account_.id.equals(accountId));
    }

    queryBuilder.order(Entry_.dateTime, flags: Order.descending);

    return queryBuilder
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  static Stream<List<Entry>> getLatestEntries() {
    var queryBuilder = _getEntryBox().query();
    queryBuilder.order(Entry_.dateTime, flags: Order.descending);

    return queryBuilder.watch(triggerImmediately: true).map((query) {
      query.limit = 3;
      return query.find();
    });
  }

  static int addEntry(Entry entry) => _getEntryBox().put(entry);

  static bool deleteEntry(int id) => _getEntryBox().remove(id);

  static void clearEntries() async {
    _getEntryBox().removeAll();
  }

  static Box<Entry> _getEntryBox() => ObjectBox.store.box<Entry>();
}
