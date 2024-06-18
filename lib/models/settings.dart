import 'package:objectbox/objectbox.dart';

@Entity()
class Settings {
  int id = 0;

  // customizable settings

  // bool isDarkThemeOn;
  // int entryIconId;
  String currency;

  // internal data
  DateTime earliestEntryDate = DateTime.now();

  int defaultAccountId;

  int defaultDatePeriodEntries;
  int defaultDatePeriodStats;
  int defaultDatePeriodGroups;

  Settings({
    this.currency = '',
    this.defaultAccountId = -1,
    this.defaultDatePeriodEntries = 0,
    this.defaultDatePeriodStats = 2,
    this.defaultDatePeriodGroups = 2,
  });
}
