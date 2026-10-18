package com.example.ledgr

import android.content.Context
import org.json.JSONArray
import org.json.JSONObject
import java.util.UUID

object BankSmsQueue {
    private const val PREFS = "ledgr_sms_queue"
    private const val KEY = "pending"
    private const val MAX = 300

    fun enqueue(context: Context, sender: String, body: String, dateMs: Long): String {
        val cleaned = body.trim()
        val prefs = prefs(context)
        val rows = pendingRaw(prefs)
        for (i in 0 until rows.length()) {
            val row = rows.optJSONObject(i) ?: continue
            if (row.optString("sender") == sender && row.optString("body") == cleaned) {
                return row.optString("id")
            }
        }
        val id = UUID.randomUUID().toString()
        rows.put(
            JSONObject().apply {
                put("id", id)
                put("sender", sender)
                put("body", cleaned)
                put("dateMs", dateMs)
            },
        )
        while (rows.length() > MAX) {
            rows.remove(0)
        }
        prefs.edit().putString(KEY, rows.toString()).apply()
        return id
    }

    fun pending(context: Context): List<Map<String, Any?>> {
        val rows = pendingRaw(prefs(context))
        val out = mutableListOf<Map<String, Any?>>()
        for (i in 0 until rows.length()) {
            val row = rows.optJSONObject(i) ?: continue
            out.add(
                hashMapOf(
                    "queueId" to row.optString("id"),
                    "sender" to row.optString("sender"),
                    "body" to row.optString("body"),
                    "dateMs" to row.optLong("dateMs"),
                ),
            )
        }
        return out
    }

    fun clear(context: Context) {
        prefs(context).edit().remove(KEY).apply()
    }

    fun remove(context: Context, ids: List<String>) {
        if (ids.isEmpty) return
        val wanted = ids.toSet()
        val prefs = prefs(context)
        val rows = pendingRaw(prefs)
        val kept = JSONArray()
        for (i in 0 until rows.length()) {
            val row = rows.optJSONObject(i) ?: continue
            if (!wanted.contains(row.optString("id"))) kept.put(row)
        }
        prefs.edit().putString(KEY, kept.toString()).apply()
    }

    private fun prefs(context: Context) =
        context.applicationContext.getSharedPreferences(PREFS, Context.MODE_PRIVATE)

    private fun pendingRaw(prefs: android.content.SharedPreferences): JSONArray {
        val raw = prefs.getString(KEY, null) ?: return JSONArray()
        return try {
            JSONArray(raw)
        } catch (_: Exception) {
            JSONArray()
        }
    }
}
