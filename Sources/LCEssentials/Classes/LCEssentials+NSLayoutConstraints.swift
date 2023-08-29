//  
// Copyright (c) 2023 Loverde Co.
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

extension NSLayoutConstraint {
    
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        guard let first = firstItem else { return NSLayoutConstraint() }
        return NSLayoutConstraint(item: first,
                                  attribute: self.firstAttribute,
                                  relatedBy: self.relation,
                                  toItem: self.secondItem,
                                  attribute: self.secondAttribute,
                                  multiplier: multiplier,
                                  constant: self.constant)
    }
    
    func matches(view: UIView, anchor: NSLayoutYAxisAnchor) -> Bool {
        if let firstView = firstItem as? UIView,
            firstView == view && firstAnchor == anchor {
            return true
        }
        if let secondView = secondItem as? UIView,
            secondView == view && secondAnchor == anchor {
            return true
        }
        return false
    }
    
    func matches(view: UIView, anchor: NSLayoutXAxisAnchor) -> Bool {
        if let firstView = firstItem as? UIView,
            firstView == view && firstAnchor == anchor {
            return true
        }
        if let secondView = secondItem as? UIView,
            secondView == view && secondAnchor == anchor {
            return true
        }
        return false
    }
    
    func matches(view: UIView, anchor: NSLayoutDimension) -> Bool {
        if let firstView = firstItem as? UIView,
            firstView == view && firstAnchor == anchor {
            return true
        }
        if let secondView = secondItem as? UIView,
            secondView == view && secondAnchor == anchor {
            return true
        }
        return false
    }
}
