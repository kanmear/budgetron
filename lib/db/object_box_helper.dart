import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:budgetron/objectbox.g.dart';
import 'package:budgetron/models/entry.dart';

class ObjectBox {
  late final Store store;
  late var admin;

  late final Box<Entry> entryBox;
  late final Box<Section> sectionBox;

  ObjectBox._create(this.store) {
    entryBox = Box<Entry>(store);
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

  int addEntry(Entry entry, Section section) {
    entry.section.target = section;
    return entryBox.put(entry);
  }

  void clearEntries() async {
    entryBox.removeAll();
  }
}
