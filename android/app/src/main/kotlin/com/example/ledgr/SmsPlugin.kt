package com.example.ledgr

import android.Manifest
import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Handler
import android.os.Looper
import android.provider.Telephony
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry

class SmsPlugin :
    FlutterPlugin,
    ActivityAware,
    MethodChannel.MethodCallHandler,
    PluginRegistry.RequestPermissionsResultListener,
    PluginRegistry.NewIntentListener {

    companion object {
        private const val METHOD = "ledgr/sms"
        private const val INCOMING = "ledgr/sms/incoming"
        private const val SHARE = "ledgr/sms/share"
        private const val PERMISSION_REQUEST = 4120

        @Volatile
        private var instance: SmsPlugin? = null

        fun register(engine: FlutterEngine) {
            if (engine.plugins.has(SmsPlugin::class.java)) return
            engine.plugins.add(SmsPlugin())
        }

        fun handleShareIntent(intent: Intent?) {
            instance?.onShareIntent(intent)
        }

        fun emitIncoming(sender: String, body: String, dateMs: Long, queueId: String) {
            instance?.emitIncomingSms(sender, body, dateMs, queueId)
        }

        fun onRequestPermissionsResult(requestCode: Int, grantResults: IntArray): Boolean {
            return instance?.onRequestPermissionsResult(requestCode, emptyArray(), grantResults)
                ?: false
        }
    }

    private var activity: Activity? = null
    private var appContext: android.content.Context? = null
    private var methodChannel: MethodChannel? = null
    private var incomingChannel: EventChannel? = null
    private var shareChannel: EventChannel? = null
    private var incomingSink: EventChannel.EventSink? = null
    private var shareSink: EventChannel.EventSink? = null
    private var permissionCallback: ((Boolean) -> Unit)? = null
    private var pendingShare: String? = null
    private val main = Handler(Looper.getMainLooper())

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        instance = this
        appContext = binding.applicationContext
        val messenger = binding.binaryMessenger

        methodChannel = MethodChannel(messenger, METHOD).also {
            it.setMethodCallHandler(this)
        }
        incomingChannel = EventChannel(messenger, INCOMING).also {
            it.setStreamHandler(
                object : EventChannel.StreamHandler {
                    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                        incomingSink = events
                    }

                    override fun onCancel(arguments: Any?) {
                        incomingSink = null
                    }
                },
            )
        }
        shareChannel = EventChannel(messenger, SHARE).also {
            it.setStreamHandler(
                object : EventChannel.StreamHandler {
                    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                        shareSink = events
                    }

                    override fun onCancel(arguments: Any?) {
                        shareSink = null
                    }
                },
            )
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel?.setMethodCallHandler(null)
        incomingChannel?.setStreamHandler(null)
        shareChannel?.setStreamHandler(null)
        methodChannel = null
        incomingChannel = null
        shareChannel = null
        incomingSink = null
        shareSink = null
        if (instance === this) instance = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addRequestPermissionsResultListener(this)
        binding.addOnNewIntentListener(this)
        onShareIntent(binding.activity.intent)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "hasPermission" -> result.success(hasSmsPermission())
            "requestPermission" -> requestSmsPermission { granted ->
                result.success(granted)
            }
            "readSince" -> {
                val sinceMs = call.argument<Number>("sinceMs")?.toLong()
                val senders = call.argument<List<String>>("senders") ?: emptyList()
                result.success(readSince(sinceMs, senders))
            }
            "acknowledge" -> {
                val ids = call.argument<List<String>>("ids") ?: emptyList()
                val ctx = appContext
                if (ctx != null) BankSmsQueue.remove(ctx, ids)
                result.success(true)
            }
            "clearPending" -> {
                val ctx = appContext
                if (ctx != null) BankSmsQueue.clear(ctx)
                result.success(true)
            }
            "takeInitialSharedText" -> {
                val text = pendingShare
                pendingShare = null
                result.success(text)
            }
            else -> result.notImplemented()
        }
    }

    override fun onNewIntent(intent: Intent): Boolean {
        onShareIntent(intent)
        return false
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
    ): Boolean {
        if (requestCode != PERMISSION_REQUEST) return false
        val granted = grantResults.isNotEmpty() &&
            grantResults.all { it == PackageManager.PERMISSION_GRANTED }
        permissionCallback?.invoke(granted)
        permissionCallback = null
        return true
    }

    private fun onShareIntent(intent: Intent?) {
        if (intent?.action != Intent.ACTION_SEND) return
        if (intent.type?.startsWith("text/") != true) return
        val text = intent.getStringExtra(Intent.EXTRA_TEXT) ?: return
        val sink = shareSink
        if (sink != null) {
            main.post { sink.success(text) }
        } else {
            pendingShare = text
        }
    }

    private fun emitIncomingSms(
        sender: String,
        body: String,
        dateMs: Long,
        queueId: String,
    ) {
        val sink = incomingSink ?: return
        main.post {
            sink.success(
                hashMapOf(
                    "queueId" to queueId,
                    "sender" to sender,
                    "body" to body,
                    "dateMs" to dateMs,
                ),
            )
        }
    }

    private fun readSince(sinceMs: Long?, senders: List<String>): List<Map<String, Any?>> {
        val ctx = appContext
        val queued = if (ctx != null) BankSmsQueue.pending(ctx) else emptyList()
        val inbox = readInbox(sinceMs, senders)
        return queued + inbox
    }

    private fun hasSmsPermission(): Boolean {
        val current = activity ?: return false
        val read = ContextCompat.checkSelfPermission(current, Manifest.permission.READ_SMS)
        val receive = ContextCompat.checkSelfPermission(current, Manifest.permission.RECEIVE_SMS)
        return read == PackageManager.PERMISSION_GRANTED &&
            receive == PackageManager.PERMISSION_GRANTED
    }

    private fun requestSmsPermission(callback: (Boolean) -> Unit) {
        val current = activity
        if (current == null) {
            callback(false)
            return
        }
        if (hasSmsPermission()) {
            callback(true)
            return
        }
        permissionCallback = callback
        ActivityCompat.requestPermissions(
            current,
            arrayOf(Manifest.permission.READ_SMS, Manifest.permission.RECEIVE_SMS),
            PERMISSION_REQUEST,
        )
    }

    private fun readInbox(sinceMs: Long?, senders: List<String>): List<Map<String, Any?>> {
        val current = activity ?: return emptyList()
        if (!hasSmsPermission()) return emptyList()
        val normalizedSenders = senders.map { normalizeSender(it) }.filter { it.isNotEmpty() }
        val rows = mutableListOf<Map<String, Any?>>()
        val pageSize = 200
        var cursorDate: Long? = null
        var cursorId: Long? = null
        while (true) {
            val parts = mutableListOf<String>()
            val args = mutableListOf<String>()
            if (sinceMs != null) {
                parts.add("${Telephony.Sms.DATE} > ?")
                args.add(sinceMs.toString())
            }
            if (cursorDate != null && cursorId != null) {
                parts.add(
                    "(${Telephony.Sms.DATE} < ? OR (${Telephony.Sms.DATE} = ? AND ${Telephony.Sms._ID} < ?))",
                )
                args.add(cursorDate.toString())
                args.add(cursorDate.toString())
                args.add(cursorId.toString())
            }
            val page = current.contentResolver.query(
                Telephony.Sms.Inbox.CONTENT_URI,
                arrayOf(
                    Telephony.Sms._ID,
                    Telephony.Sms.ADDRESS,
                    Telephony.Sms.BODY,
                    Telephony.Sms.DATE,
                ),
                if (parts.isEmpty()) null else parts.joinToString(" AND "),
                if (args.isEmpty()) null else args.toTypedArray(),
                "${Telephony.Sms.DATE} DESC, ${Telephony.Sms._ID} DESC",
            ) ?: break

            var pageCount = 0
            var lastDate: Long? = null
            var lastId: Long? = null
            page.use {
                val idIdx = it.getColumnIndex(Telephony.Sms._ID)
                val addressIdx = it.getColumnIndex(Telephony.Sms.ADDRESS)
                val bodyIdx = it.getColumnIndex(Telephony.Sms.BODY)
                val dateIdx = it.getColumnIndex(Telephony.Sms.DATE)
                while (it.moveToNext() && pageCount < pageSize) {
                    pageCount++
                    val id = if (idIdx >= 0) it.getLong(idIdx) else 0L
                    val dateMs = if (dateIdx >= 0) it.getLong(dateIdx) else 0L
                    lastDate = dateMs
                    lastId = id
                    val address = if (addressIdx >= 0) it.getString(addressIdx) ?: "" else ""
                    if (normalizedSenders.isNotEmpty() &&
                        !senderAllowed(address, normalizedSenders)
                    ) {
                        continue
                    }
                    rows.add(
                        hashMapOf(
                            "id" to id,
                            "sender" to address,
                            "body" to if (bodyIdx >= 0) it.getString(bodyIdx) ?: "" else "",
                            "dateMs" to dateMs,
                        ),
                    )
                }
            }
            if (pageCount == 0 || pageCount < pageSize) break
            if (lastDate == null || lastId == null) break
            if (cursorDate == lastDate && cursorId == lastId) break
            cursorDate = lastDate
            cursorId = lastId
        }
        return rows.reversed()
    }

    private fun senderAllowed(address: String, senders: List<String>): Boolean {
        val normalized = normalizeSender(address)
        if (normalized.isEmpty()) return false
        return senders.any { token -> senderTokenMatches(normalized, token) }
    }

    private fun senderTokenMatches(normalized: String, token: String): Boolean {
        if (normalized == token) return true
        if (token.length >= 4 && normalized.contains(token)) return true
        if (normalized.length >= 4 && token.contains(normalized)) return true
        return false
    }

    private fun normalizeSender(value: String): String {
        return value.uppercase().replace(Regex("[\\s\\-_.]"), "")
    }
}
