import 'package:budgetron/main.dart';
import 'package:budgetron/objectbox.g.dart';
import 'package:budgetron/models/entry.dart';
import 'package:budgetron/models/category.dart';

class EntryController {
  static Stream<List<Entry>> getEntries() {
    final builder = objectBox.entryBox.query()
      ..order(Entry_.id, flags: Order.descending);
    return builder.watch(triggerImmediately: true).map((query) => query.find());
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
