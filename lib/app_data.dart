import 'globals.dart' as globals;
import 'package:flutter/material.dart';

import 'package:budgetron/logic/settings/settings_service.dart';

class AppData extends ChangeNotifier {
  String get currency => globals.currency;

  void setCurrency(String value) {
    SettingsService.setCurrency(value);
    notifyListeners();
  }

  DateTime get earliestEntryDate => globals.earliestEntryDate;

  //TODO set this whenever an entry created with date < this one
  void setEarliestEntryDate(DateTime date) {
    SettingsService.setEarliestEntryDate(date);
    notifyListeners();
  }

  bool get legacyDateSelector => globals.legacyDateSelector;

  //TODO set this whenever an entry created with date < this one
  void setLegacyDateSelector(bool isLegacy) {
    SettingsService.setLegacyDateSelector(isLegacy);
    notifyListeners();
  }

  int get defaultAccountId => globals.defaultAccountId;

  void setDefaultAccountId(int id) {
    SettingsService.setDefaultAccountId(id);
    notifyListeners();
  }

  int get defaultDatePeriodEntries => globals.defaultDatePeriodEntries;

  void setDefaultDatePeriodEntries(int id) {
    SettingsService.setDefaultDatePeriodEntries(id);
    notifyListeners();
  }

  int get defaultDatePeriodStats => globals.defaultDatePeriodStats;

  void setDefaultDatePeriodStats(int id) {
    SettingsService.setDefaultDatePeriodStats(id);
    notifyListeners();
  }

  int get defaultDatePeriodGroups => globals.defaultDatePeriodGroups;

  void setDefaultDatePeriodGroups(int id) {
    SettingsService.setDefaultDatePeriodGroups(id);
    notifyListeners();
  }

  // Locale _locale = Locale('en', 'US');
  // ThemeData _theme = ThemeData.light();
  //
  // Locale get locale => _locale;
  // ThemeData get theme => _theme;
  //
  // void setLocale(Locale locale) {
  //   _locale = locale;
  //   notifyListeners();
  // }
  //
  // void setTheme(ThemeData theme) {
  //   _theme = theme;
  //   notifyListeners();
  // }
}
