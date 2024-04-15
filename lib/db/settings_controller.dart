import 'package:budgetron/objectbox.g.dart';

import 'package:budgetron/db/object_box_helper.dart';
import 'package:budgetron/models/settings.dart';

class SettingsController {
  static Stream<List<Settings>> getSettings() {
    return _getSettingsBox()
        .query(Settings_.id.equals(1))
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  static void setupSettings() async {
    _getSettingsBox().put(Settings());
  }

  static Box<Settings> _getSettingsBox() => ObjectBox.store.box<Settings>();
}
