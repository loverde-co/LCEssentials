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
public extension UIView {
    func addBorder(_ sides: [EnumBorderSide], color: UIColor, width: CGFloat) {
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

    func drawCircle(inCoord x: CGFloat, y: CGFloat, with radius: CGFloat, strokeColor:UIColor = UIColor.red, fillColor:UIColor = UIColor.gray, isEmpty: Bool = false) -> [String:Any] {
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
    
    func addShadow(shadowView: UIView, shadowWidth: CGFloat, shadowHeight: CGFloat){
        let shadow = UIViewWithShadow()
        self.addSubview(shadowView)
        
        // Auto layout code using anchors (iOS9+)
        // set witdh and height constraints if necessary
        shadow.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = shadow.centerXAnchor.constraint(equalTo: shadowView.centerXAnchor)
        let verticalConstraint = shadow.centerYAnchor.constraint(equalTo: shadowView.centerYAnchor)
        let widthConstraint = shadow.widthAnchor.constraint(equalToConstant: self.frame.size.width - shadowWidth)
        let heightConstraint = shadow.heightAnchor.constraint(equalToConstant: shadowView.frame.size.height - shadowHeight)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        self.bringSubview(toFront: shadowView)
    }

    /**
     Fade in a view with a duration

     - parameter duration: custom animation duration
     */
    func fadeIn(withDuration duration: TimeInterval = 1.0, withDelay delay: TimeInterval = 0, completionHandler:@escaping (Bool) -> ()) {
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
    func fadeOut(withDuration duration: TimeInterval = 1.0, withDelay delay: TimeInterval = 0, completionHandler:@escaping (Bool) -> ()) {
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
    func setX(x:CGFloat) {
        var frame:CGRect = self.frame
        frame.origin.x = x
        self.frame = frame
    }
    /**
     Set y Position

     :param: y CGFloat
     by DaRk-_-D0G
     */
    func setY(y:CGFloat) {
        var frame:CGRect = self.frame
        frame.origin.y = y
        self.frame = frame
    }
    /**
     Set Width

     :param: width CGFloat
     */
    func setWidth(width:CGFloat) {
        var frame:CGRect = self.frame
        frame.size.width = width
        self.frame = frame
    }
    /**
     Set Height

     :param: height CGFloat
     */
    func setHeight(height:CGFloat) {
        var frame:CGRect = self.frame
        frame.size.height = height
        self.frame = frame
    }
    
    // - LoverdeCo: Add radius to view
    //
    //
    func setRadius(top: Bool, bottom: Bool, radius: CGFloat = 8){
        var maskCorns: CACornerMask = []
        var path: UIBezierPath!
        if top && bottom {
            maskCorns = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            path = UIBezierPath(roundedRect: (self.bounds),
                                byRoundingCorners: [.topRight, .topLeft, .bottomLeft, .bottomRight],
                                cornerRadii: CGSize(width: radius, height: radius))
        }else if top && !bottom {
            maskCorns = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            path = UIBezierPath(roundedRect: (self.bounds),
                                byRoundingCorners: [.topRight, .topLeft],
                                cornerRadii: CGSize(width: radius, height: radius))
        }else if bottom && !top {
            maskCorns = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            path = UIBezierPath(roundedRect: (self.bounds),
                                byRoundingCorners: [.bottomLeft, .bottomRight],
                                cornerRadii: CGSize(width: radius, height: radius))
            
        }
        if #available(iOS 11.0, *) {
            self.clipsToBounds = true
            self.layer.cornerRadius = radius
            self.layer.maskedCorners = maskCorns
        } else {
            self.clipsToBounds = true
            let maskLayer = CAShapeLayer()
            
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
        }
    }
    
    
}
#endif

