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

public func insertBlurView (view: UIView, style: UIBlurEffectStyle) -> UIVisualEffectView {
    view.backgroundColor = UIColor.clear

    let blurEffect = UIBlurEffect(style: style)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = view.bounds
    view.insertSubview(blurEffectView, at: 0)
    return blurEffectView
}

public class UIViewWithShadow: UIViewCustom {
    private var shadowLayer: CAShapeLayer!
    //internal var cornerRadius: CGFloat = 25.0
    private var fillColor: UIColor = .white // the color applied to the shadowLayer, rather than the view's backgroundColor
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
            shadowLayer.fillColor = fillColor.cgColor
            
            shadowLayer.shadowColor = UIColor.black.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0.2, height: 2.0)
            shadowLayer.shadowOpacity = 0.8
            shadowLayer.shadowRadius = 2
            layer.masksToBounds = false
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
    
//    public func addShadowTo(shadowView: UIView, shadowWidth: CGFloat, shadowHeight: CGFloat){
//        let shadow = UIViewWithShadow()
//        let parent = shadowView.getParentViewController()
//        if let viewController = parent {
//            viewController.view.addSubview(shadowView)
//
//            // Auto layout code using anchors (iOS9+)
//            // set witdh and height constraints if necessary
//            shadow.translatesAutoresizingMaskIntoConstraints = false
//            let horizontalConstraint = shadow.centerXAnchor.constraint(equalTo: shadowView.centerXAnchor)
//            let verticalConstraint = shadow.centerYAnchor.constraint(equalTo: shadowView.centerYAnchor)
//            let widthConstraint = shadow.widthAnchor.constraint(equalToConstant: viewController.view.frame.size.width - shadowWidth)
//            let heightConstraint = shadow.heightAnchor.constraint(equalToConstant: shadowView.frame.size.height - shadowHeight)
//            NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
//            viewController.view.bringSubview(toFront: shadowView)
//        }else{
//            fatalError("Ops! There is no ViewController setted")
//        }
//    }
}
#endif
