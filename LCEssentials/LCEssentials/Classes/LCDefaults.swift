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
import UIKit
import AVFoundation


precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
infix operator ^^ : PowerPrecedence
func ^^ (radix: Float, power: Float) -> Float {
    return Float(pow(Double(radix), Double(power)))
}

public enum EnumBorderSide {
    case top, bottom, left, right
}

public struct Defaults {
    static let DEFAULT_ERROR_DOMAIN = "LoverdeCoErrorDomain"
    static let DEFAULT_ERROR_CODE = -99
    static let DEFAULT_ERROR_MSG = "Error Unknow"
    static let IS_PROD = false
    #if targetEnvironment(simulator)
    static let DEVICE_IS_SIMULATOR = true
    #else
    static let DEVICE_IS_SIMULATOR = false
    #endif
    static let DEVICE_NAME: String = UIDevice().modelName
    static let OLDER_DEVICES: Bool = (DEVICE_NAME == "iPhone 5" || DEVICE_NAME == "iPhone 5c" || DEVICE_NAME == "iPhone 5s" || DEVICE_NAME == "iPhone 4" || DEVICE_NAME == "iPhone 4s") ? true : false

    public init(){}
    
    // MARK: - Background Thread
    public func backgroundThread(delay: Double = 0.0, background: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global().async {
            if(background != nil){ background!(); }

            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                if(completion != nil){ completion!(); }
            }
        }
    }
    
    //MARK: - Set Root View Controller
    public func setRootViewControllerWithAnimation(fromView from: UIView, toViewController to: UIViewController, duration: TimeInterval = 0.6, options: UIViewAnimationOptions, completion: (() -> Void)? = nil) {

        let appDelegate = UIApplication.shared.delegate

        UIView.transition(from: from, to: to.view, duration: duration, options: options, completion: {
            _ in
            appDelegate?.window??.rootViewController = to
            if( completion != nil ){ completion!() }
        })
    }

    //MARK: - Instance View Controllers Thru Storyboard
    public func instanceViewController(_ storyBoardName:String = "Intro", withIdentifier: String = "mainIntro" ) -> UIViewController {
        return UIStoryboard(name: storyBoardName, bundle: nil).instantiateViewController(withIdentifier: withIdentifier)
    }
    
    public func returnBetweenDate(startDate: Date, endDate: Date, years:Bool = false, months:Bool = false,  days:Bool = false) -> Int {

        let calendar = NSCalendar.current

        var components: DateComponents!

        if years {
            components = calendar.dateComponents( [.year], from: startDate, to: endDate)
            return components.year!
        }else if months {
            components = calendar.dateComponents( [.month], from: startDate, to: endDate)
            return components.month!
        }else{
            components = calendar.dateComponents( [.day], from: startDate, to: endDate)
            return components.day!
        }
    }

    public func printLog(section:String, description:String){
        print("\n\n[\(section)] \(description)")
    }
}


// MARK: - Extensions
extension UINavigationController {
    //Same function as "popViewController", but allow us to know when this function ends
    public func popViewControllerWithHandler(completion: @escaping ()->()) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.popViewController(animated: true)
        CATransaction.commit()
    }
    public func pushViewController(viewController: UIViewController, completion: @escaping ()->()) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.pushViewController(viewController, animated: true)
        CATransaction.commit()
    }
}

extension UIView {
    public func addBorder(_ sides: [EnumBorderSide], color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        for side in sides
        {
            switch side {
            case .top:
                border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
            case .bottom:
                border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
            case .left:
                border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
            case .right:
                border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
            }
            
            self.layer.addSublayer(border)
        }
    }
    
    public func drawCircle(inCoord x: CGFloat, y: CGFloat, with radius: CGFloat, strokeColor:UIColor = UIColor.red, fillColor:UIColor = UIColor.gray, isEmpty: Bool = false) -> [String:Any] {
        let dotPath = UIBezierPath(ovalIn: CGRect(x: x,y: y, width: radius, height: radius))
        let layer = CAShapeLayer()
        if !isEmpty {
            layer.path = dotPath.cgPath
            layer.strokeColor = strokeColor.cgColor
            layer.fillColor = fillColor.cgColor
            self.layer.addSublayer(layer)
        }
        return ["path":dotPath,"layer":layer]
    }
    
