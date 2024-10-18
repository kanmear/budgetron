import 'globals.dart' as globals;
import 'package:flutter/material.dart';

import 'package:budgetron/ui/data/colors.dart';
import 'package:budgetron/logic/settings/settings_service.dart';

class AppData extends ChangeNotifier {
  late ColorScheme _darkScheme = BudgetronColors.darkColorScheme;
  late ColorScheme _lightScheme = BudgetronColors.lightColorScheme;

  ThemeMode get themeMode => globals.themeMode;
  void setThemeMode(ThemeMode value) {
    SettingsService.setThemeMode(value);
    notifyListeners();
  }

  ColorScheme get darkScheme => _darkScheme;
  void setDarkScheme(ColorScheme value) {
    _darkScheme = value;
    notifyListeners();
  }

  ColorScheme get lightScheme => _lightScheme;
  void setLightScheme(ColorScheme value) {
    _lightScheme = value;
    notifyListeners();
  }

  int get currencyIndex => globals.currencyIndex;

  void setCurrency(int value) {
    SettingsService.setCurrency(value);
    notifyListeners();
  }

  //REFACTOR probably can be removed
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
