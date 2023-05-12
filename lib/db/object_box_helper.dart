import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:budgetron/objectbox.g.dart';
import 'package:budgetron/models/entry.dart';
import 'package:budgetron/models/category.dart';

class ObjectBox {
  late final Store store;
  late var admin;

  late final Box<Entry> entryBox;
  late final Box<Category> categoryBox;

  ObjectBox._create(this.store) {
    entryBox = Box<Entry>(store);
    categoryBox = Box<Category>(store);
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

  int addEntry(Entry entry, Category category) {
    entry.category.target = category;
    return entryBox.put(entry);
  }

  void clearEntries() async {
    entryBox.removeAll();
  }

  Stream<List<Category>> getCategories() {
    final builder = categoryBox.query()
      ..order(Category_.id, flags: Order.descending);
    return builder.watch(triggerImmediately: true).map((query) => query.find());
  }

  int addCategory(Category category) => categoryBox.put(category);

  void clearCategories() {
    categoryBox.removeAll();
  }
}