    /**
     Fade in a view with a duration
     
     - parameter duration: custom animation duration
     */
    public func fadeIn(withDuration duration: TimeInterval = 1.0, withDelay delay: TimeInterval = 0, completionHandler:@escaping (Bool) -> ()) {
        UIView.animate(withDuration: duration, delay: delay, options: [], animations: {
            self.alpha = 1.0
        }) { (finished) in
            completionHandler(true)
        }
    }
    
    /**
     Fade out a view with a duration
     
     - parameter duration: custom animation duration
     */
    public func fadeOut(withDuration duration: TimeInterval = 1.0, withDelay delay: TimeInterval = 0, completionHandler:@escaping (Bool) -> ()) {
        UIView.animate(withDuration: duration, delay: delay, options: [], animations: {
            self.alpha = 0.0
        }) { (finished) in
            completionHandler(true)
        }
    }
    
    /**
     Set x Position
     
     :param: x CGFloat
     */
    public func setX(x:CGFloat) {
        var frame:CGRect = self.frame
        frame.origin.x = x
        self.frame = frame
    }
    /**
     Set y Position

     :param: y CGFloat
     by DaRk-_-D0G
     */
    public func setY(y:CGFloat) {
        var frame:CGRect = self.frame
        frame.origin.y = y
        self.frame = frame
    }
    /**
     Set Width

     :param: width CGFloat
     */
    public func setWidth(width:CGFloat) {
        var frame:CGRect = self.frame
        frame.size.width = width
        self.frame = frame
    }
    /**
     Set Height

     :param: height CGFloat
     */
    public func setHeight(height:CGFloat) {
        var frame:CGRect = self.frame
        frame.size.height = height
        self.frame = frame
    }
}

extension UIImage {
    //Extension Required by RoundedButton to create UIImage from UIColor
    class public func imageWithColor(color: UIColor) -> UIImage {
        let rect: CGRect = CGRect(origin: .zero, size: CGSize(width: 1, height: 1))
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), false, 1.0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    /// Creates a circular outline image.
    class public func outlinedEllipse(size: CGSize, color: UIColor, lineWidth: CGFloat = 1.0) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        context.setStrokeColor(color.cgColor)
        context.setLineWidth(lineWidth)
        // Inset the rect to account for the fact that strokes are
        // centred on the bounds of the shape.
        let rect = CGRect(origin: .zero, size: size).insetBy(dx: lineWidth * 0.5, dy: lineWidth * 0.5)
        context.addEllipse(in: rect)
        context.strokePath()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    public func resizeImage(newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    public func decodeBase64ToImage(stringBase64:String) -> UIImage {
        let imageData = Data(base64Encoded: stringBase64, options: .ignoreUnknownCharacters)
        return UIImage(data: imageData!)!
    }
}

extension UIImageView {
    
    public func changeColorOfImage( _ color: UIColor, image: NSString ) -> UIImageView {
        
        let origImage   = UIImage(named: image as String);
        let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        self.image      = tintedImage
        self.tintColor  = color
        return self
    }
    
    public func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit, completion:@escaping (Bool?)->()) -> () {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
                print("Acabou ???")
                completion(true)
            }
            }.resume()
    }
    // EXAMPLE USAGE
    // imageView.downloadedFrom(link: "http://www.apple.com/euro/ios/ios8/a/generic/images/og.png")
    
    public func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit, completion:@escaping (Bool?)->()) -> () {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode) { (success) in
            completion(true)
        }
    }
}

extension UITextField {
    
    
}

extension UILabel {
    func boldSubstring(search:String){
        
    }
    
