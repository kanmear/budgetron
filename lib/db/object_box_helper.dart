import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'package:budgetron/objectbox.g.dart';

class ObjectBox {
  static late final Store store;

  // web db browsing
  static late Admin admin;

  static Future init() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final dbPath = join(docsDir.path, 'db');

    if (Store.isOpen(dbPath)) {
      store = Store.attach(getObjectBoxModel(), dbPath);
    } else {
      store = await openStore(directory: join(docsDir.path, 'db'));

      if (Admin.isAvailable()) {
        admin = Admin(store);
      }
    }
  }
}
