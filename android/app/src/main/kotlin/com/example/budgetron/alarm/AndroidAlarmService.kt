package com.example.budgetron.alarm

import android.app.Activity
import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import java.time.LocalDateTime
import java.time.ZoneId

class AndroidAlarmService(
        private val context: Context
): AlarmService {

    private val alarmManager = context.getSystemService(AlarmManager::class.java)

    override fun schedule() {
        val intent = Intent(context, AlarmReceiver::class.java).apply {
            putExtra("EXTRA_MESSAGE", "test message to receiver")
        }

        alarmManager.setRepeating(
                AlarmManager.RTC_WAKEUP,
                LocalDateTime.now().atZone(ZoneId.systemDefault()).toEpochSecond() * 1000,
//                LocalDateTime.now().plusMinutes(1).atZone(ZoneId.systemDefault()).toEpochSecond() * 1000,
                120000,
                PendingIntent.getBroadcast(
                        context,
                        7120938,
                        intent,
                        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                ))
    }

    override fun cancel() {
        alarmManager.cancel(
                PendingIntent.getBroadcast(
                        context,
                        7120938,
                        Intent(context, AlarmReceiver::class.java),
                        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )
        )
    }
}