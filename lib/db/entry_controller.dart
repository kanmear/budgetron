import 'package:budgetron/main.dart';
import 'package:budgetron/objectbox.g.dart';
import 'package:budgetron/models/entry.dart';
import 'package:budgetron/models/category.dart';

class EntryController {
  static Stream<List<Entry>> getEntries(List<DateTime>? period) {
    QueryBuilder<Entry> queryBuilder;
    if (period != null) {
      queryBuilder = objectBox.entryBox.query(
          Entry_.dateTime.greaterOrEqual(period[0].millisecondsSinceEpoch) &
              Entry_.dateTime.lessOrEqual(period[1].millisecondsSinceEpoch))
        ..order(Entry_.id, flags: Order.descending);
    } else {
      queryBuilder = objectBox.entryBox.query()
        ..order(Entry_.id, flags: Order.descending);
    }

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
