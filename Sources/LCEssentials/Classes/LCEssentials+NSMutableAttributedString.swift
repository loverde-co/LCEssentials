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

public extension NSMutableAttributedString {
    @discardableResult func customize(_ text: String,
                                      withFont font: UIFont,
                                      color: UIColor? = nil,
                                      lineSpace: CGFloat? = nil,
                                      alignment: NSTextAlignment? = nil,
                                      changeCurrentText: Bool = false) -> NSMutableAttributedString {
        
        var attrs: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font]
        if color != nil {
            attrs[NSAttributedString.Key.foregroundColor] = color
        }
        if lineSpace != nil {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineSpace ?? 0
            attrs[NSAttributedString.Key.paragraphStyle] = paragraphStyle
        }
        
        if let alignment = alignment {
            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = alignment
            attrs[NSAttributedString.Key.paragraphStyle] = paragraph
        }

        if changeCurrentText {
            self.addAttributes(attrs, range: self.mutableString.range(of: text))
        } else {
            let customStr = NSMutableAttributedString(string: "\(text)", attributes: attrs)
            self.append(customStr)
        }
        return self
    }

    @discardableResult func underline(_ text: String,
                                      withFont font: UIFont,
                                      color: UIColor? = nil,
                                      changeCurrentText: Bool = false) -> NSMutableAttributedString {
        
        var attrs: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue as AnyObject,
            NSAttributedString.Key.font: font
        ]
        
        if color != nil {
            attrs[NSAttributedString.Key.foregroundColor] = color
        }
        
        if changeCurrentText {
            self.addAttributes(attrs, range: self.mutableString.range(of: text))
        } else {
            let customStr = NSMutableAttributedString(string: "\(text)", attributes: attrs)
            self.append(customStr)
        }
        return self
    }
    
    @discardableResult
    func strikethrough(_ text: String, changeCurrentText: Bool = false) -> Self {
        let attrs: [NSAttributedString.Key: Any] = [
            .strikethroughStyle: NSUnderlineStyle.single.rawValue,
        ]
        if changeCurrentText {
            self.addAttributes(attrs, range: self.mutableString.range(of: text))
        } else {
            let customStr = NSMutableAttributedString(string: "\(text)", attributes: attrs)
            self.append(customStr)
        }
        
        return self
    }

    @discardableResult func linkTouch(_ text: String,
                                      url: String, 
                                      withFont font: UIFont,
                                      color: UIColor = UIColor.blue,
                                      changeCurrentText: Bool = false) -> NSMutableAttributedString {
        
        let linkTerms: [NSAttributedString.Key: Any]  = [
            NSAttributedString.Key.link: NSURL(string: url) ?? NSURL(),
            NSAttributedString.Key.foregroundColor: color,
            NSAttributedString.Key.underlineColor: color,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.font: font
        ]
        
        if changeCurrentText {
            self.addAttributes(linkTerms, range: self.mutableString.range(of: text))
        } else {
            let customStr = NSMutableAttributedString(string: "\(text)", attributes: linkTerms)
            self.append(customStr)
        }
        return self
    }
    
    @discardableResult func supperscript(_ text: String,
                                         withFont font: UIFont,
                                         color: UIColor? = nil,
                                         offset: CGFloat,
                                         changeCurrentText: Bool = false) -> NSMutableAttributedString {
        
        var attrs: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.baselineOffset: offset,
            NSAttributedString.Key.font: font
        ]
        
        if color != nil {
            attrs[NSAttributedString.Key.foregroundColor] = color
        }
        
        if changeCurrentText {
            self.addAttributes(attrs, range: self.mutableString.range(of: text))
        } else {
            let customStr = NSMutableAttributedString(string: "\(text)", attributes: attrs)
            self.append(customStr)
        }
        return self
    }
    
    @discardableResult func appendImageToText(_ image: UIImage? = nil) -> NSMutableAttributedString {
        let imageAttach = NSTextAttachment()
        imageAttach.image = image
        
        let imgStr = NSAttributedString(attachment: imageAttach)
        
        append(imgStr)
        
        return self
    }
    
    func attributtedString() -> NSAttributedString {
        let range = self.string.range(of: self.string) ?? Range<String.Index>(uncheckedBounds: (self.string.startIndex, upper: self.string.endIndex))
        let nsRange = self.string.nsRange(from: range) ?? NSRange()
        return self.attributedSubstring(from: nsRange)
    }

    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let normal =  NSAttributedString(string: text)
        self.append(normal)
        return self
    }
    
    func canSetAsLink(textToFind: String, linkURL: String) -> Bool {
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(NSAttributedString.Key.link, value: linkURL, range: foundRange)
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
#endif
