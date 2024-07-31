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
    
    enum orientation {
        case horizontal, vertical
    }

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
    
    /// The currently visible region of the scroll view.
    var visibleRect: CGRect {
        let contentWidth = contentSize.width - contentOffset.x
        let contentHeight = contentSize.height - contentOffset.y
        return CGRect(origin: contentOffset,
                      size: CGSize(width: min(min(bounds.size.width, contentSize.width), contentWidth),
                                   height: min(min(bounds.size.height, contentSize.height), contentHeight)))
    }
    
    var offsetInPage: CGFloat {
        let page = contentOffset.y / frame.size.height
        return page - floor(page)
    }
}

public extension UIScrollView {
    /// Scroll up one page of the scroll view.
    /// If `isPagingEnabled` is `true`, the previous page location is used.
    /// - Parameter animated: `true` to animate the transition at a constant velocity to the new offset, `false` to make
    /// the transition immediate.
    func scrollUp(animated: Bool = true) {
        let minY = -contentInset.top
        var y = max(minY, contentOffset.y - bounds.height)
        #if !os(tvOS)
        if isPagingEnabled,
           bounds.height != 0 {
            let page = max(0, ((y + contentInset.top) / bounds.height).rounded(.down))
            y = max(minY, page * bounds.height - contentInset.top)
        }
        #endif
        setContentOffset(CGPoint(x: contentOffset.x, y: y), animated: animated)
    }

    /// Scroll left one page of the scroll view.
    /// If `isPagingEnabled` is `true`, the previous page location is used.
    /// - Parameter animated: `true` to animate the transition at a constant velocity to the new offset, `false` to make
    /// the transition immediate.
    func scrollLeft(animated: Bool = true) {
        let minX = -contentInset.left
        var x = max(minX, contentOffset.x - bounds.width)
        #if !os(tvOS)
        if isPagingEnabled,
           bounds.width != 0 {
            let page = ((x + contentInset.left) / bounds.width).rounded(.down)
            x = max(minX, page * bounds.width - contentInset.left)
        }
        #endif
        setContentOffset(CGPoint(x: x, y: contentOffset.y), animated: animated)
    }

    /// Scroll down one page of the scroll view.
    /// If `isPagingEnabled` is `true`, the next page location is used.
    /// - Parameter animated: `true` to animate the transition at a constant velocity to the new offset, `false` to make
    /// the transition immediate.
    func scrollDown(animated: Bool = true) {
        let maxY = max(0, contentSize.height - bounds.height) + contentInset.bottom
        var y = min(maxY, contentOffset.y + bounds.height)
        #if !os(tvOS)
        if isPagingEnabled,
           bounds.height != 0 {
            let page = ((y + contentInset.top) / bounds.height).rounded(.down)
            y = min(maxY, page * bounds.height - contentInset.top)
        }
        #endif
        setContentOffset(CGPoint(x: contentOffset.x, y: y), animated: animated)
    }

    /// Scroll right one page of the scroll view.
    /// If `isPagingEnabled` is `true`, the next page location is used.
    /// - Parameter animated: `true` to animate the transition at a constant velocity to the new offset, `false` to make
    /// the transition immediate.
    func scrollRight(animated: Bool = true) {
        let maxX = max(0, contentSize.width - bounds.width) + contentInset.right
        var x = min(maxX, contentOffset.x + bounds.width)
        #if !os(tvOS)
        if isPagingEnabled,
           bounds.width != 0 {
            let page = ((x + contentInset.left) / bounds.width).rounded(.down)
            x = min(maxX, page * bounds.width - contentInset.left)
        }
        #endif
        setContentOffset(CGPoint(x: x, y: contentOffset.y), animated: animated)
    }
}
#endif