    public func lineNumbers() -> Int{
        let textSize = CGSize(width: self.frame.size.width, height: CGFloat(Float.infinity))
        let rHeight = lroundf(Float(self.sizeThatFits(textSize).height))
        let charSize = lroundf(Float(self.font.lineHeight))
        let lineCount = rHeight/charSize
        return lineCount
    }
    
    
    
}
extension NSMutableAttributedString {
    @discardableResult func customize(_ text:String, withFont fontName:String = "Helvetica Neue", size:CGFloat = 12, color:UIColor? = nil, lineSpace: CGFloat? = nil) -> NSMutableAttributedString {
        var attrs:[NSAttributedStringKey:AnyObject] = [NSAttributedStringKey.font : UIFont(name: fontName, size: size)!]
        if color != nil {
            attrs[NSAttributedStringKey.foregroundColor] = color
        }
        if lineSpace != nil {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineSpace!
            attrs[NSAttributedStringKey.paragraphStyle] = paragraphStyle
        }
        
        let customStr = NSMutableAttributedString(string:"\(text)", attributes:attrs)
        self.append(customStr)
        return self
    }
    
    //    let attributedString = NSMutableAttributedString(string: "Your text")
    //
    //    // *** Create instance of `NSMutableParagraphStyle`
    //    let paragraphStyle = NSMutableParagraphStyle()
    //
    //    // *** set LineSpacing property in points ***
    //    paragraphStyle.lineSpacing = 2 // Whatever line spacing you want in points
    //
    //    // *** Apply attribute to string ***
    //    attributedString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
    //
    //    // *** Set Attributed String to your label ***
    //    label.attributedText = attributedString;
    
    @discardableResult public func bold(_ text:String, withFont fontName:String = "Helvetica Neue", size:CGFloat = 12, color:UIColor? = nil) -> NSMutableAttributedString {
        var attrs:[NSAttributedStringKey:AnyObject] = [NSAttributedStringKey.font : UIFont(name: fontName, size: size)!]
        if color != nil {
            attrs[NSAttributedStringKey.foregroundColor] = color
        }
        let boldString = NSMutableAttributedString(string:"\(text)", attributes:attrs)
        self.append(boldString)
        return self
    }
    
    @discardableResult public func underline(_ text:String, withFont fontName:String = "Helvetica Neue", size:CGFloat = 12, color:UIColor? = nil) -> NSMutableAttributedString {
        var attrs:[NSAttributedStringKey:AnyObject] = [NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue as AnyObject, NSAttributedStringKey.font : UIFont(name: fontName, size: size)!]
        if color != nil {
            attrs[NSAttributedStringKey.foregroundColor] = color
        }
        let underString = NSMutableAttributedString(string: "\(text)", attributes:attrs)
        self.append(underString)
        return self
    }
    
    @discardableResult public func linkTouch(_ text:String, url: String, withFont fontName:String = "Helvetica Neue", size:CGFloat = 12, color:UIColor = UIColor.blue) -> NSMutableAttributedString {
        let linkTerms:[NSAttributedStringKey:AnyObject]  = [NSAttributedStringKey.link: NSURL(string: url)!, NSAttributedStringKey.foregroundColor: color, NSAttributedStringKey.font: UIFont(name: fontName, size: size)!]
        let linkString = NSMutableAttributedString(string: "\(text)", attributes:linkTerms)
        self.append(linkString)
        return self
    }
    
    @discardableResult public func normal(_ text:String)->NSMutableAttributedString {
        let normal =  NSAttributedString(string: text)
        self.append(normal)
        return self
    }
    
    public func setAsLink(textToFind:String, linkURL:String) -> Bool {
        
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(NSAttributedStringKey.link, value: linkURL, range: foundRange)
            return true
        }
        return false
    }
    
    public func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.height)
    }
    
    public func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.width)
    }
}
//MARK: - Label or TextField Font Bold Usage
//let formattedString = NSMutableAttributedString()
//formattedString
//    .bold("Bold Text")
//    .normal(" Normal Text ")
//    .bold("Bold Text")
//
//let lbl = UILabel()
//lbl.attributedText = formattedString
//MARK: - Label or TextField link usage
//let attributedString = NSMutableAttributedString(string:"I love stackoverflow!")
//let linkWasSet = attributedString.setAsLink("stackoverflow", linkURL: "http://stackoverflow.com")
//
//if linkWasSet {
//    // adjust more attributedString properties
//    // Dont open here, cause crash
//}
extension UIButton {
    
    
}

