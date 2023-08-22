package com.example.budgetron.flutter.engine

import io.flutter.embedding.engine.FlutterEngine

class FlutterEngineStorage {
    companion object {
        var engine: FlutterEngine? = null

        fun setFlutterEngine(flutterEngine: FlutterEngine) {
            this.engine = flutterEngine
        }

        fun getFlutterEngine(): FlutterEngine? {
            return this.engine
        }
    }
}