import Foundation

/// On-device queue shared by the app and the Messages share extension.
/// Keep the accept rules aligned with `lib/domain/sms/bank_message_filter.dart`.
enum BankSmsQueue {
  static let appGroup = "group.com.example.ledgr"
  static let scanSignal = "__ledgr_scan__"

  private static let queueKey = "pendingSms"
  private static let enabledKey = "importEnabled"
  private static let openInboxKey = "openInbox"
  private static let lock = NSLock()

  struct Item {
    var id: String
    var sender: String
    var body: String
    var dateMs: Int64
  }

  static var canShareWithHost: Bool {
    sharedDefaults != nil
  }

  static func isEnabled() -> Bool {
    defaults().bool(forKey: enabledKey)
  }

  static func setEnabled(_ enabled: Bool) {
    defaults().set(enabled, forKey: enabledKey)
  }

  static func markOpenInbox() {
    defaults().set(true, forKey: openInboxKey)
  }

  static func consumeOpenInbox() -> Bool {
    let store = defaults()
    let open = store.bool(forKey: openInboxKey)
    if open {
      store.set(false, forKey: openInboxKey)
    }
    return open
  }

  @discardableResult
  static func enqueue(sender: String, body: String, date: Date) -> Bool {
    let cleaned = body.trimmingCharacters(in: .whitespacesAndNewlines)
    guard accepts(sender: sender, body: cleaned) else { return false }
    lock.lock()
    defer { lock.unlock() }
    let store = defaults()
    var rows = store.array(forKey: queueKey) as? [[String: Any]] ?? []
    let normalized = normalize(cleaned)
    let already = rows.contains { row in
      normalize((row["body"] as? String) ?? "") == normalized &&
        normalizeSender((row["sender"] as? String) ?? "") == normalizeSender(sender)
    }
    if !already {
      rows.append([
        "id": UUID().uuidString,
        "sender": sender,
        "body": cleaned,
        "dateMs": Int64(date.timeIntervalSince1970 * 1000),
      ])
      if rows.count > 300 {
        rows.removeFirst(rows.count - 300)
      }
      store.set(rows, forKey: queueKey)
    }
    store.set(true, forKey: enabledKey)
    store.set(true, forKey: openInboxKey)
    return true
  }

  static func pending() -> [Item] {
    lock.lock()
    defer { lock.unlock() }
    let rows = defaults().array(forKey: queueKey) as? [[String: Any]] ?? []
    return rows.compactMap { row in
      guard let id = row["id"] as? String,
            let body = row["body"] as? String else { return nil }
      let sender = row["sender"] as? String ?? ""
      let dateMs = (row["dateMs"] as? NSNumber)?.int64Value ?? 0
      return Item(id: id, sender: sender, body: body, dateMs: dateMs)
    }
  }

  static func remove(ids: [String]) {
    guard !ids.isEmpty else { return }
    lock.lock()
    defer { lock.unlock() }
    let drop = Set(ids)
    let store = defaults()
    let rows = store.array(forKey: queueKey) as? [[String: Any]] ?? []
    let kept = rows.filter { row in
      guard let id = row["id"] as? String else { return false }
      return !drop.contains(id)
    }
    store.set(kept, forKey: queueKey)
  }

  static func importURL(sender: String, body: String, date: Date) -> URL? {
    var components = URLComponents()
    components.scheme = "ledgr"
    components.host = "sms"
    components.queryItems = [
      URLQueryItem(name: "sender", value: sender),
      URLQueryItem(name: "body", value: body),
      URLQueryItem(
        name: "dateMs",
        value: String(Int64(date.timeIntervalSince1970 * 1000))
      ),
    ]
    return components.url
  }

  static func clear() {
    lock.lock()
    defer { lock.unlock() }
    defaults().removeObject(forKey: queueKey)
  }

  static func accepts(sender: String, body: String) -> Bool {
    let text = normalize(body)
    if text.isEmpty || looksLikeOtp(text) { return false }
    let normalizedSender = normalizeSender(sender)
    let known = !placeholderSenders.contains(normalizedSender) &&
      senderAllowed(normalizedSender)
    if known { return bodyLooksLikeTransaction(text) }
    return bodyLooksLikeBankOrWallet(text)
  }

