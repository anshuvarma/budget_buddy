package com.example.budget_buddy

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.budget_buddy/notifications"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "showTransactionPrompt") {
                    // Handle the showTransactionPrompt method call
                    val amount = call.argument<String>("amount")
                    val description = call.argument<String>("description")
                    showTransactionNotification(amount, description)
                    result.success("Notification displayed")
                } else {
                    result.notImplemented()
                }
            }
    }

    private fun showTransactionNotification(amount: String?, description: String?) {
        // Create a notification channel for Android 8.0 and above
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channelId = "transaction_channel"
            val channelName = "Transaction Notifications"
            val channelDescription = "Channel for showing transaction notifications"
            val importance = NotificationManager.IMPORTANCE_DEFAULT
            val channel = NotificationChannel(channelId, channelName, importance)
            channel.description = channelDescription

            // Register the channel with the system
            val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }

        val notificationManager = NotificationManagerCompat.from(this)

        // Build the notification
        val notification = NotificationCompat.Builder(this, "transaction_channel")
            .setSmallIcon(R.drawable.ic_notification)  // Ensure this icon exists
            .setContentTitle("New Transaction")
            .setContentText("Amount: $amount, Description: $description")
            .setPriority(NotificationCompat.PRIORITY_DEFAULT)
            .build()

        // Show the notification
        notificationManager.notify(0, notification)
    }
}
