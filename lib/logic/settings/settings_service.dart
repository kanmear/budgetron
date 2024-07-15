import 'package:budgetron/globals.dart' as globals;

import 'package:budgetron/db/settings_controller.dart';
import 'package:budgetron/models/settings.dart';
import 'package:flutter/src/material/app.dart';

class SettingsService {
  static Future<void> loadDataToGlobals() async {
    Settings settings = await _getSettings();

    globals.currency = settings.currency;
    globals.earliestEntryDate = settings.earliestEntryDate;
    globals.defaultAccountId = settings.defaultAccountId;
    globals.themeMode = ThemeMode.values
        .where((e) => e.index == settings.themeModeIndex)
        .toList()
        .first;
    // globals.defaultDatePeriodEntries = settings.defaultDatePeriodEntries;
    // globals.defaultDatePeriodGroups = settings.defaultDatePeriodGroups;
    // globals.defaultDatePeriodStats = settings.defaultDatePeriodStats;
  }

  //TODO remove separate getters
  static Future<String> getCurrency() async => (await _getSettings()).currency;

  static void setThemeMode(ThemeMode value) async {
    Settings settings = await _getSettings();
    settings.themeModeIndex = value.index;

    SettingsController.updateSettings(settings);
    globals.themeMode = value;
  }

  static void setCurrency(String value) async {
    Settings settings = await _getSettings();
    settings.currency = value;

    SettingsController.updateSettings(settings);
    globals.currency = value;
  }

  //TODO remove separate getters
  static Future<DateTime> getEarliestEntryDate() async =>
      (await _getSettings()).earliestEntryDate;

  static void setEarliestEntryDate(DateTime date) async {
    Settings settings = await _getSettings();
    settings.earliestEntryDate = date;

    SettingsController.updateSettings(settings);
    globals.earliestEntryDate = date;
  }

  static void setDefaultAccountId(int id) async {
    Settings settings = await _getSettings();
    settings.defaultAccountId = id;

    SettingsController.updateSettings(settings);
    globals.defaultAccountId = id;
  }

  static void setLegacyDateSelector(bool isLegacy) async {
    Settings settings = await _getSettings();
    settings.legacyDateSelector = isLegacy;

    SettingsController.updateSettings(settings);
    globals.legacyDateSelector = isLegacy;
  }

  static void setDefaultDatePeriodEntries(int id) async {
    Settings settings = await _getSettings();
    settings.defaultDatePeriodEntries = id;

    SettingsController.updateSettings(settings);
    globals.defaultDatePeriodEntries = id;
  }

  static void setDefaultDatePeriodStats(int id) async {
    Settings settings = await _getSettings();
    settings.defaultDatePeriodStats = id;

    SettingsController.updateSettings(settings);
    globals.defaultDatePeriodStats = id;
  }

  static void setDefaultDatePeriodGroups(int id) async {
    Settings settings = await _getSettings();
    settings.defaultDatePeriodGroups = id;

    SettingsController.updateSettings(settings);
    globals.defaultDatePeriodGroups = id;
  }

  static Future<Settings> _getSettings() async {
    return await SettingsController.getSettings()
        .first
        .then((value) => value.first);
  }
}
