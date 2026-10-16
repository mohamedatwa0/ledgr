import Flutter
import UIKit

/// Receives bank and wallet texts shared from Messages or Shortcuts.
final class SmsPlugin: NSObject, FlutterPlugin {
  static let shared = SmsPlugin()

  private let incoming = SmsStream()
  private let share = SmsStream()
  private let main = DispatchQueue.main

  static func register(with registrar: FlutterPluginRegistrar) {
    let plugin = SmsPlugin.shared
    let channel = FlutterMethodChannel(
      name: "ledgr/sms",
      binaryMessenger: registrar.messenger()
    )
    registrar.addMethodCallDelegate(plugin, channel: channel)
    FlutterEventChannel(
      name: "ledgr/sms/incoming",
      binaryMessenger: registrar.messenger()
    ).setStreamHandler(plugin.incoming)
    FlutterEventChannel(
      name: "ledgr/sms/share",
      binaryMessenger: registrar.messenger()
    ).setStreamHandler(plugin.share)
  }

  static func handle(url: URL) {
    guard url.scheme?.lowercased() == "ledgr" else { return }
    if url.host?.lowercased() == "sms" {
      let items = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems ?? []
      let body = items.first { $0.name == "body" }?.value ?? ""
      let sender = items.first { $0.name == "sender" }?.value ?? ""
      let dateMs = Int64(items.first { $0.name == "dateMs" }?.value ?? "")
        ?? Int64(Date().timeIntervalSince1970 * 1000)
      let date = Date(timeIntervalSince1970: TimeInterval(dateMs) / 1000)
      BankSmsQueue.enqueue(sender: sender, body: body, date: date)
    }
    shared.emitScanSignal()
  }

  static func notifyImport() {
    shared.emitScanSignal()
  }

  func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "hasPermission":
      result(BankSmsQueue.isEnabled())
    case "requestPermission":
      BankSmsQueue.setEnabled(true)
      result(true)
    case "readSince":
      let rows: [[String: Any]] = BankSmsQueue.pending().map { item in
        [
          "queueId": item.id,
          "sender": item.sender,
          "body": item.body,
          "dateMs": item.dateMs,
        ]
      }
      result(rows)
    case "acknowledge":
      let args = call.arguments as? [String: Any]
      let ids = args?["ids"] as? [String] ?? []
      BankSmsQueue.remove(ids: ids)
      result(true)
    case "takeInitialSharedText":
      result(BankSmsQueue.consumeOpenInbox() ? BankSmsQueue.scanSignal : nil)
    case "openImportSetup":
      openShortcuts(result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func emitScanSignal() {
    main.async { [weak self] in
      self?.share.sink?(BankSmsQueue.scanSignal)
    }
  }

  private func openShortcuts(result: @escaping FlutterResult) {
    guard let url = URL(string: "shortcuts://") else {
      result(false)
      return
    }
    main.async {
      UIApplication.shared.open(url, options: [:]) { opened in
        result(opened)
      }
    }
  }
}

private final class SmsStream: NSObject, FlutterStreamHandler {
  var sink: FlutterEventSink?

  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    sink = events
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    sink = nil
    return nil
  }
}
