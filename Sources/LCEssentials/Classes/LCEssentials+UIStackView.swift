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
 

import Foundation
import UIKit
#if os(iOS)

// MARK: - Initializers
@available(iOS 9.0, *)
public extension UIStackView {
    
    convenience init(arrangedSubviews: [UIView]? = nil,
                     axis: NSLayoutConstraint.Axis = .vertical,
                     spacing: CGFloat = 0.0,
                     alignment: UIStackView.Alignment = .fill,
                     distribution: UIStackView.Distribution = .fill,
                     layoutMargins: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
                     isMarginsRelative: Bool = true) {
        
        if let arrangedSubviews = arrangedSubviews {
            self.init(arrangedSubviews: arrangedSubviews)
        } else {
            self.init()
        }
        self.axis = axis
        self.spacing = spacing
        self.alignment = alignment
        self.distribution = distribution
        self.layoutMargins = layoutMargins
        self.isLayoutMarginsRelativeArrangement = isMarginsRelative
    }
    
    func addArrangedSubviews(_ views: [UIView], translateAutoresizing: Bool = false) {
        views.forEach { subview in
            addArrangedSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = translateAutoresizing
        }
    }
    
    func removeAllArrangedSubviews(deactivateConstraints: Bool = true) {
        arrangedSubviews.forEach {
            removeSubview(view: $0, deactivateConstraints: deactivateConstraints)
        }
    }
    
    /// Remove specific view from it
    ///
    /// - Parameter view: view to be removed.
    func removeSubview(view: UIView, deactivateConstraints: Bool = true) {
        removeArrangedSubview(view)
        if deactivateConstraints {
            NSLayoutConstraint.deactivate(view.constraints)
        }
        view.removeFromSuperview()
    }

    private func addSpace(height: CGFloat? = nil, width: CGFloat? = nil, backgroundColor: UIColor = .clear) {
        let spaceView = UIView()
        spaceView.backgroundColor = backgroundColor
        spaceView.translatesAutoresizingMaskIntoConstraints = false
        if let height = height {
            spaceView.setHeight(size: height)
        }
        if let width = width {
            spaceView.setWidth(size: width)
        }
        addArrangedSubview(spaceView)
    }
    
    func addSpace(_ size: CGFloat, backgroundColor: UIColor = .clear) {
        switch self.axis {
        case .vertical:
            addSpace(height: size, backgroundColor: backgroundColor)
        case .horizontal:
            addSpace(width: size, backgroundColor: backgroundColor)
        default: break
        }
    }
}
#endif