extension UITabBarController {
    
    public func setBadges(badgeValues: [Int]) {

        for view in self.tabBar.subviews {
            if view is CustomTabBadge {
                view.removeFromSuperview()
            }
        }

        for index in 0...badgeValues.count-1 {
            if badgeValues[index] != 0 {
                addBadge(index: index, value: badgeValues[index], color: .red, font: UIFont(name: "Helvetica-Light", size: 11)!)
            }
        }
    }

    public func addBadge(index: Int, value: Int, color: UIColor, font: UIFont) {
        let badgeView = CustomTabBadge()

        badgeView.clipsToBounds = true
        badgeView.textColor = UIColor.white
        badgeView.textAlignment = .center
        badgeView.font = font
        badgeView.text = String(value)
        badgeView.backgroundColor = color
        badgeView.tag = index
        tabBar.addSubview(badgeView)

        self.positionBadges()
    }

    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.positionBadges()
    }
    
    // Positioning
    public func positionBadges() {
        
        var tabbarButtons = self.tabBar.subviews.filter { (view: UIView) -> Bool in
            return view.isUserInteractionEnabled // only UITabBarButton are userInteractionEnabled
        }
        
        tabbarButtons = tabbarButtons.sorted(by: { $0.frame.origin.x < $1.frame.origin.x })
        
        for view in self.tabBar.subviews {
            if view is CustomTabBadge {
                let badgeView = view as! CustomTabBadge
                self.positionBadge(badgeView: badgeView, items:tabbarButtons, index: badgeView.tag)
            }
        }
    }
    
    public func positionBadge(badgeView: UIView, items: [UIView], index: Int) {
        
        let itemView = items[index]
        let center = itemView.center
        
        let xOffset: CGFloat = 10
        let yOffset: CGFloat = -14
        badgeView.frame.size = CGSize(width: 17, height: 17)
        badgeView.center = CGPoint(x: center.x + xOffset, y: center.y + yOffset)
        badgeView.layer.cornerRadius = badgeView.bounds.width/2
        tabBar.bringSubview(toFront: badgeView)
    }
}

extension UIColor{
    public func hexStringToUIColor( _ hex: String) -> UIColor {
        
        let hexString:NSString = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) as NSString
        let scanner            = Scanner(string: hexString as String)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color:UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1)
    }
}

extension String {
    
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
}

extension NSAttributedString {
    
    //Example Usage
    //
    //let attributedString = NSAttributedString(html: ""<html><body> Some html string </body></html>"")
    //myLabel.attributedText = attributedString
    
    internal convenience init?(html: String) {
        guard let data = html.data(using: String.Encoding.utf8, allowLossyConversion: false) else {
            return nil
        }
        let attributedOptions: [NSAttributedString.DocumentReadingOptionKey : Any] = [
            NSAttributedString.DocumentReadingOptionKey(rawValue: NSAttributedString.DocumentAttributeKey.documentType.rawValue): NSAttributedString.DocumentType.html,
            NSAttributedString.DocumentReadingOptionKey(rawValue: NSAttributedString.DocumentAttributeKey.characterEncoding.rawValue): String.Encoding.utf8.rawValue
        ]
        guard let attributedString = try? NSMutableAttributedString(data: data, options: attributedOptions, documentAttributes: nil) else {
            return nil
        }
        self.init(attributedString: attributedString)
    }
}

extension NSString {
    
    public func randomAlphaNumericString(_ length: Int = 8) -> String {
        
        let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let allowedCharsCount = UInt32(allowedChars.count)
        var randomString = ""
        
        for _ in (0..<length) {
            let randomNum = Int(arc4random_uniform(allowedCharsCount))
            let newCharacter = allowedChars[allowedChars.index(allowedChars.startIndex, offsetBy: randomNum)]
            randomString += String(newCharacter)
        }
        
        return randomString
    }
    
    public func removeCurrencyBRFormat(_ string:NSString) -> NSString {
        
        //let string       = "4567,89"
        var toArray         = string.components(separatedBy: "R$ ")
        var backToString    = toArray.joined(separator: "")
        toArray             = backToString.components(separatedBy: ".")
        backToString        = toArray.joined(separator: "")
        toArray             = backToString.components(separatedBy: ",")
        backToString        = toArray.joined(separator: ".")
        
        return backToString as NSString
    }
    
