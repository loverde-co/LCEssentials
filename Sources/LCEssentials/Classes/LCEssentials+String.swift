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
#if canImport(CommonCrypto)
import CommonCrypto
#endif

public extension String {
    
    // MARK: - Variables
    
    private var convertHtmlToNSAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else {
            return nil
        }
        
        do {
            return try NSAttributedString(data: data,
                                          options: [
                                            .documentType: NSAttributedString.DocumentType.html,
                                            .characterEncoding: String.Encoding.utf8.rawValue
                                          ], documentAttributes: nil)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    var convertToHTML: NSAttributedString? {
        return convertHtmlToAttributedStringWithCSS(font: nil,
                                                    csscolor: "",
                                                    lineheight: 0,
                                                    csstextalign: "")
    }
    
    /// Check if string is a valid URL.
    ///
    ///        "https://google.com".isValidUrl -> true
    ///
    var isValidUrl: Bool {
        return URL(string: self) != nil
    }

    #if canImport(Foundation)
    /// Check if string is a valid https URL.
    ///
    ///        "https://google.com".isValidHttpsUrl -> true
    ///
    var isValidHttpsUrl: Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme == "https"
    }
    #endif

    #if canImport(Foundation)
    /// Check if string is a valid http URL.
    ///
    ///        "http://google.com".isValidHttpUrl -> true
    ///
    var isValidHttpUrl: Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme == "http"
    }
    #endif
    
    /// Readable string from a URL string.
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
    /// String without spaces and new lines.
    ///
    ///        "   \n Swifter   \n  Swift  ".withoutSpacesAndNewLines -> "SwifterSwift"
    ///
    var withoutSpacesAndNewLines: String {
        return replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
    }
    
    var isEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}"
        let emailTest  = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var isCPF: Bool {
        let cpf = self.onlyNumbers
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
    
    var JSONStringToDictionary: [String:Any]? {
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
    
    var currencyStringToDouble: Double {
        let formatter = NumberFormatter()
        let str = self.replacingOccurrences(of: " ", with: "")
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_br")
        let number = formatter.number(from: str)
        
        return number?.doubleValue ?? 0.0
    }
    
    var removeSpecialChars: String {
        let okayChars = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890-")
        return self.filter {okayChars.contains($0) }
    }
    
    var removeHTMLTags: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    var removeEmoji: String {
        return self.components(separatedBy: CharacterSet.symbols).joined()
    }
    
    var alphanumeric: String {
        return self.components(separatedBy: CharacterSet.alphanumerics.inverted).joined()
    }
    
    /// Check if string contains only letters.
    ///
    ///        "abc".isAlphabetic -> true
    ///        "123abc".isAlphabetic -> false
    ///
    var isAlphabetic: Bool {
        let hasLetters = rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
        let hasNumbers = rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
        return hasLetters && !hasNumbers
    }
    
    /// Check if string contains at least one letter and one number.
    ///
    ///        // useful for passwords
    ///        "123abc".isAlphaNumeric -> true
    ///        "abc".isAlphaNumeric -> false
    ///
    var isAlphaNumeric: Bool {
        let hasLetters = rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
        let hasNumbers = rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
        let comps = components(separatedBy: .alphanumerics)
        return comps.joined(separator: "").count == 0 && hasLetters && hasNumbers
    }
    
    var alphanumericWithWhiteSpace: String {
        return self.components(separatedBy: CharacterSet.alphanumerics.union(.whitespaces).inverted).joined()
    }
    
    var lettersWithWhiteSpace: String {
        return self.components(separatedBy: CharacterSet.letters.union(.whitespaces).inverted).joined()
    }
    
    var letters: String {
        return self.components(separatedBy: CharacterSet.letters.inverted).joined()
    }
    
    var numbers: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
    
    var data: Data {
        return Data(self.utf8)
    }
    
    /// Retorna a URL encontrada na string, caso exista. Se não, retorna nulo
    ///
    ///        let string = "Meu www.algumsite.com.br tem tudo que voce precisa."
    ///        print(string.url)
    ///        //Optional(www.algumsite.com.br)
    var url: String? {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))
            for match in matches {
                return (self as NSString).substring(with: match.range)
            }
        } catch {
            return nil
        }
        return nil
    }
    
    /// Retorna true caso contenha tag HTML na String
    ///
    ///        let string = "Meu <a href="www.algumsite.com.br">site</a> tem tudo que voce precisa."
    ///        print(string.isHTML)
    ///        //true
    var isHTML: Bool {
        return self.range(of: "<[^>]+>", options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    var onlyNumbers: String {
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
    
    var currentTimeZone : String {
        let date = NSDate();
        let formatter = DateFormatter();
        formatter.dateFormat = "ZZZ";
        let defaultTimeZoneStr = formatter.string(from: date as Date);

        return defaultTimeZoneStr;
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
    
    var toURL: NSURL? {
        return NSURL(string: self)
    }
    
    /// Integer value from string (if applicable).
    ///
    ///        "101".int -> 101
    ///
    var int: Int? {
        return Int(self)
    }
    
    var float: Float? {
        return Float(self)
    }
    
    var double: Double? {
        return Double(self)
    }
    
    var btcToSats: Int {
        let decamal = Decimal(string: self) ?? Decimal()
        var scaledResult = decamal * Decimal(bitcoinIntConvertion)
        return NSDecimalNumber(decimal: scaledResult).intValue
    }
    
    var bitcoinToSatoshis: Int {
        btcToSats
    }
    
    /// NSString from a string.
    var nsString: NSString {
        return NSString(string: self)
    }
    
    /// The full `NSRange` of the string.
    var fullNSRange: NSRange { NSRange(startIndex..<endIndex, in: self) }
    
    
    var base64Encode: String? {
        return data(using: .utf8)?.base64EncodedString()
    }
    
    
    var base64Decode: String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    // MARK: - Methods
    
    /// Loverde Co.: Replace Dictionaryes parameters to URL String.
    @discardableResult
    func replaceURL(_ withDict: [String: Any]) -> String {
        var strOutput = self
        for (key, Value) in withDict {
            strOutput = strOutput.replacingOccurrences(of: "{\(key)}", with: "\(Value)")
        }
        return strOutput
    }

    /// Lorem ipsum string of given length.
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
#if canImport(Foundation)
    /// An array of all words in a string.
    ///
    ///        "Swift is amazing".words() -> ["Swift", "is", "amazing"]
    ///
    /// - Returns: The words contained in a string.
    func words() -> [String] {
        // https://stackoverflow.com/questions/42822838
        let characterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let comps = components(separatedBy: characterSet)
        return comps.filter { !$0.isEmpty }
    }
    /// Count of words in a string.
    ///
    ///        "Swift is amazing".wordsCount() -> 3
    ///
    /// - Returns: The count of words contained in a string.
    func wordCount() -> Int {
        // https://stackoverflow.com/questions/42822838
        let characterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let comps = components(separatedBy: characterSet)
        let words = comps.filter { !$0.isEmpty }
        return words.count
    }
    /// Check if string contains one or more instance of substring.
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
#endif

    /// Reverse string.
    @discardableResult
    mutating func reverse() -> String {
        let chars: [Character] = reversed()
        self = String(chars)
        return self
    }
    
    /// Returns a string by padding to fit the length parameter size with another string in the start.
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
    /// Returns a string by padding to fit the length parameter size with another string in the end.
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

    func nsRange(from range: Range<String.Index>) -> NSRange? {
        let utf16view = self.utf16
        if let from = range.lowerBound.samePosition(in: utf16view), let to = range.upperBound.samePosition(in: utf16view) {
            return NSMakeRange(utf16view.distance(from: utf16view.startIndex, to: from), utf16view.distance(from: from, to: to))
        }
        return nil
    }

    mutating func insertAtIndexEnd(string: String, ind: Int) {
        self.insert(contentsOf: string, at: self.index(self.endIndex, offsetBy: ind) )
    }
    
    mutating func insertAtIndexStart(string: String, ind: Int) {
        self.insert(contentsOf: string, at: self.index(self.endIndex, offsetBy: ind) )
    }
    /// Convert URL string to readable string.
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
    /// Escape string.
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
    func date(withCurrFormatt: String = "yyyy-MM-dd HH:mm:ss",
              localeIdentifier: String = "pt-BR",
              timeZone: TimeZone? = TimeZone.current) -> Date? {

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
    /// - Returns:
    /// Date object.
    func date(withCurrFormatt: String = "yyyy-MM-dd HH:mm:ss",
              newFormatt: String = "yyyy-MM-dd HH:mm:ss",
              localeIdentifier: String = "pt-BR",
              timeZone: TimeZone? = TimeZone.current) -> Date? {
        
        let date = self.date(withCurrFormatt: withCurrFormatt, localeIdentifier: localeIdentifier, timeZone: timeZone)
        let strDate = date?.string(withFormat: newFormatt)
        return strDate?.date(withCurrFormatt: newFormatt, localeIdentifier: localeIdentifier, timeZone: timeZone)
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

    /// Truncate string (cut it to a given number of characters).
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

    /// Truncated string (limited to a given number of characters).
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
    
    func findAndReplace<Target, Replacement>(from this: Target, to that: Replacement) -> String
    where Target : StringProtocol, Replacement : StringProtocol {
        return self.replacingOccurrences(of: this, with: that)
    }
    
    func replace(from: String, to: String) -> String {
        return self.findAndReplace(from: from, to: to)
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
    
    /// Converte String para HTML com CSS.
    ///
    /// - Parameters:
    ///   - font: Caso necessite uma fonte diferente ou que seja considerado o CSS nessa conversão.
    ///   - csscolor: Cor da font em formato ASCII.
    ///   - lineheight: Quantas linhas o texto pode conter. Digite 0 (zero) caso queira dinâmico.
    ///   - csstextalign: Alinhamento do texto em formato CSS.
    ///   - customCSS: Adiciona CSS customizado (Opcional).
    /// - Returns:
    /// Retorna um NSAttributedString convertido.
    func convertHtmlToAttributedStringWithCSS(font: UIFont?,
                                              csscolor: String,
                                              lineheight: Int,
                                              csstextalign: String,
                                              customCSS: String? = nil) -> NSAttributedString? {
        guard let font = font else { return convertHtmlToNSAttributedString }
        
        let modifiedString = """
        <style>
            body{ font-family: '\(font.fontName)';
                font-size:\(font.pointSize)px;
                color: \(csscolor);
                line-height: \(lineheight)px;
                text-align: \(csstextalign); }
            \(customCSS ?? "")
        </style>\(self)
        """;
        
        guard let data = modifiedString.data(using: .utf8) else {
            return nil
        }
        
        do {
            return try NSAttributedString(data: data,
                                          options: [
                                            .documentType: NSAttributedString.DocumentType.html,
                                            .characterEncoding: String.Encoding.utf8.rawValue
                                          ], documentAttributes: nil)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    /// Float value from string (if applicable).
    ///
    /// - Parameter locale: Locale (default is Locale.current)
    /// - Returns: Optional Float value from given string.
    func float(locale: Locale = .current) -> Float? {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.allowsFloats = true
        return formatter.number(from: self)?.floatValue
    }
    /// Double value from string (if applicable).
    ///
    /// - Parameter locale: Locale (default is Locale.current)
    /// - Returns: Optional Double value from given string.
    func double(locale: Locale = .current) -> Double? {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.allowsFloats = true
        return formatter.number(from: self)?.doubleValue
    }
    /// Returns a localized string, with an optional comment for translators.
    ///
    ///        "Hello world".localized -> Hallo Welt
    ///
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }

    /// First character of string (if applicable).
    ///
    ///        "Hello".firstCharacterAsString -> Optional("H")
    ///        "".firstCharacterAsString -> nil
    ///
    var firstCharacterAsString: String? {
        guard let first = first else { return nil }
        return String(first)
    }

    /// Last character of string (if applicable).
    ///
    ///        "Hello".lastCharacterAsString -> Optional("o")
    ///        "".lastCharacterAsString -> nil
    ///
    var lastCharacterAsString: String? {
        guard let last = last else { return nil }
        return String(last)
    }
    /// Transforms the string into a slug string.
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
    /// Removes spaces and new lines in beginning and end of string.
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
    func applyMask(toText: String, mask: String) -> String {

        let toTextNSString = toText as NSString
        let maskNSString = mask as NSString
        
        var onOriginal: Int = 0
        var onFilter: Int = 0
        var onOutput: Int = 0
        var outputString = [Character](repeating: "\0", count: maskNSString.length)
        var done:Bool = false

        while (onFilter < maskNSString.length && !done) {

            let filterChar: Character = Character(UnicodeScalar(maskNSString.character(at: onFilter)) ?? UnicodeScalar.init(0))
            let originalChar: Character = onOriginal >= toTextNSString.length ? "\0" :
            Character(UnicodeScalar(toTextNSString.character(at: onOriginal))!)

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
    
    func stringByAddingPercentEncodingForRFC3986() -> String {
        let allowedQueryParamAndKey =  CharacterSet(charactersIn: ";/?:@&=+$, ").inverted
        return addingPercentEncoding(withAllowedCharacters: allowedQueryParamAndKey)!
    }
    
    func replaceAll(of pattern: String,
                    with replacement: String,
                    options: NSRegularExpression.Options = []) -> String{
        do{
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let range = NSRange(0..<self.utf16.count)
            return regex.stringByReplacingMatches(in: self, options: [],
                                                  range: range,
                                                  withTemplate: replacement)
        } catch {
            print("replaceAll error: %@", error)
            return self
        }
    }
    
#if canImport(CommonCrypto)
    func generateRandomAESKeyString() -> String {
        let key = Data((0..<32).map { _ in UInt8.random(in: 0...255) }) // 32 bytes para AES-256
        return key.base64EncodedString()
    }
    
    // Função para encriptar dados com AES-256-CBC
    func encryptAES(keyString: String) -> String? {
        // Decodifica a chave de Base64
        guard let keyData = Data(base64Encoded: keyString), keyData.count == kCCKeySizeAES256 else { return nil }
        guard let dataToEncrypt = self.data(using: .utf8) else { return nil }
        
        // Gerando um IV de 16 bytes
        let iv = Data((0..<kCCBlockSizeAES128).map { _ in UInt8.random(in: 0...255) })
        
        // Aloca um buffer para os dados encriptados
        let encryptedDataBufferSize = dataToEncrypt.count + kCCBlockSizeAES128
        let encryptedDataBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: encryptedDataBufferSize)
        defer {
            encryptedDataBuffer.deallocate()
        }
        
        var numBytesEncrypted: size_t = 0
        
        // Encriptação com CommonCrypto usando o buffer alocado manualmente
        let cryptStatus = CCCrypt(
            CCOperation(kCCEncrypt),
            CCAlgorithm(kCCAlgorithmAES128),
            CCOptions(kCCOptionPKCS7Padding),
            keyData.withUnsafeBytes { $0.baseAddress },
            kCCKeySizeAES256,
            iv.withUnsafeBytes { $0.baseAddress },
            dataToEncrypt.withUnsafeBytes { $0.baseAddress }, dataToEncrypt.count,
            encryptedDataBuffer, encryptedDataBufferSize,
            &numBytesEncrypted
        )
        
        guard cryptStatus == kCCSuccess else {
            print("Encryption failed with status: \(cryptStatus)")
            return nil
        }
        
        // Cria um Data com o IV concatenado aos dados encriptados
        let encryptedData = iv + Data(bytes: encryptedDataBuffer, count: numBytesEncrypted)
        
        // Retorna o resultado em Base64
        return encryptedData.base64EncodedString()
    }

    // Função para decriptar dados com AES-256-CBC
    func decryptAES(keyString: String) -> String? {
        // Decodifica a chave e os dados criptografados de Base64
        guard let keyData = Data(base64Encoded: keyString), keyData.count == kCCKeySizeAES256 else { return nil }
        guard let encryptedData = Data(base64Encoded: self) else { return nil }
        
        // O IV são os primeiros 16 bytes dos dados criptografados
        let iv = encryptedData.prefix(kCCBlockSizeAES128)
        let ciphertext = encryptedData.suffix(from: kCCBlockSizeAES128)
        
        // Aloca um buffer para os dados desencriptados
        let decryptedDataBufferSize = ciphertext.count + kCCBlockSizeAES128
        let decryptedDataBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: decryptedDataBufferSize)
        defer {
            decryptedDataBuffer.deallocate()
        }
        
        var numBytesDecrypted: size_t = 0
        
        // Decriptação com CommonCrypto usando o buffer alocado manualmente
        let cryptStatus = CCCrypt(
            CCOperation(kCCDecrypt),
            CCAlgorithm(kCCAlgorithmAES128),
            CCOptions(kCCOptionPKCS7Padding),
            keyData.withUnsafeBytes { $0.baseAddress },
            kCCKeySizeAES256,
            iv.withUnsafeBytes { $0.baseAddress },
            ciphertext.withUnsafeBytes { $0.baseAddress }, ciphertext.count,
            decryptedDataBuffer, decryptedDataBufferSize,
            &numBytesDecrypted
        )
        
        guard cryptStatus == kCCSuccess else {
            print("Decryption failed with status: \(cryptStatus)")
            return nil
        }
        
        // Cria um Data com o conteúdo desencriptado
        let decryptedData = Data(bytes: decryptedDataBuffer, count: numBytesDecrypted)
        
        // Converte o buffer de dados desencriptados para uma string UTF-8
        return String(data: decryptedData, encoding: .utf8)
    }
#endif
}


public extension Character {
    func unicodeScalarCodePoint() -> UInt32 {
        let characterString = String(self)
        let scalars = characterString.unicodeScalars
        
        return scalars[scalars.startIndex].value
    }
}
