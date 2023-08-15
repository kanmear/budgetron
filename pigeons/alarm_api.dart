import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/pigeon/budget.g.dart',
  dartOptions: DartOptions(),
  kotlinOut: 'android/app/src/main/kotlin/pigeon/budget.g.kt',
  kotlinOptions: KotlinOptions(),
))
@HostApi()
abstract class AlarmAPI {
  void setupBudgetReset(int budgetId, String firstTriggerDate, String period) {}
}

@FlutterApi()
abstract class BudgetAPI {
  void resetBudget(int budgetId) {}
}
