import 'package:budgetron/globals.dart' as globals;

import 'package:budgetron/db/settings_controller.dart';
import 'package:budgetron/models/settings.dart';

class SettingsService {
  static Future<void> loadDataToGlobals() async {
    Settings settings = await _getSettings();

    globals.currency = settings.currency;
    globals.earliestEntryDate = settings.earliestEntryDate;
  }

  static Future<String> getCurrency() async => (await _getSettings()).currency;

  static void setCurrency(String value) async {
    Settings settings = await _getSettings();
    settings.currency = value;

    SettingsController.updateSettings(settings);
    globals.currency = value;
  }

  static Future<DateTime> getEarliestEntryDate() async =>
      (await _getSettings()).earliestEntryDate;

  static void setEarliestEntryDate(DateTime date) async {
    Settings settings = await _getSettings();
    settings.earliestEntryDate = date;

    SettingsController.updateSettings(settings);
    globals.earliestEntryDate = date;
  }

  static Future<Settings> _getSettings() async {
    return await SettingsController.getSettings()
        .first
        .then((value) => value.first);
  }
}
