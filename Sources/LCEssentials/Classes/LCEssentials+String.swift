//  
// Copyright (c) 2018 SwifterSwift.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
 

import Foundation
import UIKit

public extension String {
    /// SwifterSwift: Check if string is a valid URL.
    ///
    ///        "https://google.com".isValidUrl -> true
    ///
    var isValidUrl: Bool {
        return URL(string: self) != nil
    }

    #if canImport(Foundation)
    /// SwifterSwift: Check if string is a valid https URL.
    ///
    ///        "https://google.com".isValidHttpsUrl -> true
    ///
    var isValidHttpsUrl: Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme == "https"
    }
    #endif

    #if canImport(Foundation)
    /// SwifterSwift: Check if string is a valid http URL.
    ///
    ///        "http://google.com".isValidHttpUrl -> true
    ///
    var isValidHttpUrl: Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme == "http"
    }
    #endif
    
    /// SwifterSwift.: Readable string from a URL string.
    ///
    ///        "it's%20easy%20to%20decode%20strings".urlDecoded -> "it's easy to decode strings"
    ///
    var urlDecoded: String {
        return removingPercentEncoding ?? self
    }
    
    /// SwifterSwift.: URL escaped string.
    ///
    ///        "it's easy to encode strings".urlEncoded -> "it's%20easy%20to%20encode%20strings"
    ///
    var urlEncoded: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    /// SwifterSwift.: String without spaces and new lines.
    ///
    ///        "   \n Swifter   \n  Swift  ".withoutSpacesAndNewLines -> "SwifterSwift"
    ///
    var withoutSpacesAndNewLines: String {
        return replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
    }
    
    /// Loverde Co.: Replace Dictionaryes parameters to URL String.
    @discardableResult
    func replaceURL(_ withDict: [String:Any]) -> String {
        var strOutput = self
        for (key, Value) in withDict {
            strOutput = strOutput.replaceFirst(of: "{\(key)}", with: "\(Value)")
        }
        return strOutput
    }
    
    var isEmailValid: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
        } catch {
            return false
        }
    }
    var isCPF: Bool {
        let cpf = self.onlyNumbers()
        guard cpf.count == 11 else { return false }

        let i1 = cpf.index(cpf.startIndex, offsetBy: 9)
        let i2 = cpf.index(cpf.startIndex, offsetBy: 10)
        let i3 = cpf.index(cpf.startIndex, offsetBy: 11)
        let d1 = Int(cpf[i1..<i2])
        let d2 = Int(cpf[i2..<i3])

        var temp1 = 0, temp2 = 0

        for i in 0...8 {
            let start = cpf.index(cpf.startIndex, offsetBy: i)
            let end = cpf.index(cpf.startIndex, offsetBy: i+1)
            let char = Int(cpf[start..<end])

            temp1 += char! * (10 - i)
            temp2 += char! * (11 - i)
        }

        temp1 %= 11
        temp1 = temp1 < 2 ? 0 : 11-temp1

        temp2 += temp1 * 2
        temp2 %= 11
        temp2 = temp2 < 2 ? 0 : 11-temp2

        return temp1 == d1 && temp2 == d2
    }

    #if canImport(Foundation)
    /// SwifterSwift: Check if string is a valid Swift number. Note: In North America, "." is the decimal separator, while in many parts of Europe "," is used,
    ///
    ///        "123".isNumeric -> true
    ///     "1.3".isNumeric -> true (en_US)
    ///     "1,3".isNumeric -> true (fr_FR)
    ///        "abc".isNumeric -> false
    ///
    var isNumeric: Bool {
        let scanner = Scanner(string: self)
        scanner.locale = NSLocale.current
        #if os(Linux) || targetEnvironment(macCatalyst)
        return scanner.scanDecimal() != nil && scanner.isAtEnd
        #else
        return scanner.scanDecimal(nil) && scanner.isAtEnd
        #endif
    }
    #endif
    /// SwifterSwift.: Bool value from string (if applicable).
    ///
    ///        "1".bool -> true
    ///        "False".bool -> false
    ///        "Hello".bool = nil
    ///
    var bool: Bool? {
        let selfLowercased = trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        switch selfLowercased {
        case "true", "yes", "1":
            return true
        case "false", "no", "0":
            return false
        default:
            return nil
        }
    }

    /// SwifterSwift: Check if string contains one or more emojis.
    ///
    ///        "Hello 😀".containEmoji -> true
    ///
    var containEmoji: Bool {
        // http://stackoverflow.com/questions/30757193/find-out-if-character-in-string-is-emoji
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F, // Emoticons
            0x1F300...0x1F5FF, // Misc Symbols and Pictographs
            0x1F680...0x1F6FF, // Transport and Map
            0x1F1E6...0x1F1FF, // Regional country flags
            0x2600...0x26FF, // Misc symbols
            0x2700...0x27BF, // Dingbats
            0xE0020...0xE007F, // Tags
            0xFE00...0xFE0F, // Variation Selectors
            0x1F900...0x1F9FF, // Supplemental Symbols and Pictographs
            127000...127600, // Various asian characters
            65024...65039, // Variation selector
            9100...9300, // Misc items
            8400...8447: // Combining Diacritical Marks for Symbols
                return true
            default:
                continue
            }
        }
        return false
    }

    /// SwifterSwift.: Lorem ipsum string of given length.
    ///
    /// - Parameter length: number of characters to limit lorem ipsum to (default is 445 - full lorem ipsum).
    /// - Returns: Lorem ipsum dolor sit amet... string.
    static func loremIpsum(ofLength length: Int = 445) -> String {
        guard length > 0 else { return "" }

        // https://www.lipsum.com/
        let loremIpsum = """
        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        """
        if loremIpsum.count > length {
            return String(loremIpsum[loremIpsum.startIndex..<loremIpsum.index(loremIpsum.startIndex, offsetBy: length)])
        }
        return loremIpsum
    }

    func onlyNumbers() -> String {
        guard !isEmpty else { return "" }
        return replacingOccurrences(of: "\\D",
                                    with: "",
                                    options: .regularExpression,
                                    range: startIndex..<endIndex)
    }
    var isValidCNPJ: Bool {
        let numbers = compactMap({ $0.wholeNumberValue })
        guard numbers.count == 14 && Set(numbers).count != 1 else { return false }
        func digitCalculator(_ slice: ArraySlice<Int>) -> Int {
            var number = 1
            let digit = 11 - slice.reversed().reduce(into: 0) {
                number += 1
                $0 += $1 * number
                if number == 9 { number = 1 }
            } % 11
            return digit % 10
        }
        let dv1 = digitCalculator(numbers.prefix(12))
        let dv2 = digitCalculator(numbers.prefix(13))
        return dv1 == numbers[12] && dv2 == numbers[13]
    }

    /// SwifterSwift.: Returns a string by padding to fit the length parameter size with another string in the start.
    ///
    ///   "hue".paddingStart(10) -> "       hue"
    ///   "hue".paddingStart(10, with: "br") -> "brbrbrbhue"
    ///
    /// - Parameter length: The target length to pad.
    /// - Parameter string: Pad string. Default is " ".
    /// - Returns: The string with the padding on the start.
    func paddingStart(_ length: Int, with string: String = " ") -> String {
        guard count < length else { return self }

        let padLength = length - count
        if padLength < string.count {
            return string[string.startIndex..<string.index(string.startIndex, offsetBy: padLength)] + self
        } else {
            var padding = string
            while padding.count < padLength {
                padding.append(string)
            }
            return padding[padding.startIndex..<padding.index(padding.startIndex, offsetBy: padLength)] + self
        }
    }
    /// SwifterSwift.: Returns a string by padding to fit the length parameter size with another string in the end.
    ///
    ///   "hue".paddingEnd(10) -> "hue       "
    ///   "hue".paddingEnd(10, with: "br") -> "huebrbrbrb"
    ///
    /// - Parameter length: The target length to pad.
    /// - Parameter string: Pad string. Default is " ".
    /// - Returns: The string with the padding on the end.
    func paddingEnd(_ length: Int, with string: String = " ") -> String {
        guard count < length else { return self }

        let padLength = length - count
        if padLength < string.count {
            return self + string[string.startIndex..<string.index(string.startIndex, offsetBy: padLength)]
        } else {
            var padding = string
            while padding.count < padLength {
                padding.append(string)
            }
            return self + padding[padding.startIndex..<padding.index(padding.startIndex, offsetBy: padLength)]
        }
    }
    
    var currentTimeZone : String {
        let date = NSDate();
        let formatter = DateFormatter();
        formatter.dateFormat = "ZZZ";
        let defaultTimeZoneStr = formatter.string(from: date as Date);

        return defaultTimeZoneStr;
    }

    func nsRange(from range: Range<String.Index>) -> NSRange? {
        let utf16view = self.utf16
        if let from = range.lowerBound.samePosition(in: utf16view), let to = range.upperBound.samePosition(in: utf16view) {
            return NSMakeRange(utf16view.distance(from: utf16view.startIndex, to: from), utf16view.distance(from: from, to: to))
        }
        return nil
    }

    mutating func insertAtIndexEnd(string:String, ind:Int) {
        self.insert(contentsOf: string, at:self.index(self.endIndex, offsetBy: ind) )
    }
    
    mutating func insertAtIndexStart(string:String, ind:Int) {
        self.insert(contentsOf: string, at:self.index(self.endIndex, offsetBy: ind) )
    }
    /// SwifterSwift.: Convert URL string to readable string.
    ///
    ///        var str = "it's%20easy%20to%20decode%20strings"
    ///        str.urlDecode()
    ///        print(str) // prints "it's easy to decode strings"
    ///
    @discardableResult
    mutating func urlDecode() -> String {
        if let decoded = removingPercentEncoding {
            self = decoded
        }
        return self
    }
    /// SwifterSwift: Escape string.
    ///
    ///        var str = "it's easy to encode strings"
    ///        str.urlEncode()
    ///        print(str) // prints "it's%20easy%20to%20encode%20strings"
    ///
    @discardableResult
    mutating func urlEncode() -> String {
        if let encoded = addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            self = encoded
        }
        return self
    }
    
    /// Verifica se o texto equivale a verdadeiro ou falso.
    func validateBolean(comparingBoolean:Bool = true) ->Bool{

        if(comparingBoolean)
        {
            if (self.uppercased() == "TRUE") {return true}
            if (self.uppercased() == "YES") {return true}
            if (self.uppercased() == "ON") {return true}
            if (self.uppercased() == "ONLINE") {return true}
            if (self.uppercased() == "ENABLE") {return true}
            if (self.uppercased() == "ACTIVATED") {return true}
            if (self.uppercased() == "ONE") {return true}
            //
            if (self.uppercased() == "VERDADEIRO") {return true}
            if (self.uppercased() == "SIM") {return true}
            if (self.uppercased() == "LIGADO") {return true}
            if (self.uppercased() == "ATIVO") {return true}
            if (self.uppercased() == "ATIVADO") {return true}
            if (self.uppercased() == "HABILITADO") {return true}
            if (self.uppercased() == "UM") {return true}
            //
            if (self.uppercased() == "1") {return true}
            if (self.uppercased() == "T") {return true}
            if (self.uppercased() == "Y") {return true}
            if (self.uppercased() == "S") {return true}
        }
        else
        {
            if (self.uppercased() == "FALSE") {return true}
            if (self.uppercased() == "NO") {return true}
            if (self.uppercased() == "OFF") {return true}
            if (self.uppercased() == "OFFLINE") {return true}
            if (self.uppercased() == "DISABLED") {return true}
            if (self.uppercased() == "DEACTIVATED") {return true}
            if (self.uppercased() == "ZERO") {return true}
            //
            if (self.uppercased() == "FALSO") {return true}
            if (self.uppercased() == "NÃO") {return true}
            if (self.uppercased() == "NAO") {return true}
            if (self.uppercased() == "DESLIGADO") {return true}
            if (self.uppercased() == "DESATIVADO") {return true}
            if (self.uppercased() == "DESABILITADO") {return true}
            //
            if (self.uppercased() == "0") {return true}
            if (self.uppercased() == "F") {return true}
            if (self.uppercased() == "N") {return true}
        }

        return false;
    }
    

    func randomString(length: Int) -> String {

        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)

        var randomString = ""

        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }

        return randomString
    }

    func stringFromTimeInterval(_ interval:TimeInterval) -> NSString {

        let ti = NSInteger(interval)

        let ms = Int((interval.truncatingRemainder(dividingBy: 1)) * 1000)

        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)

        return NSString(format: "%0.2d:%0.2d:%0.2d.%0.3d",hours,minutes,seconds,ms)
    }
    
    /// LoverdeCo: String to Date object.
    ///
    /// - Parameters:
    ///   - withCurrFormatt: Give a input formatt as it comes in String.
    ///   - Returns: Date object.
    func date(withCurrFormatt: String = "yyyy-MM-dd HH:mm:ss", localeIdentifier: String = "pt-BR", timeZone:TimeZone? = TimeZone.current) -> Date? {

        let updatedString:String = self.replacingOccurrences(of: " 0000", with: " +0000")
        let dateFormatter:DateFormatter = DateFormatter.init()
        let calendar:Calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        let enUSPOSIXLocale:Locale = Locale.init(identifier: localeIdentifier)
        //
        dateFormatter.timeZone = timeZone
        //
        dateFormatter.calendar = calendar
        dateFormatter.locale = enUSPOSIXLocale
        dateFormatter.dateFormat = withCurrFormatt
        //
        return dateFormatter.date(from: updatedString)
    }
    
    /// LoverdeCo: String to Date object.
    ///
    /// - Parameters:
    ///   - withCurrFormatt: Give a input formatt as it comes in String.
    ///   - newFormatt: Give a new formatt you want in String
    ///   - Returns: Date object.
    func date(withCurrFormatt: String = "yyyy-MM-dd HH:mm:ss", newFormatt: String = "yyyy-MM-dd HH:mm:ss", localeIdentifier: String = "pt-BR", timeZone:TimeZone? = TimeZone.current) -> Date? {
        let date = self.date(withCurrFormatt: withCurrFormatt, localeIdentifier: localeIdentifier, timeZone: timeZone)
        let strDate = date?.string(stringFormat: newFormatt, localeIdentifier: localeIdentifier, timeZone: timeZone)
        return strDate?.date(withCurrFormatt: newFormatt, localeIdentifier: localeIdentifier, timeZone: timeZone)
    }

    var first: String {
        return String(prefix(1))
    }
    var last: String {
        return String(suffix(1))
    }
    var uppercaseFirst: String {
        return first.uppercased() + String(dropFirst())
    }

    #if os(iOS) || os(macOS)
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.width)
    }

    func encodeImageToBase64(refImage: UIImage) -> String{
        let jpegCompressionQuality: CGFloat = 0.6
        if let base64String = refImage.jpegData(compressionQuality: jpegCompressionQuality){
            let strBase64 = base64String.base64EncodedString(options: .endLineWithLineFeed)
            return strBase64
        }
        return ""
    }
    #endif
    
    func exponentize(str: String) -> String {

        let supers = [
            "1": "\u{00B9}",
            "2": "\u{00B2}",
            "3": "\u{00B3}",
            "4": "\u{2074}",
            "5": "\u{2075}",
            "6": "\u{2076}",
            "7": "\u{2077}",
            "8": "\u{2078}",
            "9": "\u{2079}"]

        var newStr = ""
        var isExp = false
        for (_, char) in str.enumerated() {
            if char == "^" {
                isExp = true
            } else {
                if isExp {
                    let key = String(char)
                    if supers.keys.contains(key) {
                        newStr.append(Character(supers[key]!))
                    } else {
                        isExp = false
                        newStr.append(char)
                    }
                } else {
                    newStr.append(char)
                }
            }
        }
        return newStr
    }

    /// SwifterSwift.: Truncate string (cut it to a given number of characters).
    ///
    ///        var str = "This is a very long sentence"
    ///        str.truncate(toLength: 14)
    ///        print(str) // prints "This is a very..."
    ///
    /// - Parameters:
    ///   - toLength: maximum number of characters before cutting.
    ///   - trailing: string to add at the end of truncated string (default is "...").
    @discardableResult
    mutating func truncate(toLength length: Int, trailing: String? = "...") -> String {
        guard length > 0 else { return self }
        if count > length {
            self = self[startIndex..<index(startIndex, offsetBy: length)] + (trailing ?? "")
        }
        return self
    }

    /// SwifterSwift.: Truncated string (limited to a given number of characters).
    ///
    ///        "This is a very long sentence".truncated(toLength: 14) -> "This is a very..."
    ///        "Short sentence".truncated(toLength: 14) -> "Short sentence"
    ///
    /// - Parameters:
    ///   - toLength: maximum number of characters before cutting.
    ///   - trailing: string to add at the end of truncated string.
    /// - Returns: truncated string (this is an extr...).
    func truncated(toLength length: Int, trailing: String? = "...") -> String {
        guard 1..<count ~= length else { return self }
        return self[startIndex..<index(startIndex, offsetBy: length)] + (trailing ?? "")
    }
    
    func replacing(range: CountableClosedRange<Int>, with replacementString: String) -> String {
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end   = index(start, offsetBy: range.count)
        return self.replacingCharacters(in: start ..< end, with: replacementString)
    }
    
    func replacingLastOccurrenceOfString(_ searchString: String, with replacementString: String, caseInsensitive: Bool = true) -> String {
        let options: String.CompareOptions
        if caseInsensitive {
            options = [.backwards, .caseInsensitive]
        } else {
            options = [.backwards]
        }

        if let range = self.range(of: searchString, options: options, range: nil, locale: nil) {
            return self.replacingCharacters(in: range, with: replacementString)
        }
        return self
    }

    //
    ///Usage Example: label.text = yourString.html2String
    var html2AttributedString: NSAttributedString? {
        guard
            let data = data(using: String.Encoding.utf8)
            else { return nil }
        do {
            let attributedOptions: [NSAttributedString.DocumentReadingOptionKey : Any] = [
                NSAttributedString.DocumentReadingOptionKey(rawValue: NSAttributedString.DocumentAttributeKey.documentType.rawValue): NSAttributedString.DocumentType.html,
                NSAttributedString.DocumentReadingOptionKey(rawValue: NSAttributedString.DocumentAttributeKey.characterEncoding.rawValue): String.Encoding.utf8.rawValue
            ]
            return try NSAttributedString(data: data, options: attributedOptions, documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
    
    func JSONStringToDictionary() -> [String:Any]? {
        if let data = self.data(using: .utf8) {
             do {
                 let jsonString = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                 return jsonString
             } catch {
                 printError(title: "JSON STRING", msg: error.localizedDescription)
                 return nil
             }
        }else{
            return nil
        }
    }
    //MARK: - Currency formatters alternative
    //    let price = 1.99
    //
    //    print(Formatter.currency.locale)  // "en_US (current)\n"
    //    print(price.currency)             // "$1.99\n"
    //
    //    Formatter.currency.locale = Locale(identifier: "pt_BR")
    //    print(price.currency)  // "R$1,99\n"
    //
    //    Formatter.currency.locale = Locale(identifier: "en_UK")
    //    print(price.currency)  // "£1.99\n"
    //
    //    print(price.currencyBR)  // "R$1,99\n"
    //    print(price.currencyUS)  // "$1.99\n"s
    func removeFormatAmount() -> Float {
        let textValue   = self //"$1.200,33"
        let nonDigits   = CharacterSet(charactersIn: "01234456789").inverted
        let digitGroups = textValue.components(separatedBy:nonDigits).filter{!$0.isEmpty}
        let textNumber  = digitGroups.dropLast().joined(separator:"")
            + ( digitGroups.last!.count == 2
                && digitGroups.count > 1 ? "." : "" )
            + digitGroups.last!
        
        return Float(textNumber)!
    }
    func convertFloatToCurrency(value: Float, withSpace: Bool = false) -> String{
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = NumberFormatter.Style.currency
        currencyFormatter.currencySymbol = withSpace ? "\(currencyFormatter.currencySymbol!) " : currencyFormatter.currencySymbol
        // localize to your grouping and decimal separator
        currencyFormatter.locale = NSLocale.current
        let priceString = currencyFormatter.string(from: NSNumber(value: value))
        return priceString!
    }
    
    func currencyInputFormatting(withSpace: Bool = false, withSymbol: Bool = true) -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = NumberFormatter.Style.currency
        formatter.currencySymbol = withSymbol ? ( withSpace ? "\(formatter.currencySymbol!) " : formatter.currencySymbol ): ""
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.locale = NSLocale.current
        
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        
        return formatter.string(from: number)!
    }
    
    
    func convertFloatToCurrency(value: Float) -> String{

        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = NumberFormatter.Style.currency
        // localize to your grouping and decimal separator
        currencyFormatter.locale = NSLocale.current
        let priceString = currencyFormatter.string(from: NSNumber(value: value))
        return priceString!
    }
    
    func convertToCurrencyFormatt(value: Float) -> String?{
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = NumberFormatter.Style.currency
        // localize to your grouping and decimal separator
        currencyFormatter.locale = NSLocale.current
        
        if let amountString = currencyFormatter.string(from: NSNumber(value: value)) {
            // check if it has default space like EUR
            let hasSpace = amountString.rangeOfCharacter(from: .whitespaces) != nil
            
            if let indexOfSymbol = amountString.firstIndex(of: Character(currencyFormatter.currencySymbol)) {
                if amountString.startIndex == indexOfSymbol {
                    currencyFormatter.paddingPosition = .afterPrefix
                } else {
                    currencyFormatter.paddingPosition = .beforeSuffix
                }
            }
            if !hasSpace {
                currencyFormatter.formatWidth = amountString.count + 1
                currencyFormatter.paddingCharacter = " "
            }
        } else {
            print("Error while making amount string from given amount: \(value)")
            return nil
        }
        
        if let finalAmountString = currencyFormatter.string(from: NSNumber(value: value)) {
            return finalAmountString
        } else {
            return nil
        }
    }
    
    func toURL() -> NSURL? {
        return NSURL(string: self)
    }
    /// SwifterSwift.: Float value from string (if applicable).
    ///
    /// - Parameter locale: Locale (default is Locale.current)
    /// - Returns: Optional Float value from given string.
    func float(locale: Locale = .current) -> Float? {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.allowsFloats = true
        return formatter.number(from: self)?.floatValue
    }
    /// SwifterSwift.: Double value from string (if applicable).
    ///
    /// - Parameter locale: Locale (default is Locale.current)
    /// - Returns: Optional Double value from given string.
    func double(locale: Locale = .current) -> Double? {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.allowsFloats = true
        return formatter.number(from: self)?.doubleValue
    }
    /// SwifterSwift.: Returns a localized string, with an optional comment for translators.
    ///
    ///        "Hello world".localized -> Hallo Welt
    ///
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }

    /// SwifterSwift: First character of string (if applicable).
    ///
    ///        "Hello".firstCharacterAsString -> Optional("H")
    ///        "".firstCharacterAsString -> nil
    ///
    var firstCharacterAsString: String? {
        guard let first = first else { return nil }
        return String(first)
    }

    /// SwifterSwift: Last character of string (if applicable).
    ///
    ///        "Hello".lastCharacterAsString -> Optional("o")
    ///        "".lastCharacterAsString -> nil
    ///
    var lastCharacterAsString: String? {
        guard let last = last else { return nil }
        return String(last)
    }
    /// SwifterSwift.: Transforms the string into a slug string.
    ///
    ///        "Swift is amazing".toSlug() -> "swift-is-amazing"
    ///
    /// - Returns: The string in slug format.
    func toSlug() -> String {
        let lowercased = self.lowercased()
        let latinized = lowercased.folding(options: .diacriticInsensitive, locale: Locale.current)
        let withDashes = latinized.replacingOccurrences(of: " ", with: "-")

        let alphanumerics = NSCharacterSet.alphanumerics
        var filtered = withDashes.filter {
            guard String($0) != "-" else { return true }
            guard String($0) != "&" else { return true }
            return String($0).rangeOfCharacter(from: alphanumerics) != nil
        }

        while filtered.lastCharacterAsString == "-" {
            filtered = String(filtered.dropLast())
        }

        while filtered.firstCharacterAsString == "-" {
            filtered = String(filtered.dropFirst())
        }

        return filtered.replacingOccurrences(of: "--", with: "-")
    }
    /// SwifterSwift.: Check if string contains one or more instance of substring.
    ///
    ///        "Hello World!".contain("O") -> false
    ///        "Hello World!".contain("o", caseSensitive: false) -> true
    ///
    /// - Parameters:
    ///   - string: substring to search for.
    ///   - caseSensitive: set true for case sensitive search (default is true).
    /// - Returns: true if string contains one or more instance of substring.
    func contains(_ string: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return range(of: string, options: .caseInsensitive) != nil
        }
        return range(of: string) != nil
    }
    /// SwifterSwift.: Removes spaces and new lines in beginning and end of string.
    ///
    ///        var str = "  \n Hello World \n\n\n"
    ///        str.trim()
    ///        print(str) // prints "Hello World"
    ///
    @discardableResult
    mutating func trim() -> String {
        self = trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return self
    }
    
    /// Loverde Co.: Add mask to a text - Very simple to use
    ///
    /// - Parameter toText: String you want to maks
    /// - Parameter mask: Using mask like sharp ##-#####(###)
    func applyMask(inputMask:String?, maxLenght:Int, range:NSRange, textFieldString:String, replacementString:String, charactersRestriction:String?) -> String? {
        
        // Prevent crashing undo bug
        if (range.length + range.location > textFieldString.count) {
            return nil
        }
        
        //Mask validation:
        if let mask:String = inputMask {
            
            var changedString:String = (textFieldString as NSString).replacingCharacters(in: range, with: replacementString)
            
            if changedString == "" {
                return ""
            }
            
            var ignore:Bool = false
            
            let subString:String = (textFieldString as NSString).substring(with: range)
            let rangeSub:Range? = subString.rangeOfCharacter(from: CharacterSet.init(charactersIn: "0123456789"))
            
            if ((range.length == 1) && (replacementString.count < range.length) && (rangeSub == nil)) {
                
                var location:Int = changedString.count - 1
                
                if (location > 0) {
                    
                    for index in stride(from: location, through: 1, by: -1) {
                        
                        if (CharacterSet.init(charactersIn: "0123456789").contains(UnicodeScalar((changedString as NSString).character(at: index))!)) {
                            location = index;
                            break
                        }
                    }
                    changedString = (changedString as NSString).substring(to: location)
                    
                }else {
                    ignore = true
                }
            }
            
            if (ignore) {
                return nil
            }else {
                return applyMask(toText: changedString, mask: mask)
            }
            
        }else{
            
            //Max lenght validation:
            if (maxLenght > 0) {
                
                let newLength:Int = textFieldString.count + replacementString.count - range.length
                if (newLength > maxLenght) {
                    return nil
                }
            }
            
            //Characters validation:
            if let chars:String = charactersRestriction {
                
                let characterset = CharacterSet(charactersIn: chars)
                if replacementString.rangeOfCharacter(from: characterset.inverted) != nil {
                    //O texto possui caracteres inválidos
                    return nil
                }else{
                    var newText = (textFieldString as NSString).replacingCharacters(in: range, with: replacementString)
                    newText = self.removeMask(fromText:  "~˜^ˆ'`¨", charsMask: newText)
                    return newText
                }
                
            }else{
                //Normal success return
                let newText = (textFieldString as NSString).replacingCharacters(in: range, with: replacementString)
                return newText
            }
            
        }
        
    }
    
    /// Loverde Co.: Add mask to a text - Very simple to use
    ///
    /// - Parameter toText: String you want to maks
    /// - Parameter mask: Using mask like sharp ##-#####(###)
    func applyMask(toText: String, mask: String) -> String {

        let toTextNSString = toText as NSString
        let maskNSString = mask as NSString
        
        var onOriginal:Int = 0
        var onFilter:Int = 0
        var onOutput:Int = 0
        var outputString = [Character](repeating: "\0", count:maskNSString.length)
        var done:Bool = false

        while (onFilter < maskNSString.length && !done) {

            let filterChar:Character = Character(UnicodeScalar(maskNSString.character(at: onFilter))!)
            let originalChar:Character = onOriginal >= toTextNSString.length ? "\0" : Character(UnicodeScalar(toTextNSString.character(at: onOriginal))!)

            switch filterChar {
            case "#":

                if (originalChar == "\0") {
                    // We have no more input numbers for the filter.  We're done.
                    done = true
                    break
                }

                if (CharacterSet.init(charactersIn: "0123456789").contains(UnicodeScalar(originalChar.unicodeScalarCodePoint())!)) {
                    outputString[onOutput] = originalChar;
                    onOriginal += 1
                    onFilter += 1
                    onOutput += 1
                }else{
                    onOriginal += 1
                }

            default:
                // Any other character will automatically be inserted for the user as they type (spaces, - etc..) or deleted as they delete if there are more numbers to come.
                outputString[onOutput] = filterChar;
                onOutput += 1
                onFilter += 1
                if(originalChar == filterChar) {
                    onOriginal += 1
                }
            }
        }

        if (onOutput < outputString.count){
            outputString[onOutput] = "\0" // Cap the output string
        }

        return String(outputString).replacingOccurrences(of: "\0", with: "")
    }
    
    /// Loverde Co.: Add mask to a text - Very simple to use
    ///
    /// - Parameter toText: String you want to maks
    /// - Parameter mask: Using mask like sharp ##-#####(###)
    func applyMask(mask:String = "#####-####", toText: String) -> String {
        let cleanPhoneNumber = toText.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()

        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask {
            if index == cleanPhoneNumber.endIndex {
                break
            }
            if ch == "#" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    /// Loverde Co.: Remove mask from a text - Very simple to use
    ///
    /// - Parameter fromText: String you want to remove maks
    /// - Parameter charsMask: Used mask like sharp ##-#####(###)
    func removeMask(fromText:String, charsMask:String) -> String{

        var resultString = fromText;
        //
        for character in charsMask {
            let str:String = String(character)
            resultString = resultString.replacingOccurrences(of: str, with: "")
        }
        //
        return resultString;
    }
    
    func stringByAddingPercentEncodingForRFC3986() -> String {
        let allowedQueryParamAndKey =  CharacterSet(charactersIn: ";/?:@&=+$, ").inverted
        return addingPercentEncoding(withAllowedCharacters: allowedQueryParamAndKey)!
    }
    var removingWhitespacesAndNewlines: String {
        return components(separatedBy: .whitespacesAndNewlines).joined(separator: "")
    }
    func replaceFirst(of pattern:String,
                             with replacement:String) -> String {
        if let range = self.range(of: pattern){
            return self.replacingCharacters(in: range, with: replacement)
        }else{
            return self
        }
    }
    
    func replaceAll(of pattern:String,
                           with replacement:String,
                           options: NSRegularExpression.Options = []) -> String{
        do{
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let range = NSRange(0..<self.utf16.count)
            return regex.stringByReplacingMatches(in: self, options: [],
                                                  range: range, withTemplate: replacement)
        }catch{
            NSLog("replaceAll error: \(error)")
            return self
        }
    }
}


extension Character
{
    func unicodeScalarCodePoint() -> UInt32
    {
        let characterString = String(self)
        let scalars = characterString.unicodeScalars
        
        return scalars[scalars.startIndex].value
    }
}
