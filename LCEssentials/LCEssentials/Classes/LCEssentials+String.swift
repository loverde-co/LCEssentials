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

    public var isEmailValid: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
        } catch {
            return false
        }
    }
    public var currentTimeZone : String {
        let date = NSDate();
        let formatter = DateFormatter();
        formatter.dateFormat = "ZZZ";
        let defaultTimeZoneStr = formatter.string(from: date as Date);

        return defaultTimeZoneStr;
    }

    public func nsRange(from range: Range<String.Index>) -> NSRange? {
        let utf16view = self.utf16
        if let from = range.lowerBound.samePosition(in: utf16view), let to = range.upperBound.samePosition(in: utf16view) {
            return NSMakeRange(utf16view.distance(from: utf16view.startIndex, to: from), utf16view.distance(from: from, to: to))
        }
        return nil
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

    public func randomString(length: Int) -> String {

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

    public func stringFromTimeInterval(_ interval:TimeInterval) -> NSString {

        let ti = NSInteger(interval)

        let ms = Int((interval.truncatingRemainder(dividingBy: 1)) * 1000)

        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)

        return NSString(format: "%0.2d:%0.2d:%0.2d.%0.3d",hours,minutes,seconds,ms)
    }

    public func dateTimeToString( _ dateTime: Date, withHour: Bool = false, returnOnlyTime:Bool = false ) -> String {

        let dateformatter = DateFormatter()
        dateformatter.timeZone = TimeZone(abbreviation: "GMT")
        if returnOnlyTime {
            dateformatter.dateFormat = "HH:mm:ss"
        }else{
            dateformatter.dateFormat = "yyyy-MM-dd\( withHour ? " HH:mm:ss" : "" )"
        }
        return dateformatter.string(from: dateTime)
    }

    public func dateTimeToStringBR( _ dateTime: Date, withHour:Bool = false ) -> String {

        let dateformatter = DateFormatter()
        dateformatter.timeZone = TimeZone(abbreviation: "GMT")

        dateformatter.dateFormat = "dd/MM/yyyy\( withHour ? " HH:mm:ss" : "" )"

        return dateformatter.string(from: dateTime)
    }

    //    func stringFromDate(withDate date: Date, zeroHour no: Bool = false){
    //        let dateformatter = DateFormatter()
    //        dateformatter.timeZone = TimeZone(abbreviation: "UTC")
    //        dateformatter.dateFormat = "yyyy-MM-dd\( withHour ? " HH:mm:ss" : "" )"
    //
    //    }

    public func dateDataBaseConverter(fromFormat:String = "dd/MM/yyyy", toFormat: String = "yyyy-MM-dd") -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = fromFormat
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = toFormat
        return  dateFormatter.string(from: date!)
    }

    public var first: String {
        return String(prefix(1))
    }
    public var last: String {
        return String(suffix(1))
    }
    public var uppercaseFirst: String {
        return first.uppercased() + String(dropFirst())
    }

    public func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)

        return ceil(boundingBox.height)
    }

    public func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)

        return ceil(boundingBox.width)
    }

    public func encodeImageToBase64(refImage: UIImage) -> String{
        let jpegCompressionQuality: CGFloat = 0.6
        if let base64String = UIImageJPEGRepresentation(refImage, jpegCompressionQuality){
            let strBase64 = base64String.base64EncodedString(options: .endLineWithLineFeed)
            return strBase64
        }
        return ""
    }

    public func exponentize(str: String) -> String {

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
    public func truncate(length: Int, trailing: String = "…") -> String {
        if self.count > length {
            return String(self.prefix(length)) + trailing
        } else {
            return self
        }
    }
    public func replacing(range: CountableClosedRange<Int>, with replacementString: String) -> String {
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end   = index(start, offsetBy: range.count)
        return self.replacingCharacters(in: start ..< end, with: replacementString)
    }

    //
    //Usage Example: label.text = yourString.html2String
    //
    public var html2AttributedString: NSAttributedString? {
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
    public var html2String: String {
        return html2AttributedString?.string ?? ""
    }

    public func dictionaryToStringJSON(dict:[String:Any]) -> String {
        let jsonData = try! JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        return jsonString
    }

    public func JSONStringToDictionary() -> [String:Any]? {
        if let data = self.data(using: .utf8) {
            let jsonString = try? JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            return jsonString
        }else{
            return nil
        }
    }

    public func convertFloatToBRL(value: Float) -> String{

        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = NumberFormatter.Style.currency
        // localize to your grouping and decimal separator
        currencyFormatter.locale = NSLocale.current
        let priceString = currencyFormatter.string(from: NSNumber(value: value))

        return priceString!
    }
    public func toURL() -> NSURL? {
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
}
