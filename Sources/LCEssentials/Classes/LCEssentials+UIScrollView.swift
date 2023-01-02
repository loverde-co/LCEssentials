//  
// Copyright (c) 2020 Loverde Co.
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
 

#if canImport(UIKit) && !os(watchOS)
import UIKit

// MARK: - Methods
public extension UIScrollView {

    /// Takes a snapshot of an entire ScrollView
    ///
    ///    AnySubclassOfUIScroolView().snapshot
    ///    UITableView().snapshot
    ///
    /// - Returns: Snapshot as UIimage for rendered ScrollView
    var snapshot: UIImage? {
        // Original Source: https://gist.github.com/thestoics/1204051
        UIGraphicsBeginImageContextWithOptions(contentSize, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        let previousFrame = frame
        frame = CGRect(origin: frame.origin, size: contentSize)
        layer.render(in: context)
        frame = previousFrame
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    var offsetInPage: CGFloat {
        let page = contentOffset.y / frame.size.height
        return page - floor(page)
    }
    
    func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: true)
    }
    
    func screenshot() -> UIImage? {
        let savedContentOffset = contentOffset
        let savedFrame = frame
        
        UIGraphicsBeginImageContext(contentSize)
        contentOffset = .zero
        frame = CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height)
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        contentOffset = savedContentOffset
        frame = savedFrame
        
        return image
    }
    
    func scrollToBottom(animated: Bool) {
         if self.contentSize.height < self.bounds.size.height { return }
         let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height)
         self.setContentOffset(bottomOffset, animated: animated)
      }
    
    func scrollToView(view: UIView, animated: Bool) {
        if let origin = view.superview {
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            self.scrollRectToVisible(CGRect(x: 0, y: childStartPoint.y, width: 1, height: self.frame.height), animated: animated)
        }
    }
}

#endif
