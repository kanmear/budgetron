import 'package:budgetron/db/entry_controller.dart';
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
    } else {
      var entries = EntryController.getEntries();
      settings.first.earliestEntryDate = (await entries.first)
          .reduce((value, element) =>
              value.dateTime.isBefore(element.dateTime) ? value : element)
          .dateTime;
      updateSettings(settings.first);
    }
  }

  static void updateSettings(Settings settings) {
    _getSettingsBox().put(settings);
  }

  static Box<Settings> _getSettingsBox() => ObjectBox.store.box<Settings>();
}
