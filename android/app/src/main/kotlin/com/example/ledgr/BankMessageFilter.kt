package com.example.ledgr

object BankMessageFilter {
    private val placeholders = setOf("", "SHARE", "PASTE", "MESSAGES", "SMS")

    private val otp = Regex(
        "(otp|one[-\\s]?time(?:\\s+password|\\s+code)?|verification code|passcode|" +
            "رمز التحقق|رمز التأكيد|كلمة السر لمرة|رمز سري)",
        RegexOption.IGNORE_CASE,
    )

    private val txnVerb = Regex(
        "(debit(?:ed)?|credit(?:ed)?|purchased?|withdrawn|withdrawal|\\bpos\\b|" +
            "available\\s+balance|avl\\s+bal|" +
            "خصم|سحب|ايداع|إيداع|مشتريات|الرصيد)",
        RegexOption.IGNORE_CASE,
    )

    private val lightTxn = Regex(
        "(debit(?:ed)?|credit(?:ed)?|purchased?|withdrawn|withdrawal|" +
            "\\bpaid\\b|\\bpayment\\b|\\breceived\\b|\\bcharged\\b|\\bsent\\b|" +
            "خصم|سحب|ايداع|إيداع|تحويل|مدفوع|مشتريات)",
        RegexOption.IGNORE_CASE,
    )

    private val money = Regex(
        "(E£|EGP|USD|EUR|GBP|SAR|AED|\\bLE\\b|جنيه)",
        RegexOption.IGNORE_CASE,
    )

    private val arabicBankVerb = Regex(
        "(تم\\s+خصم|تم\\s+سحب|تم\\s+ايداع|تم\\s+إيداع|تم\\s+تحويل)",
    )

    private val cardOrAccount = Regex(
        "(card\\s+ending|acct|account|بطاقة|حساب|\\*{2,}\\d{3,4}|ending\\s+\\d{3,4})",
        RegexOption.IGNORE_CASE,
    )

    private val bankMarker = Regex(
        "(\\b(?:cib|nbe|qnb|bdc|aaib|adib|hdb|saib|hsbc|nbk|abk|ebe|idb)\\b|" +
            "\\b(?:instapay|ipn|fawry|telda|klivvr|halan|masary|meeza|aman)\\b|" +
            "banque\\s+misr|banque\\s+du\\s+caire|vodafone\\s+cash|vf[\\s-]?cash|" +
            "orange\\s+cash|etisalat\\s+cash|we\\s+pay|phone\\s*cash|" +
            "فودافون\\s*كاش|أورنج\\s*كاش|اورنج\\s*كاش|اتصالات\\s*كاش|" +
            "فون\\s*كاش|انستاباي|إنستاباي|فوري|تيلدا|هالان|ميزة)",
        RegexOption.IGNORE_CASE,
    )

    private val senderTokens = listOf(
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
    )

    fun accepts(sender: String, body: String): Boolean {
        val text = body.trim()
        if (text.isEmpty() || otp.containsMatchIn(text)) return false
        val normalizedSender = normalizeSender(sender)
        val known = !placeholders.contains(normalizedSender) && senderAllowed(normalizedSender)
        if (known) return bodyLooksLikeTransaction(text)
        return bodyLooksLikeBankOrWallet(text)
    }

    private fun bodyLooksLikeTransaction(text: String): Boolean {
        val hasMoney = money.containsMatchIn(text) || text.any { it.isDigit() }
        return hasMoney &&
            (txnVerb.containsMatchIn(text) ||
                lightTxn.containsMatchIn(text) ||
                arabicBankVerb.containsMatchIn(text))
    }

    private fun bodyLooksLikeBankOrWallet(text: String): Boolean {
        val hasMoney = money.containsMatchIn(text) || text.any { it.isDigit() }
        if (bankMarker.containsMatchIn(text) && hasMoney) return true
        if (cardOrAccount.containsMatchIn(text) &&
            txnVerb.containsMatchIn(text) &&
            money.containsMatchIn(text)
        ) {
            return true
        }
        if (arabicBankVerb.containsMatchIn(text) && money.containsMatchIn(text)) return true
        return false
    }

    private fun senderAllowed(normalized: String): Boolean {
        if (normalized.isEmpty()) return false
        return senderTokens.any { token -> senderTokenMatches(normalized, token) }
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
