import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:budgetron/objectbox.g.dart';
import 'package:budgetron/models/entry.dart';
import 'package:budgetron/models/category.dart';
import 'package:budgetron/models/enums/entry_category_type.dart';

class ObjectBox {
  late final Store store;
  late var admin;

  late final Box<Entry> entryBox;
  late final Box<EntryCategory> categoryBox;

  ObjectBox._create(this.store) {
    entryBox = Box<Entry>(store);
    categoryBox = Box<EntryCategory>(store);
    if (Admin.isAvailable()) {
      admin = Admin(store);
    }
  }

  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: join(docsDir.path, "budgetron"));
    return ObjectBox._create(store);
  }

  Stream<List<Entry>> getEntries() {
    final builder = entryBox.query()..order(Entry_.id, flags: Order.descending);
    return builder.watch(triggerImmediately: true).map((query) => query.find());
  }

  int addEntry(Entry entry, EntryCategory category) {
    category.usages++;
    categoryBox.put(category);

    entry.category.target = category;
    return entryBox.put(entry);
  }

  void clearEntries() async {
    entryBox.removeAll();
  }

  Stream<List<EntryCategory>> getCategories(
      String nameFilter, EntryCategoryType? typeFilter) {
    QueryBuilder<EntryCategory> queryBuilder;
    if (typeFilter != null) {
      bool isExpense = typeFilter == EntryCategoryType.expense;
      queryBuilder = categoryBox
          .query(EntryCategory_.isExpense.equals(isExpense) &
              EntryCategory_.name.contains(nameFilter, caseSensitive: false))
          .order(EntryCategory_.id, flags: Order.descending);
    } else {
      queryBuilder = categoryBox
          .query(EntryCategory_.name.contains(nameFilter, caseSensitive: false))
          .order(EntryCategory_.id, flags: Order.descending);
    }
    return queryBuilder
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  int addCategory(EntryCategory category) => categoryBox.put(category);

  //HACK dev tool
  void clearCategories() {
    // categoryBox.removeMany([12, 13, 14, 15]);
  }
}
