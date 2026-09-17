package com.example.ledgr

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.provider.Telephony

class SmsReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action != Telephony.Sms.Intents.SMS_RECEIVED_ACTION) return
        val messages = Telephony.Sms.Intents.getMessagesFromIntent(intent)
        if (messages.isNullOrEmpty()) return
        val body = messages.joinToString(separator = "") { it.messageBody ?: "" }
        val sender = messages.first().displayOriginatingAddress ?: ""
        val dateMs = messages.first().timestampMillis
        SmsPlugin.emitIncoming(sender, body, dateMs)
    }
}
