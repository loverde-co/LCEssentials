//  
// Copyright (c) 2018 Loverde Co.
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

public extension String {

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
    

    //    func md5(_ string: String) -> String {
    //        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
    //        if let data = string.data(using: String.Encoding.utf8) {
    //            CC_MD5((data as NSData).bytes, CC_LONG(data.count), &digest)
    //        }
    //
    //        var digestHex = ""
    //        for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
    //            digestHex += String(format: "%02x", digest[index])
    //        }
    //
    //        return digestHex
    //        //Test:
    //        //let digest = md5(string:"Hello")
    //        //print("digest: \(digest)")
    //    }

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
    ///   - receivedFormatt: Give a input formatt as it comes in String.
    ///   - Returns: Date object.
    func convertToDate(receivedFormatt: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: self)
    }
    
    @available(*, deprecated, message: "This will be removed on 0.4.* version of this repository")
    func dateTimeToString( _ dateTime: Date, withHour: Bool = false, returnOnlyTime:Bool = false ) -> String {

        let dateformatter = DateFormatter()
        dateformatter.timeZone = TimeZone(abbreviation: "GMT")
        if returnOnlyTime {
            dateformatter.dateFormat = "HH:mm:ss"
        }else{
            dateformatter.dateFormat = "yyyy-MM-dd\( withHour ? " HH:mm:ss" : "" )"
        }
        return dateformatter.string(from: dateTime)
    }
    
    /// LoverdeCo: String BR formatted to String object.
    ///
    /// - Parameters:
    ///   - fromFormat: Give a input formatt as it comes in String.
    ///   - toFormat: to DataBase SQL formatt
    ///   - Returns: String.
    func dateDataBaseConverter(fromFormat:String = "dd/MM/yyyy", toFormat: String = "yyyy-MM-dd") -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = fromFormat
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = toFormat
        return  dateFormatter.string(from: date!)
    }
    
    /// LoverdeCo: String to Date object.
    ///
    /// - Parameters:
    ///   - withFormatt: Give a input formatt as it comes in String.
    ///   - useHour: Add or remove hour form String given date
    ///   - Returns: Date object.
    func toDateFormat(withFormatt: String = "yyyy-MM-dd HH:mm:ss", useHour: Bool = false) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.default
        dateFormatter.locale = Calendar.current.locale
        var formatt = withFormatt
        if useHour {
            formatt = String(formatt.dropLast(9))
        }
        dateFormatter.dateFormat = formatt
        return dateFormatter.date(from: self)
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
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)

        return ceil(boundingBox.width)
    }

    func encodeImageToBase64(refImage: UIImage) -> String{
        let jpegCompressionQuality: CGFloat = 0.6
        if let base64String = UIImageJPEGRepresentation(refImage, jpegCompressionQuality){
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
    /**
     Truncates the string to the specified length number of characters and appends an optional trailing string if longer.

     - Parameter length: A `String`.
     - Parameter trailing: A `String` that will be appended after the truncation.

     - Returns: A `String` object.
     */
    // Example
    // let str = "This is a long string".truncate(10, trailing: "...") // "This is a ..."
    func truncate(length: Int, trailing: String = "…") -> String {
        if self.count > length {
            return String(self.prefix(length)) + trailing
        } else {
            return self
        }
    }
    func replacing(range: CountableClosedRange<Int>, with replacementString: String) -> String {
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end   = index(start, offsetBy: range.count)
        return self.replacingCharacters(in: start ..< end, with: replacementString)
    }

    //
    //Usage Example: label.text = yourString.html2String
    //
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
    
    @available(*, deprecated, message: "This will be removed on 0.4.* version of this repository")
    func dictionaryToStringJSON(dict:[String:Any]) -> String {
        let jsonData = try! JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        return jsonString
    }
    
    @available(*, deprecated, message: "This will be removed on 0.4.* version of this repository")
    func JSONStringToDictionary() -> [String:Any]? {
        if let data = self.data(using: .utf8) {
            let jsonString = try? JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            return jsonString
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
    //    print(price.currencyUS)  // "$1.99\n"
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
            
            if let indexOfSymbol = amountString.index(of: Character(currencyFormatter.currencySymbol)) {
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
    func textWithoutFormat() -> String {
        return (self
            .replacingOccurrences(of: "+", with: "")
            .replacingOccurrences(of: ".", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: ",", with: "")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: " ", with: ""))
    }
    func formattedNumber(mask:String = "XXXXX-XXXX", number: String) -> String {
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()

        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask {
            if index == cleanPhoneNumber.endIndex {
                break
            }
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
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
