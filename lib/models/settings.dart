import 'package:objectbox/objectbox.dart';

@Entity()
class Settings {
  int id = 0;

  // bool isDarkThemeOn;
  // int entryIconId;
  String currency;

  Settings({this.currency = "BYN"});
}
