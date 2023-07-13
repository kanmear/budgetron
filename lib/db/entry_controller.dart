import 'package:budgetron/main.dart';
import 'package:budgetron/objectbox.g.dart';
import 'package:budgetron/models/entry.dart';
import 'package:budgetron/models/category.dart';

class EntryController {
  static Stream<List<Entry>> getEntries(
      {List<DateTime>? period, List<EntryCategory>? categoryFilter}) {
    QueryBuilder<Entry> queryBuilder;
    Condition<Entry>? condition;

    if (period != null) {
      condition =
          Entry_.dateTime.greaterOrEqual(period[0].millisecondsSinceEpoch) &
              Entry_.dateTime.lessOrEqual(period[1].millisecondsSinceEpoch);
    }

    queryBuilder = objectBox.entryBox.query(condition);

    if (categoryFilter != null) {
      queryBuilder.link(Entry_.category,
          EntryCategory_.id.oneOf(categoryFilter.map((e) => e.id).toList()));
    }

    queryBuilder.order(Entry_.id, flags: Order.descending);

    return queryBuilder
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  static int addEntry(Entry entry, EntryCategory category) {
    category.usages++;
    objectBox.categoryBox.put(category);

    entry.category.target = category;
    return objectBox.entryBox.put(entry);
  }

  static void clearEntries() async {
    objectBox.entryBox.removeAll();
  }
}
