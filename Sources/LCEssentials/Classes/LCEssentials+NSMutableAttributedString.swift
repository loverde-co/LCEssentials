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
#if os(iOS) || os(macOS)
import UIKit

public enum AttributtedAlignment {
    case center, left, right
}

public extension NSMutableAttributedString {
    @discardableResult func customize(_ text:String, withFont fontName:String = "Helvetica Neue", size:CGFloat = 12, color:UIColor? = nil, lineSpace: CGFloat? = nil, alignment: AttributtedAlignment? = nil) -> NSMutableAttributedString {
        var attrs:[NSAttributedStringKey:Any] = [NSAttributedStringKey.font : UIFont(name: fontName, size: size)!]
        if color != nil {
            attrs[NSAttributedStringKey.foregroundColor] = color
        }
        if lineSpace != nil {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineSpace!
            attrs[NSAttributedStringKey.paragraphStyle] = paragraphStyle
        }
        
        if let alignment = alignment {
            let paragraph = NSMutableParagraphStyle()
            switch alignment {
                case .center:
                    paragraph.alignment = .center
                case .left:
                    paragraph.alignment = .left
                case .right:
                    paragraph.alignment = .right
            }
            attrs[NSAttributedStringKey.paragraphStyle] = paragraph
        }

        //let customStr = NSMutableAttributedString(string:"\(text)", attributes:attrs)
        self.addAttributes(attrs, range: self.mutableString.range(of: text))
        //self.append(customStr)
        return self
    }

    @discardableResult func bold(_ text:String, withFont fontName:String = "Helvetica Neue", size:CGFloat = 12, color:UIColor? = nil) -> NSMutableAttributedString {
        var attrs:[NSAttributedStringKey:Any] = [NSAttributedStringKey.font : UIFont(name: fontName, size: size)!]
        if color != nil {
            attrs[NSAttributedStringKey.foregroundColor] = color
        }
        //let boldString = NSMutableAttributedString(string:"\(text)", attributes:attrs)
        self.addAttributes(attrs, range: self.mutableString.range(of: text))
        //self.append(boldString)
        return self
    }

    @discardableResult func underline(_ text:String, withFont fontName:String = "Helvetica Neue", size:CGFloat = 12, color:UIColor? = nil) -> NSMutableAttributedString {
        var attrs:[NSAttributedStringKey:Any] = [NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue as AnyObject, NSAttributedStringKey.font : UIFont(name: fontName, size: size)!]
        if color != nil {
            attrs[NSAttributedStringKey.foregroundColor] = color
        }
        //let underString = NSMutableAttributedString(string: "\(text)", attributes:attrs)
        self.addAttributes(attrs, range: self.mutableString.range(of: text))
        //self.append(underString)
        return self
    }

    @discardableResult func linkTouch(_ text:String, url: String, withFont fontName:String = "Helvetica Neue", size:CGFloat = 12, color:UIColor = UIColor.blue) -> NSMutableAttributedString {
        let linkTerms:[NSAttributedStringKey: Any]  = [NSAttributedStringKey.link: NSURL(string: url)!,
                                                            NSAttributedStringKey.foregroundColor: color,
                                                            NSAttributedStringKey.underlineColor: color,
                                                            NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue,
                                                            NSAttributedStringKey.font: UIFont(name: fontName, size: size)!]
        //let linkString = NSMutableAttributedString(string: "\(text)", attributes:linkTerms)
        self.setAttributes(linkTerms, range: self.mutableString.range(of: text))
        //self.append(linkString)
        return self
    }
    
    @discardableResult func supperscript(_ text:String, withFont fontName:String = "Helvetica Neue", size:CGFloat = 12, color:UIColor? = nil, offset: CGFloat) -> NSMutableAttributedString {
        var attrs:[NSAttributedStringKey:Any] = [NSAttributedStringKey.baselineOffset: offset, NSAttributedStringKey.font : UIFont(name: fontName, size: size)!]
        if color != nil {
            attrs[NSAttributedStringKey.foregroundColor] = color
        }
        //let underString = NSMutableAttributedString(string: "\(text)", attributes:attrs)
        self.addAttributes(attrs, range: self.mutableString.range(of: text))
        //self.append(underString)
        return self
    }
    
    func makeAttributted(){
        self.append(self)
    }

    @discardableResult func normal(_ text:String)->NSMutableAttributedString {
        let normal =  NSAttributedString(string: text)
        self.append(normal)
        return self
    }

    func setAsLink(textToFind:String, linkURL:String) -> Bool {

        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(NSAttributedStringKey.link, value: linkURL, range: foundRange)
            return true
        }
        return false
    }

    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
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
#endif
