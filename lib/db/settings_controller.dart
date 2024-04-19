import 'package:budgetron/db/object_box_helper.dart';
import 'package:budgetron/models/settings.dart';
import 'package:budgetron/objectbox.g.dart';

class SettingsController {
  static Stream<List<Settings>> getSettings() {
    return _getSettingsBox()
        .query(Settings_.id.equals(1))
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  static Future<void> setupSettings() async {
    List<Settings> settings = await getSettings().first;
    if (settings.isEmpty) {
      _getSettingsBox().put(Settings());
    }
  }

  static void updateSettings(Settings settings) {
    _getSettingsBox().put(settings);
  }

  static Box<Settings> _getSettingsBox() => ObjectBox.store.box<Settings>();
}
