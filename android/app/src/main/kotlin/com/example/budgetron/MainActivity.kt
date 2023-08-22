package com.example.budgetron

import android.app.Activity
import com.example.budgetron.alarm.AndroidAlarmService
import com.example.budgetron.flutter.engine.FlutterEngineStorage
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import pigeon.AlarmAPI

class MainActivity: FlutterActivity() {
    inner class ImplAlarmAPI : AlarmAPI {
        override fun setupBudgetReset(budgetId: Long, firstTriggerDate: String, period: String) {
            println("This is Kotlin called from Flutter $budgetId")

            val alarmService = AndroidAlarmService(context)
            alarmService.schedule()

//            FlutterBudgetAPI(this@MainActivity.flutterEngine!!.dartExecutor.binaryMessenger)
//                    .callResetBudget(budgetId + 1)
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        AlarmAPI.setUp(flutterEngine.dartExecutor.binaryMessenger, ImplAlarmAPI())
        FlutterEngineStorage.setFlutterEngine(flutterEngine)
    }
}
