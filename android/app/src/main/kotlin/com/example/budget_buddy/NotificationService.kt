package com.example.budget_buddy

import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import android.util.Log

class NotificationService : NotificationListenerService() {

    override fun onNotificationPosted(sbn: StatusBarNotification) {
        val packageName = sbn.packageName
        val notificationText = sbn.notification.extras.getString("android.text")

        Log.d("NotificationService", "Notification from: $packageName, Text: $notificationText")

        if (packageName == "com.google.android.apps.nbu.paisa.user" ||  // Google Pay
            packageName == "com.phonepe.app" ||                         // PhonePe
            packageName == "com.dreamplug.androidapp") {                // CRED
            Log.d("NotificationService", "Payment Notification Detected: $notificationText")
        }
    }
}
