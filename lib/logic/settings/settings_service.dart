import 'package:budgetron/globals.dart' as globals;

import 'package:budgetron/db/settings_controller.dart';
import 'package:budgetron/models/settings.dart';

class SettingsService {
  static Future<String> getCurrency() async => (await _getSettings()).currency;

  static void setCurrency(String value) async {
    Settings settings = await _getSettings();
    settings.currency = value;

    SettingsController.updateSettings(settings);
    globals.currency = value;
  }

  static Future<Settings> _getSettings() async {
    return await SettingsController.getSettings()
        .first
        .then((value) => value.first);
  }
}
