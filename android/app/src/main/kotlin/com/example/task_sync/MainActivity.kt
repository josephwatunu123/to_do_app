package com.example.task_sync

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.*

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.tasksync/notifications"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            if (call.method == "scheduleNotification") {
                val title = call.argument<String>("title") ?: "Task"
                val timestamp = call.argument<Long>("timestamp") ?: 0L

                scheduleNotification(title, timestamp)
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun scheduleNotification(title: String, timestamp: Long) {
        val intent = Intent(applicationContext, NotificationReceiver::class.java).apply {
            putExtra("title", title)
        }

        val pendingIntent = PendingIntent.getBroadcast(
            applicationContext,
            timestamp.toInt(), // unique ID
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
        alarmManager.setExact(
            AlarmManager.RTC_WAKEUP,
            timestamp,
            pendingIntent
        )
    }
}
