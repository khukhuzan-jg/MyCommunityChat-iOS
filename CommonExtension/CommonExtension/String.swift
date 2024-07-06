import UIKit
import CommonCrypto

public enum DateFormat: String {
    
    /** yyyy-MM-dd'T'HH:mm:ss'Z' */
    case type1 = "yyyy-MM-dd'T'HH:mm:ssZ"
    
    /** d-MM-yyyy HH:mm:ss */
    case type2 = "d-MM-yyyy HH:mm:ss"
    
    /** dd MMM yyyy */
    case type3 = "dd MMM yyyy"
    
    /** yyyy-MM-dd HH:mm:ss.SSS zzzxxx */
    case type4 = "yyyy-MM-dd HH:mm:ss.SSS zzzxxx"
    
    /** dd MMM yyyy, HH:mm */
    case type5 = "dd MMM yyyy, h:mm a"
    
    /** ddMMyyyyhhmmss */
    case type6 = "ddMMyyyyhhmmss"
    
    /** E d MMM yyyy, HH:mm */
    case type7 = "E d MMM yyyy, HH:mm"
    
    /** d MMM yyyy, HH:mm */
    case type8 = "d MMM yyyy, HH:mm"
    
    /** dd/MM/yy */
    case type9 = "dd/MM/yy"
    
    /** y-MM-dd */
    case type10 = "y-MM-dd"
    
    /** dd/MM/yyyy */
    case type11 = "dd/MM/yyyy"
    
    /** yyyy-MM-dd HH:mm:ss */
    case type12 = "yyyy-MM-dd HH:mm:ss"
    
    /** dd MMM yyyy - hh:mm:ss a */
    case type13 = "dd MMM yyyy - hh:mm:ss a"
    
    /** MM/yy */
    case type14 = "MM/yy"
    
    /** dd MMM yyyy - hh:mm:ss */
    case type15 = "dd MMM yyyy - hh:mm:ss"
    
    /** MMM dd yyyy HH:mm:ss */
    case type16 = "MMM dd yyyy HH:mm:ss"
    
    /** hh:mma */
    case type17 = "hh:mm a"
    
    /** yyyy-MM-dd'T'HH:mm:ss'Z' */
    case type18 = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    
    /** yyyy-MM-dd'T'HH:mm:ss'Z' */
    case type19 = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    
    case type20 = "d MMMM"
    
    case type21 = "E, dd MMM"
    
    case type22 = "h.mm a"
    
    case type23 = "H:mm"
    
    case type24 = "MMM yyyy"
    
    case type25 = "yyyy-MM-dd"
    
    case type26 = "HH:mm:ss"
    
    case type27 = "h:mm a"
    
    case type28 = "dd MMMM yyyy"
    
    case type29 = "EEEE, d MMM"
    
    case type30 = "MMM d, yyyy"
    
    /** dd MMM yyyy • hh:mm a */
    case type31 = "dd MMM yyyy • hh:mm a"
    
    case type32 = "h"
    
    case type33 = "m"
    
    case type34 = "d MMM"
    
    case type35 = "yyMMdd'T'HHmmss"
    
    case type36 = "MM/dd/yyyy HH:mm:ss"
    
    case type37 = "E, d MMM yyyy"
    
}

public extension String {
    
    var binary: Data? {
        data(using: .utf8)
    }
    
    static var empty = ""
    
