package com.example.budgetron.alarm

import android.app.Activity
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import com.example.budgetron.flutter.budget.FlutterBudgetAPI
import com.example.budgetron.flutter.engine.FlutterEngineStorage
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.BinaryMessenger

class AlarmReceiver: BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        val message = intent?.getStringExtra("EXTRA_MESSAGE") ?: return

        FlutterBudgetAPI(
            FlutterEngineStorage.getFlutterEngine()!!.dartExecutor.binaryMessenger
        ).callResetBudget(3)

        println(message)
    }
}