package com.example.budgetron

import AlarmAPI
import com.example.budgetron.flutter.budget.FlutterBudgetAPI
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity() {
    inner class ImplAlarmAPI : AlarmAPI {
        override fun setupBudgetReset(budgetId: Long, firstTriggerDate: String, period: String) {
            println("This is Kotlin called from Flutter $budgetId")

            FlutterBudgetAPI(this@MainActivity.flutterEngine!!.dartExecutor.binaryMessenger)
                    .callResetBudget(budgetId + 1)
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        AlarmAPI.setUp(flutterEngine.dartExecutor.binaryMessenger, ImplAlarmAPI())
    }
}
