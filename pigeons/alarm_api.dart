import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/pigeon/alarm.g.dart',
  dartOptions: DartOptions(),
  kotlinOut: 'android/app/src/main/kotlin/pigeon/alarm.g.kt',
  kotlinOptions: KotlinOptions(),
))
@HostApi()
abstract class AlarmAPI {
  void setupBudgetReset(int budgetId, String firstTriggerDate, String period) {}
}