    public func createDirectory(_ directoryName: NSString) -> Bool {
        
        let documentsPath = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        let logsPath = documentsPath.appendingPathComponent(directoryName as String)
        do {
            try FileManager.default.createDirectory(atPath: logsPath.path, withIntermediateDirectories: true, attributes: nil)
            return true
        } catch let error as NSError {
            NSLog("Unable to create directory \(error.debugDescription)")
            return false
        }
        
        
    }
    
    
}

extension UITableViewCell {
    public func prepareDisclosureIndicator() {
        for case let button as UIButton in subviews {
            let image = button.backgroundImage(for: .normal)?.withRenderingMode(.
                alwaysTemplate)
            button.setBackgroundImage(image, for: .normal)
        }
    }
}

extension FileManager {
    
    public func createDirectory(_ directoryName: String) -> URL? {
        let fileManager = FileManager.default
        if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = documentDirectory.appendingPathComponent(directoryName)
            if !fileManager.fileExists(atPath: filePath.path) {
                do {
                    try fileManager.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    print(error.localizedDescription)
                    return nil
                }
            }
            return filePath
        } else {
            return nil
        }
    }
    
    public func saveFileToDirectory( _ sourceURL: URL, toPathURL: URL ) -> Bool {
        
        do {
            try FileManager.default.moveItem(at: sourceURL, to: toPathURL)
            return true
        } catch let error as NSError {
            print("Erro ao salvar o arquivo: \(error.localizedDescription)")
            return false
        }
    }
    
    public func saveImageToDirectory( _ imageWithPath : String, imagem : UIImage ) -> Bool {
        
        let data = UIImagePNGRepresentation(imagem)
        
        let success = (try? data!.write(to: URL(fileURLWithPath: imageWithPath), options: [])) != nil
        
        //let success = NSFileManager.defaultManager().createFileAtPath(imageWithPath, contents: data, attributes: nil)
        
        if success {
            return true
        } else {
            NSLog("Unable to create directory")
            return false
        }
    }
    
    public func retrieveFile( _ directoryAndFile: String ) -> URL {
        let documentsPath = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        let logsPath = documentsPath.appendingPathComponent(directoryAndFile)
        return logsPath
    }
    
    public func removeFile( _ directoryAndFile: String ) -> Bool {
        do {
            try self.removeItem(atPath: directoryAndFile)
            return true
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
            return false
        }
    }
    
    public func retrieveAllFilesFromDirectory(directoryName: String) -> [String]? {
        let fileMngr = FileManager.default;
        let docs = fileMngr.urls(for: .documentDirectory, in: .userDomainMask)[0].path
        do {
            var filelist = try fileMngr.contentsOfDirectory(atPath: "\(docs)/\(directoryName)")
            if filelist.contains(".DS_Store") {
                filelist.remove(at: filelist.index(of: ".DS_Store")!)
            }
            return filelist
        } catch let error {
            print("Error: \(error.localizedDescription)")
            return nil
        }
        //        let fileMngr = FileManager.default;
        //
        //        // Full path to documents directory
        //        let docs = fileMngr.urls(for: .documentDirectory, in: .userDomainMask)[0].path
        //
        //        let final = try? fileMngr.contentsOfDirectory(atPath:docs)
        //        print(final!.debugDescription)
        //
        //
        //        // List all contents of directory and return as [String] OR nil if failed
        //        return try? fileMngr.contentsOfDirectory(atPath:"\(docs)/\(directoryName)")
    }
    
    public func directoryExistsAtPath(_ path: String) -> Bool {
        var isDirectory = ObjCBool(true)
        let exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }
    
    public func convertToURL(path:String)-> URL?{
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path
        do {
            _ = try FileManager.default.contentsOfDirectory(atPath: "\(docs)/\(path)")
            return URL(fileURLWithPath: "\(docs)/\(path)", isDirectory: true)
        } catch let error {
            print("Error: \(error.localizedDescription)")
            return nil
        }
    }
}

