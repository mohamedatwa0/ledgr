import UIKit

@objc(ShareViewController)
class ShareViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    Task { await importSharedText() }
  }

  private func importSharedText() async {
    let text = await loadText()
    let body = text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    guard BankSmsQueue.accepts(sender: "", body: body) else {
      presentRejected()
      return
    }
    let date = Date()
    if BankSmsQueue.canShareWithHost {
      BankSmsQueue.enqueue(sender: "", body: body, date: date)
      openHost(URL(string: "ledgr://sms-import"))
    } else if let url = BankSmsQueue.importURL(sender: "", body: body, date: date) {
      openHost(url)
    } else {
      extensionContext?.completeRequest(returningItems: nil)
    }
  }

  private func loadText() async -> String? {
    guard let items = extensionContext?.inputItems as? [NSExtensionItem] else {
      return nil
    }
    let types = ["public.plain-text", "public.utf8-plain-text", "public.text"]
    for item in items {
      if let text = item.attributedContentText?.string, !text.isEmpty {
        return text
      }
      for provider in item.attachments ?? [] {
        for type in types where provider.hasItemConformingToTypeIdentifier(type) {
          if let loaded = try? await provider.loadItem(forTypeIdentifier: type) {
            if let string = loaded as? String, !string.isEmpty { return string }
            if let data = loaded as? Data,
               let string = String(data: data, encoding: .utf8),
               !string.isEmpty {
              return string
            }
          }
        }
      }
    }
    return nil
  }

  private func presentRejected() {
    let arabic = (Locale.preferredLanguages.first ?? "").hasPrefix("ar")
    let alert = UIAlertController(
      title: arabic ? "رسائل البنك والمحفظة فقط" : "Bank and wallet messages only",
      message: arabic
        ? "Ledgr يستورد رسائل البنك والمحفظة الذكية فقط."
        : "Ledgr only imports bank and smart wallet messages.",
      preferredStyle: .alert
    )
    alert.addAction(UIAlertAction(title: arabic ? "حسناً" : "OK", style: .default) { _ in
      self.extensionContext?.cancelRequest(withError: NSError(domain: "ledgr", code: 0))
    })
    present(alert, animated: true)
  }

  private func openHost(_ url: URL?) {
    guard let url else {
      extensionContext?.completeRequest(returningItems: nil)
      return
    }
    let finish = {
      self.extensionContext?.completeRequest(returningItems: nil)
    }
    if #available(iOS 18.0, *) {
      extensionContext?.open(url) { _ in finish() }
      return
    }
    var responder: UIResponder? = self
    let selector = sel_registerName("openURL:")
    while let current = responder {
      if current.responds(to: selector) {
        _ = current.perform(selector, with: url)
        break
      }
      responder = current.next
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
      finish()
    }
  }
}
