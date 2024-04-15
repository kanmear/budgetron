import 'package:budgetron/db/settings_controller.dart';
import 'package:budgetron/models/settings.dart';

class SettingsService {
  static Future<String> getCurrency() async => (await _getSettings()).currency;

  static Future<Settings> _getSettings() async {
    return await SettingsController.getSettings()
        .first
        .then((value) => value.first);
  }
}
