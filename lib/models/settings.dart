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

  Settings({
    this.currency = '',
    this.defaultAccountId = 0,
  });
}
