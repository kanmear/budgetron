import 'package:objectbox/objectbox.dart';

@Entity()
class Settings {
  int id = 0;

  // customizable settings

  // bool isDarkThemeOn;
  // int entryIconId;
  int currencyId;

  // internal data
  DateTime earliestEntryDate = DateTime.now();

  bool legacyDateSelector;

  int defaultAccountId;

  int defaultDatePeriodEntries;
  int defaultDatePeriodStats;
  int defaultDatePeriodGroups;

  int themeModeIndex;

  Settings({
    this.themeModeIndex = 0,
    this.currencyId = 0,
    this.defaultAccountId = -1,
    this.legacyDateSelector = false,
    this.defaultDatePeriodEntries = 0,
    this.defaultDatePeriodStats = 2,
    this.defaultDatePeriodGroups = 2,
  });
}
