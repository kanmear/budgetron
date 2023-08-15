import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/pigeon/budget.g.dart',
  dartOptions: DartOptions(),
  kotlinOut: 'android/app/src/main/kotlin/pigeon/budget.g.kt',
  kotlinOptions: KotlinOptions(),
))
@FlutterApi()
abstract class BudgetAPI {
  void resetBudget(int budgetId) {}
}