  private static var sharedDefaults: UserDefaults? {
    guard FileManager.default.containerURL(
      forSecurityApplicationGroupIdentifier: appGroup
    ) != nil else {
      return nil
    }
    return UserDefaults(suiteName: appGroup)
  }

  private static func defaults() -> UserDefaults {
    sharedDefaults ?? .standard
  }

  private static let placeholderSenders: Set<String> = [
    "", "SHARE", "PASTE", "MESSAGES", "SMS",
  ]

  private static let senderTokens: [String] = [
    "CIB", "CIBEGY", "NBE", "BANQUENBE", "BM", "BANQUEMISR", "QNB", "QNBALA",
    "BDC", "BANQUEDUCAIRE", "INSTAPAY", "IPN",
    "VODAFONECASH", "VFCASH", "VFCSH", "ORANGECASH", "ETISALATCASH", "ECASH",
    "EMONEY", "WEPAY", "PHONECASH", "NBEPHONECASH", "BMWALLET", "SMARTWALLET",
    "CAIRECASH", "FAWRY", "TELDA", "KLIVVR", "HALAN", "MNTHALAN", "MASARY",
    "AMAN", "MEEZA", "AAIB", "ADIB", "FABMISR", "FABEGY", "ALEXBANK", "HDB",
    "EBANK", "EBE", "IDBE", "MIDBANK", "ABK", "ABKEGYPT", "NBK", "ENBD", "SAIB",
    "HSBC", "CITI", "CITIBANK", "ARABANK", "STANCHART", "BANKNXT", "ATTIJARI",
    "ATTIJARIWAFA", "FAISAL", "FAISALBANK", "ALBARAKA", "BARAKA", "SUEZCANAL",
    "UNITEDBANK", "AGBANK", "EALB",
    "فودافونكاش", "أورنجكاش", "اورنجكاش", "اتصالاتكاش", "ويباي", "فونكاش",
    "فوري", "تيلدا", "ميزة",
  ]

  private static func senderAllowed(_ sender: String) -> Bool {
    if sender.isEmpty { return false }
    return senderTokens.contains { token in
      sender.contains(token) || token.contains(sender)
    }
  }

  private static let lightTxnPattern =
    "(debit(?:ed)?|credit(?:ed)?|purchased?|withdrawn|withdrawal|" +
    "\\bpaid\\b|\\bpayment\\b|\\breceived\\b|\\bcharged\\b|\\bsent\\b|" +
    "خصم|سحب|ايداع|إيداع|تحويل|مدفوع|مشتريات)"

  private static func bodyLooksLikeTransaction(_ text: String) -> Bool {
    let hasMoney = matches(moneyPattern, text) || text.rangeOfCharacter(from: .decimalDigits) != nil
    return hasMoney &&
      (matches(verbPattern, text) ||
        matches(lightTxnPattern, text) ||
        matches(arabicVerbPattern, text))
  }

  private static func bodyLooksLikeBankOrWallet(_ text: String) -> Bool {
    let hasMoney = matches(moneyPattern, text) || text.rangeOfCharacter(from: .decimalDigits) != nil
    if matches(markerPattern, text) && hasMoney { return true }
    if matches(cardPattern, text) && matches(verbPattern, text) && matches(moneyPattern, text) {
      return true
    }
    if matches(arabicVerbPattern, text) && matches(moneyPattern, text) { return true }
    return false
  }

