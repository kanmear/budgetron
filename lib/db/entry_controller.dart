import 'package:budgetron/db/category_controller.dart';
import 'package:budgetron/db/object_box_helper.dart';
import 'package:budgetron/models/category.dart';
import 'package:budgetron/models/entry.dart';
import 'package:budgetron/objectbox.g.dart';

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

    queryBuilder = _getEntryBox().query(condition);

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
    CategoryController.addCategory(category);

    entry.category.target = category;
    return _getEntryBox().put(entry);
  }

  static void clearEntries() async {
    _getEntryBox().removeAll();
  }

  static Box<Entry> _getEntryBox() => ObjectBox.store.box<Entry>();
}
