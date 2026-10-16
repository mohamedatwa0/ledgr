import AppIntents
import Foundation

@available(iOS 16.0, *)
struct ImportBankMessageIntent: AppIntent {
  static var title: LocalizedStringResource = "Import Bank Message"
  static var description = IntentDescription(
    "Adds a bank or smart wallet text to Ledgr for review. Other messages are ignored."
  )
  static var openAppWhenRun = true

  @Parameter(title: "Message")
  var message: String

  @Parameter(title: "Sender", default: "")
  var sender: String

  static var parameterSummary: some ParameterSummary {
    Summary("Import \(\.$message)")
  }

  func perform() async throws -> some IntentResult {
    if BankSmsQueue.enqueue(sender: sender, body: message, date: Date()) {
      SmsPlugin.notifyImport()
    }
    return .result()
  }
}

@available(iOS 16.0, *)
struct LedgrShortcuts: AppShortcutsProvider {
  static var appShortcuts: [AppShortcut] {
    AppShortcut(
      intent: ImportBankMessageIntent(),
      phrases: [
        "Import a bank message in \(.applicationName)",
        "Add a wallet message to \(.applicationName)",
      ],
      shortTitle: "Import Bank Message",
      systemImageName: "message"
    )
  }
}
