import 'package:budgetron/db/object_box_helper.dart';
import 'package:budgetron/models/category.dart';
import 'package:budgetron/models/entry.dart';
import 'package:budgetron/objectbox.g.dart';

class EntryController {
  static Stream<List<Entry>> getEntries(
      {List<DateTime>? period,
      List<EntryCategory>? categoryFilter,
      bool? isExpense}) {
    QueryBuilder<Entry> queryBuilder;
    Condition<Entry>? condition;

    if (period != null) {
      condition =
          Entry_.dateTime.greaterOrEqual(period[0].millisecondsSinceEpoch) &
              Entry_.dateTime.lessOrEqual(period[1].millisecondsSinceEpoch);
    }

    queryBuilder = _getEntryBox().query(condition);

    if (categoryFilter != null) {
      queryBuilder.link(Entry_.category,
          EntryCategory_.id.oneOf(categoryFilter.map((e) => e.id).toList()));
    }

    if (isExpense != null) {
      queryBuilder.link(
          Entry_.category, EntryCategory_.isExpense.equals(isExpense));
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

  static void clearEntries() async {
    _getEntryBox().removeAll();
  }

  static Box<Entry> _getEntryBox() => ObjectBox.store.box<Entry>();
}
