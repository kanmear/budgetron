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
  }

  int get defaultAccountId => globals.defaultAccountId;

  void setDefaultAccountId(int id) {
    SettingsService.setDefaultAccountId(id);
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