extension Date {
    
    public func stringToDateTime( _ dateTime: String = "", formatted : String = "yyyy-MM-dd", withTime:Bool = false ) -> Date{
        var dateArray = dateTime.split{$0 == "/"}.map(String.init)
        var hour = [String]()
        var convertedDate = ""
        if dateArray.count > 1 {
            hour = dateArray[2].split{$0 == " "}.map(String.init)
            if hour.count > 1 {
                dateArray[2] = hour[0]
            }
            convertedDate = "\(dateArray[2])-\(dateArray[1])-\(dateArray[0])\( withTime ? " \(hour[1])" : "" )"
        }else{
            convertedDate = dateTime
        }
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "\(formatted)\( withTime ? " HH:mm:ss" : "" )"
        return dateFormatter.date(from: convertedDate)!
    }
    
    public func stringToDate( _ date: String = "2010-10-10", formatted : String = "yyyy-MM-dd" ) -> Date{
        let dateArray = date.split{$0 == "/"}.map(String.init)
        var convertedDate = ""
        if dateArray.count > 1 {
            convertedDate = "\(dateArray[2])-\(dateArray[1])-\(dateArray[0])"
        }else{
            convertedDate = date
        }
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = formatted
        return dateFormatter.date(from: convertedDate)!
    }
    
    /// Returns a Date with the specified days added to the one it is called with
    public func add(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date {
        var targetDay: Date
        targetDay = Calendar.current.date(byAdding: .year, value: years, to: self)!
        targetDay = Calendar.current.date(byAdding: .month, value: months, to: targetDay)!
        targetDay = Calendar.current.date(byAdding: .day, value: days, to: targetDay)!
        targetDay = Calendar.current.date(byAdding: .hour, value: hours, to: targetDay)!
        targetDay = Calendar.current.date(byAdding: .minute, value: minutes, to: targetDay)!
        targetDay = Calendar.current.date(byAdding: .second, value: seconds, to: targetDay)!
        return targetDay
    }
    
    /// Returns a Date with the specified days subtracted from the one it is called with
    public func subtract(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date {
        let inverseYears = -1 * years
        let inverseMonths = -1 * months
        let inverseDays = -1 * days
        let inverseHours = -1 * hours
        let inverseMinutes = -1 * minutes
        let inverseSeconds = -1 * seconds
        return add(years: inverseYears, months: inverseMonths, days: inverseDays, hours: inverseHours, minutes: inverseMinutes, seconds: inverseSeconds)
    }
    
    public func returnSunday(fromDate: Date) -> Date? {
        let gregorian = Calendar(identifier: .gregorian)
        if let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: fromDate)){
            //print(gregorian.date(byAdding: .day, value: 6, to: sunday)!)
            return sunday
        }else{ return nil }
    }
    
    public func getMonthName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        let strMonth = dateFormatter.string(from: self)
        return strMonth
    }
    
    public func getDayNumber() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        let strDay = dateFormatter.string(from: self)
        return strDay
    }
}

extension UITableView {
    public func reloadDataWithCompletion(_ completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion: { finished in
            completion()
        })
    }
}


public extension UIDevice {
    
    public var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        var identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 , value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        if Defaults.DEVICE_IS_SIMULATOR {
            // this neat trick is found at http://kelan.io/2015/easier-getenv-in-swift/
            if let dir = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
                identifier = dir
            }
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
}

//MARK: - UIResponder
extension UIResponder {
    public func getParentViewController() -> UIViewController? {
        if self.next is UIViewController {
            return self.next as? UIViewController
        } else {
            if self.next != nil {
                return (self.next!).getParentViewController()
            }
            else {return nil}
        }
    }
}
//HOW TO USE
//let vc = UIViewController()
//let view = UIView()
//vc.view.addSubview(view)
//view.getParentViewController() //provide reference to vc

extension Array where Element : Equatable {
    public var unique: [Element] {
        var uniqueValues: [Element] = []
        forEach { item in
            if !uniqueValues.contains(item) {
                uniqueValues += [item]
            }
        }
        return uniqueValues
    }
}
