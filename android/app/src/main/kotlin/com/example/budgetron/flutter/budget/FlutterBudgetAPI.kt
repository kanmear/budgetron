package com.example.budgetron.flutter.budget

import BudgetAPI
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BinaryMessenger

class FlutterBudgetAPI(binaryMessenger: BinaryMessenger) : FlutterActivity() {
    var flutterApi: BudgetAPI? = null

    init {
        flutterApi = BudgetAPI(binaryMessenger)
    }

    fun callResetBudget(id: Long) {
//    fun callResetBudget(id: Long, callback: (Result<String>) -> Unit) {
        flutterApi!!.resetBudget(id) {
//            echo -> callback(Result.success(echo as String))
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
    }
}