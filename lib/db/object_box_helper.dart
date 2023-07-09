import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:budgetron/objectbox.g.dart';
import 'package:budgetron/models/entry.dart';
import 'package:budgetron/models/budget.dart';
import 'package:budgetron/models/category.dart';

class ObjectBox {
  late final Store store;
  late Admin admin;

  late final Box<Entry> entryBox;
  late final Box<EntryCategory> categoryBox;
  late final Box<Budget> budgetBox;

  ObjectBox._create(this.store) {
    entryBox = Box<Entry>(store);
    categoryBox = Box<EntryCategory>(store);
    budgetBox = Box<Budget>(store);

    if (Admin.isAvailable()) {
      admin = Admin(store);
    }
  }

  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: join(docsDir.path, "budgetron"));
    return ObjectBox._create(store);
  }
}