  private static let markerPattern =
    "(\\b(?:cib|nbe|qnb|bdc|aaib|adib|hdb|saib|hsbc|nbk|abk|ebe|idb)\\b|" +
    "\\b(?:instapay|ipn|fawry|telda|klivvr|halan|masary|meeza|aman)\\b|" +
    "\\b(?:alexbank|fabmisr|midbank|enbd|ebank|bank\\s+nxt|attijari)\\b|" +
    "\\b(?:citibank|citi|arab\\s+bank|standard\\s+chartered|stanchart)\\b|" +
    "banque\\s+misr|banque\\s+du\\s+caire|bank\\s+misr|" +
    "national\\s+bank\\s+of\\s+egypt|banque\\s+alexandria|" +
    "vodafone\\s+cash|vf[\\s-]?cash|orange\\s+cash|etisalat\\s+cash|" +
    "we\\s+pay|phone\\s*cash|bm\\s+wallet|smart\\s+wallet|cairo\\s+cash|" +
    "mnt[-\\s]?halan|faisal\\s+islamic|al\\s*baraka|suez\\s+canal|" +
    "agricultural\\s+bank|united\\s+bank|export\\s+development|" +
    "بنك\\s*مصر|البنك\\s*الأهلي|بنك\\s*القاهرة|الأهلي\\s*المصري|" +
    "البنك\\s*العقاري|البنك\\s*الزراعي|التنمية\\s*الصناعية|المصرف\\s*المتحد|" +
    "التجاري\\s*الدولي|أبوظبي\\s*الإسلامي|ابوظبي\\s*الاسلامي|" +
    "أبوظبي\\s*الأول|ابوظبي\\s*الاول|بنك\\s*الإسكندرية|بنك\\s*الاسكندرية|" +
    "التعمير\\s*والإسكان|التعمير\\s*والاسكان|فيصل\\s*الإسلامي|فيصل\\s*الاسلامي|" +
    "تنمية\\s*الصادرات|بنك\\s*البركة|قناة\\s*السويس|بنك\\s*نكست|بنك\\s*ميد|" +
    "الأهلي\\s*الكويتي|الاهلي\\s*الكويتي|الكويت\\s*الوطني|الإمارات\\s*دبي|" +
    "الامارات\\s*دبي|التجاري\\s*وفا|" +
    "فودافون\\s*كاش|أورنج\\s*كاش|اورنج\\s*كاش|اتصالات\\s*كاش|وي\\s*باي|" +
    "فون\\s*كاش|كاش\\s*القاهرة|المحفظة\\s*الذكية|انستاباي|إنستاباي|" +
    "فوري|تيلدا|هالان|مصاري|ميزة)"

  private static let cardPattern =
    "(card\\s+ending|acct|account|بطاقة|حساب|\\*{2,}\\d{3,4}|ending\\s+\\d{3,4})"

  private static let verbPattern =
    "(debit(?:ed)?|credit(?:ed)?|purchased?|withdrawn|withdrawal|\\bpos\\b|" +
    "available\\s+balance|avl\\s+bal|" +
    "خصم|سحب|ايداع|إيداع|مشتريات|الرصيد)"

  private static let moneyPattern = "(E£|EGP|USD|EUR|GBP|SAR|AED|\\bLE\\b|جنيه)"

  private static let arabicVerbPattern =
    "(تم\\s+خصم|تم\\s+سحب|تم\\s+ايداع|تم\\s+إيداع|تم\\s+تحويل)"

  private static let otpPattern =
    "(otp|one[-\\s]?time(?:\\s+password|\\s+code)?|verification code|passcode|" +
    "رمز التحقق|رمز التأكيد|كلمة السر لمرة|رمز سري)"

  private static func looksLikeOtp(_ text: String) -> Bool {
    matches(otpPattern, text)
  }

  private static func matches(_ pattern: String, _ text: String) -> Bool {
    text.range(of: pattern, options: [.regularExpression, .caseInsensitive]) != nil
  }

  private static func normalize(_ input: String) -> String {
    var text = easternToWestern(input)
    text = text.replacingOccurrences(of: "\u{00a0}", with: " ")
    text = text.replacingOccurrences(of: "\u{066c}", with: ",")
    text = text.replacingOccurrences(of: "\u{066b}", with: ".")
    text = text.replacingOccurrences(of: "\u{060c}", with: ",")
    text = text.replacingOccurrences(of: "\r\n", with: "\n")
    text = text.replacingOccurrences(
      of: "[ \\t]+",
      with: " ",
      options: .regularExpression
    )
    return text.trimmingCharacters(in: .whitespacesAndNewlines)
  }

  private static func normalizeSender(_ sender: String) -> String {
    normalize(sender)
      .uppercased()
      .replacingOccurrences(of: "[\\s\\-_.]+", with: "", options: .regularExpression)
  }

  private static func easternToWestern(_ input: String) -> String {
    let map: [Character: Character] = [
      "٠": "0", "١": "1", "٢": "2", "٣": "3", "٤": "4",
      "٥": "5", "٦": "6", "٧": "7", "٨": "8", "٩": "9",
      "۰": "0", "۱": "1", "۲": "2", "۳": "3", "۴": "4",
      "۵": "5", "۶": "6", "۷": "7", "۸": "8", "۹": "9",
    ]
    return String(input.map { map[$0] ?? $0 })
  }
}