    func strikeThrough() -> NSAttributedString {
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
    
    func changeSubStringFont(subStr: String, font: UIFont, color: UIColor) -> NSMutableAttributedString {
        let range = (self as NSString).range(of: subStr)
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(NSAttributedString.Key.font, value: font, range: range)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        return attributedString
    }
    
    var removedSpace: String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    var removedDot: String {
        return self.replacingOccurrences(of: ".", with: "")
    }
    
    var url: URL? {
        return URL(string: self)
    }
    
    var toInt: Int? {
        return Int(self)
    }
    
    var toDouble: Double? {
        return Double(self)
    }
    
    // https://stackoverflow.com/a/34423577/3378606
    func height(for width: CGFloat, font: UIFont) -> CGFloat {
        let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let actualSize = self.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font: font], context: nil)
        return actualSize.height
    }
    
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = from16.samePosition(in: self),
            let to = to16.samePosition(in: self)
        else { return nil }
        return from ..< to
    }
    
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
    
    func toIntFlag() -> Int? {
        switch self {
        case "True", "true", "yes", "1":
            return 1
        case "False", "false", "no", "0":
            return 0
        default:
            return nil
        }
    }
    
    func substring(from: Int?, to: Int?) -> String {
        if let start = from {
            guard start < self.count else {
                return ""
            }
        }
        
        if let end = to {
            guard end >= 0 else {
                return ""
            }
        }
        
        if let start = from, let end = to {
            guard end - start >= 0 else {
                return ""
            }
        }
        
        let startIndex: String.Index
        if let start = from, start >= 0 {
            startIndex = self.index(self.startIndex, offsetBy: start)
        } else {
            startIndex = self.startIndex
        }
        
        let endIndex: String.Index
        if let end = to, end >= 0, end < self.count {
            endIndex = self.index(self.startIndex, offsetBy: end + 1)
        } else {
            endIndex = self.endIndex
        }
        
        return String(self[startIndex ..< endIndex])
    }
    
    func repeated(_ count: Int) -> [String] {
        var res: [String] = []
        for _ in 0..<count {
            res.append(self)
        }
        return res
    }
    
    func contains(_ value: [String]) -> Bool {
        var contains: Bool = false
        for value in value {
            if self.contains(value) {
                contains = true
                break
            }
        }
        return contains
    }
    
    // Helpers
    // Convert from 14:00(YGN) to 7:30(UTC)
    func convertToUTCTimestamp() -> String? {
        let strArr: [String] = self.components(separatedBy: ":")
        guard strArr.count > 1 else {
            return nil
        }
        
        let int0 = Int(strArr[0])
        let int1 = Int(strArr[1])
        let calendar = Calendar.current
        let today = Date()
        
        let com = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: today)
        
        var newcom = DateComponents()
        newcom.year = com.year
        newcom.month = com.month
        newcom.day = com.day
        newcom.hour = int0
        newcom.minute = int1
        let newcomdate = calendar.date(from: newcom)!
        
        let finalf = DateFormatter()
        finalf.dateFormat = "HH:mm"
        finalf.timeZone = TimeZone(abbreviation: "UTC")
        let finalfString = finalf.string(from: newcomdate)
        return finalfString
    }
    
    // Convert from 7:30(UTC) to 14:00(YGN)
    func convertFromUTCTimestamp() -> String? {
        let strArr: [String] = self.components(separatedBy: ":")
        guard strArr.count > 1 else {
            return nil
        }
        
        let int0 = Int(strArr[0])
        let int1 = Int(strArr[1])
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")!
        
        let today = Date()
        let com = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: today)
        
        var newcom = DateComponents()
        newcom.year = com.year
        newcom.month = com.month
        newcom.day = com.day
        newcom.hour = int0
        newcom.minute = int1
        let newcomdate = calendar.date(from: newcom)!
        
        let finalf = DateFormatter()
        finalf.dateFormat = "HH:mm"
        return finalf.string(from: newcomdate)
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func toDate(format: DateFormat, useBaseLang: Bool = false) -> Date? {
        let dateFormatter = DateFormatter()
        if useBaseLang {
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        }
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.date(from: self)
    }
    
    func utcToLocal(format: DateFormat) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        if let date = dateFormatter.date(from: self) {
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = format.rawValue
            
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    func changeTimeFormat(format: DateFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "HH:mm:ss"
        if let date = dateFormatter.date(from: self){
            let dateStr = date.toStringWith(format)
            return dateStr.lowercased()
        } else {
            return ""
        }
    }
    
    var formattedDob: String? {
        return components(separatedBy: "/").reversed().joined(separator: "-")
    }
    
    func removeWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
    
    func removeFirst() -> String? {
        return self.substring(from: 1, to: self.count)
    }
    
    func removeSuffix(_ string: String) -> String {
        if self.hasSuffix(string) {
            return String(self.dropLast(string.count))
        }
        return self
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        if emailTest.evaluate(with: self) {
            return true
        }
        return false
    }
    
    func isValidPhoneNumber() -> Bool {
        let phoneNumberPattern = "^\\d{10,10}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneNumberPattern)
        return phoneTest.evaluate(with: self)
    }
    
    func isValidTaxiNumber() -> Bool {
        
        // TST0728L
        // TST9993C
        // TST8888A
        
        let taxiNumberRegEx = "([A-Z]{2,3})([0-9]{1,4})([A-Z]{1})"
        let taxiNumberTest = NSPredicate(format: "SELF MATCHES %@", taxiNumberRegEx)
        if taxiNumberTest.evaluate(with: self) {
            return true
        }
        return false
    }
    
    func isImageURL() -> Bool {
        let imageFormats = ["jpg", "png", "gif", "jpeg"]
        
        if URL(string: self) != nil {
            let extensi = (self as NSString).pathExtension
            return imageFormats.contains(extensi)
        }
        return false
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    func toAttributedHTML(font: UIFont, color: UIColor, minimumFontSize: CGFloat = 16) -> NSAttributedString? {
        try? NSAttributedString(
            htmlString: self,
            font: font,
            color: color,
            useDocumentFontSize: false,
            minimumFontSize: minimumFontSize
        )
    }
    
    /**
     Getting Last 4
     */
    func last(_ k: Int) -> String {
        let maxCount = self.count
        if maxCount >= k {
            return self.substring(from: maxCount - k, to: maxCount)
        } else {
            return ""
        }
    }
    
    /// if the string is "" return nil, otherwise actual value is returned
    var valueOrNil: String? {
        return self.removeWhitespaces() == "" ? nil : self
    }
    
    /*func md5() -> String {
     let messageData = self.data(using: .utf8)!
     var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
     
     _ = digestData.withUnsafeMutableBytes {digestBytes in
     messageData.withUnsafeBytes {messageBytes in
     CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
     }
     }
     
     return digestData.map { String(format: "%02hhx", $0) }.joined()
     } */
    
    func toDate(dateFormat: String, withoutTimeZone: Bool = false) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        if withoutTimeZone { formatter.timeZone = TimeZone(secondsFromGMT: 0) }
        return formatter.date(from: self)
    }
    
    //  convert "MM/dd/yyyy HH:mm:ss" to "yyyy-MM-dd HH:mm:ss"
    func toDate(from dateFromatFrom: String, to dateFormatTo: String) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = dateFromatFrom
        if let date = formatter.date(from: self) {
            formatter.dateFormat = dateFormatTo
            let dateString = formatter.string(from: date)
            return formatter.date(from: dateString)
        }
        return nil
    }
    
    //    func formatDate(from: String, to: String, withTimeZone: Bool = false) -> String? {
    //        let date = self.toDate(dateFormat: from, withoutTimeZone: !withTimeZone)
    //        return date?.toString(to, setLocalTimeZone: withTimeZone)
    //    }
    
    func add(character: String, byOffset offset: Int) -> String {
        
        var newString = ""
        
        for (index, char) in self.enumerated() {
            
            if index % offset == 0 && index != 0 {
                newString += "\(character)"
            }
            newString += "\(char)"
        }
        return newString
    }
    
    func removeAllSpaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
    
    func separate(every stride: Int = 4, with separator: Character = " ") -> String {
        return String(enumerated().map { $0 > 0 && $0 % stride == 0 ? [separator, $1] : [$1]}.joined())
    }
    
    func appendedFirst(_ value: String) -> String {
        value + self
    }
    
    func removed(_ value: String) -> String {
        replacingOccurrences(of: value, with: "")
    }
    
    var isNumberWithDecimal: Bool {  return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil }
    
    var isNumber: Bool { return Int(self) != nil }
    
    var isSingleEmoji: Bool { count == 1 && containsEmoji }
    
    var containsEmoji: Bool { contains { $0.isEmoji } }
    
    var containsOnlyEmoji: Bool { !isEmpty && !contains { !$0.isEmoji } }
    
    var emojiString: String { emojis.map { String($0) }.reduce("", +) }
    
    var emojis: [Character] { filter { $0.isEmoji } }
    
    var emojiScalars: [UnicodeScalar] { filter { $0.isEmoji }.flatMap { $0.unicodeScalars } }
    
    func chunkFormatted(
        withChunkSize chunkSize: Int = 4,
        withSeparator separator: Character = " "
    ) -> String {
        let newStr = filter { $0 != separator }
            .chunk(n: chunkSize)
            .map{ String($0) }
            .joined(separator: String(separator))
        return newStr
    }
    
    func getTimeStringFormat() -> String{
        let dateAsString = self
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "HH:mm:ss"
        
        let date = dateFormatter.date(from: dateAsString)
        dateFormatter.dateFormat = "h:mm a"
        let dateStr = dateFormatter.string(from: date!)
        return dateStr
    }
    
    func getFormattedDate(format: DateFormat) ->String {
        let dateAsString = self
        let splitStringArray = dateAsString.split(separator: "T", maxSplits: 1).map(String.init)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let date = dateFormatter.date(from: splitStringArray[0])
        dateFormatter.dateFormat = format.rawValue//"dd MMM yyy"
        let dateStr = dateFormatter.string(from: date!)
        return dateStr
        
    }
    
    func getDateStringBy(format: DateFormat) -> String? {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format.rawValue//"dd MMM yyy"
        
        guard let dateObj = dateFormatterGet.date(from: self) else {return nil}
        return dateFormatter.string(from: dateObj)
    }
    
    func getTransactionDateFormat() -> String?{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "dd MMM yyyy hh:mm a"
        guard let dateObj = dateFormatterGet.date(from: self) else {return nil}
        return dateFormatter.string(from: dateObj)
    }
    
    func toUInt() -> UInt? {
        return self.toInt.flatMap { $0 < 0 ? nil : UInt($0) }
    }
    
    // https://sarunw.com/posts/how-to-compare-two-app-version-strings-in-swift/
    func versionCompare(_ otherVersion: String) -> ComparisonResult {
        let versionDelimiter = "."
        
        var versionComponents = self.components(separatedBy: versionDelimiter) // <1>
        var otherVersionComponents = otherVersion.components(separatedBy: versionDelimiter)
        
        let zeroDiff = versionComponents.count - otherVersionComponents.count // <2>
        
        if zeroDiff == 0 { // <3>
            // Same format, compare normally
            return self.compare(otherVersion, options: .numeric)
        } else {
            let zeros = Array(repeating: "0", count: abs(zeroDiff)) // <4>
            if zeroDiff > 0 {
                otherVersionComponents.append(contentsOf: zeros) // <5>
            } else {
                versionComponents.append(contentsOf: zeros)
            }
            return versionComponents.joined(separator: versionDelimiter)
                .compare(otherVersionComponents.joined(separator: versionDelimiter), options: .numeric) // <6>
        }
    }
    
    func lines(font : UIFont, width : CGFloat) -> Int {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude);
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil);
        return Int(boundingBox.height/font.lineHeight);
    }
    
    func findPhoneNumber() -> String? {
        let phoneRegex = #"\b\d{7,20}\b"#  // Regular expression to match 8 consecutive digits
        
        do {
            let regex = try NSRegularExpression(pattern: phoneRegex)
            let range = NSRange(self.startIndex..<self.endIndex, in: self)
            if let match = regex.firstMatch(in: self, range: range) {
                return String(self[Range(match.range, in: self)!])
            }
        } catch {
            print("Error creating regex: \(error)")
        }
        
        return nil
    }
    
}
