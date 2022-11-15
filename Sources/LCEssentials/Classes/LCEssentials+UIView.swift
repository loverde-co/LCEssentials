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

typealias GradientPoints = (startPoint: CGPoint, endPoint: CGPoint)

public enum GradientOrientation {
    case topRightBottomLeft
    case topLeftBottomRight
    case horizontal
    case vertical

    var startPoint: CGPoint {
        return points.startPoint
    }

    var endPoint: CGPoint {
        return points.endPoint
    }

    var points: GradientPoints {
        switch self {
        case .topRightBottomLeft:
            return (CGPoint(x: 0.0, y: 1.0), CGPoint(x: 1.0, y: 0.0))
        case .topLeftBottomRight:
            return (CGPoint(x: 0.0, y: 0.0), CGPoint(x: 1, y: 1))
        case .horizontal:
            return (CGPoint(x: 0.0, y: 0.5), CGPoint(x: 1.0, y: 0.5))
        case .vertical:
            return (CGPoint(x: 0.0, y: 0.0), CGPoint(x: 0.0, y: 1.0))
        }
    }
}

public enum EnumBorderSide {
    case top, bottom, left, right
}

public extension UIView {
    
    enum AnchorType {
        case all
        case top
        case bottom
        case leading
        case trailing
        case heigth
        case width
        case centerX
        case centerY
        case bottomOf
        case leadingToTrailing
        case trailingToLeading
        case topGreaterThanOrEqualTo
        case bottomGreaterThanOrEqualTo
        case topToTopGreaterThanOrEqualTo
        case left
        case right
    }
    
    static var className: String {
        return String(describing: self)
    }
    
    var heightConstraint: NSLayoutConstraint? {
        get {
            return constraints.first(where: {
                $0.firstAttribute == .height && $0.relation == .equal
            })
        }
        set { setNeedsLayout() }
    }
    
    var widthConstraint: NSLayoutConstraint? {
        get {
            return constraints.first(where: {
                $0.firstAttribute == .width && $0.relation == .equal
            })
        }
        set { setNeedsLayout() }
    }

    var bottomConstraint: NSLayoutConstraint? {
        get {
            return constraints.first(where: {
                $0.firstAttribute == .bottom && $0.relation == .equal
            })
        }
        
        set { setNeedsLayout() }
    }
    
    var leadingConstraint: NSLayoutConstraint? {
        get {
            return constraints.first(where: {
                $0.firstAttribute == .leading && $0.relation == .equal
            })
        }
    }
    
    var trailingConstraints: NSLayoutConstraint? {
        get {
            return constraints.first(where: {
                $0.firstAttribute == .trailing && $0.relation == .equal
            })
        }
    }
    
    var globalPoint :CGPoint? {
       return self.superview?.convert(self.frame.origin, to: nil)
    }

    var globalFrame :CGRect? {
       return self.superview?.convert(self.frame, to: nil)
    }
    
    /// Loverde Co: Border color of view; also inspectable from Storyboard.
    var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            guard let color = newValue else {
                layer.borderColor = nil
                return
            }
            // Fix React-Native conflict issue
            guard String(describing: type(of: color)) != "__NSCFType" else { return }
            layer.borderColor = color.cgColor
        }
    }

    /// Loverde Co: Border width of view; also inspectable from Storyboard.
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    /// Loverde Co: Corner radius of view; also inspectable from Storyboard.
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.masksToBounds = true
            layer.cornerRadius = newValue
        }
    }

    /// Loverde Co: Check if view is in RTL format.
    var isRightToLeft: Bool {
        if #available(iOS 10.0, *, tvOS 10.0, *) {
            return effectiveUserInterfaceLayoutDirection == .rightToLeft
        } else {
            return false
        }
    }

    /// Loverde Co: Take screenshot of view (if applicable).
    var screenshot: UIImage? {
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /// Loverde Co: transform UIView to UIImage
    func asImage() -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContext(self.frame.size)
            self.layer.render(in:UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return UIImage(cgImage: image!.cgImage!)
        }
    }
    
    func copyElement<T: UIView>() -> T {
        return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as! T
    }
    
    func addSubview(_ subview: UIView, constraints: Bool = false) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = constraints
    }
    
    func addSubviews(_ subviews: [UIView], constraints: Bool = false) {
        for subview in subviews {
            addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = constraints
        }
    }
    
    @discardableResult
    func height(size: CGFloat) -> NSLayoutConstraint {
        
        let constraint: NSLayoutConstraint
        constraint = heightAnchor.constraint(equalToConstant: size)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func height(min: CGFloat) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint
        constraint = heightAnchor.constraint(greaterThanOrEqualToConstant: min)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func width(size: CGFloat) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint
        constraint = widthAnchor.constraint(equalToConstant: size)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func width(min: CGFloat) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint
        constraint = widthAnchor.constraint(greaterThanOrEqualToConstant: min)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func centerX(to: UIView, padding: CGFloat? = 0) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint
        constraint = centerXAnchor.constraint(equalTo: to.centerXAnchor, constant: padding ?? 0)
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func centerY(to: UIView, padding: CGFloat? = nil) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint
        constraint = centerYAnchor.constraint(equalTo: to.centerYAnchor, constant: padding ?? 0)
        constraint.isActive = true
        return constraint
    }
    
    static func instantiate(withNibName: String? = nil, owner: Any? = nil, options: [UINib.OptionsKey : Any]? = nil) -> [Any]? {
        var nibName = self.className
        if let settedNibName = withNibName {
            nibName = settedNibName
        }
        return Bundle.main.loadNibNamed(nibName, owner: owner, options: options)
    }
    
    func addBorders(for edges:[UIRectEdge] = [.all], width:CGFloat = 1, color: UIColor = .black) {
        if edges.contains(.all) {
            layer.borderWidth = width
            layer.borderColor = color.cgColor
        } else {
            let allSpecificBorders:[UIRectEdge] = [.top, .bottom, .left, .right]

            for edge in allSpecificBorders {
                if let v = viewWithTag(Int(edge.rawValue)) {
                    v.removeFromSuperview()
                }

                if edges.contains(edge) {
                    let v = UIView()
                    v.tag = Int(edge.rawValue)
                    v.backgroundColor = color
                    v.translatesAutoresizingMaskIntoConstraints = false
                    addSubview(v)

                    var horizontalVisualFormat = "H:"
                    var verticalVisualFormat = "V:"

                    switch edge {
                    case UIRectEdge.bottom:
                        horizontalVisualFormat += "|-(0)-[v]-(0)-|"
                        verticalVisualFormat += "[v(\(width))]-(0)-|"
                    case UIRectEdge.top:
                        horizontalVisualFormat += "|-(0)-[v]-(0)-|"
                        verticalVisualFormat += "|-(0)-[v(\(width))]"
                    case UIRectEdge.left:
                        horizontalVisualFormat += "|-(0)-[v(\(width))]"
                        verticalVisualFormat += "|-(0)-[v]-(0)-|"
                    case UIRectEdge.right:
                        horizontalVisualFormat += "[v(\(width))]-(0)-|"
                        verticalVisualFormat += "|-(0)-[v]-(0)-|"
                    default:
                        break
                    }

                    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: horizontalVisualFormat, options: .directionLeadingToTrailing, metrics: nil, views: ["v": v]))
                    self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: verticalVisualFormat, options: .directionLeadingToTrailing, metrics: nil, views: ["v": v]))
                }
            }
        }
    }
    
    func addCornerRadius(topLeft: Bool = false, topRight: Bool = false, bottomLeft:Bool = false, bottomRight:Bool = false, radius: CGFloat = 8){
        var maskCorns: CACornerMask = []
        var path: UIBezierPath = UIBezierPath(roundedRect: (self.bounds), byRoundingCorners: [], cornerRadii: CGSize(width: radius, height: radius))
        var rectCorners: UIRectCorner = []
        if topLeft && topRight && bottomLeft && bottomRight {
            maskCorns = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            path = UIBezierPath(roundedRect: (self.bounds),
                                byRoundingCorners: [.topRight, .topLeft, .bottomLeft, .bottomRight],
                                cornerRadii: CGSize(width: radius, height: radius))
        }else{
            if topRight {
                maskCorns.insert(.layerMaxXMinYCorner)
                rectCorners.insert(.topRight)
            }
            if topLeft {
                maskCorns.insert(.layerMinXMinYCorner)
                rectCorners.insert(.topLeft)
            }
            if bottomLeft {
                maskCorns.insert(.layerMinXMaxYCorner)
                rectCorners.insert(.bottomLeft)
            }
            if bottomRight {
                maskCorns.insert(.layerMaxXMaxYCorner)
                rectCorners.insert(.bottomRight)
            }
            let newPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: rectCorners, cornerRadii: CGSize(width: radius, height: radius))
            path.append(newPath)
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
    
    func cornerRadius(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
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
        self.bringSubviewToFront(shadowView)
    }

    func applyShadow(color:UIColor, offSet:CGSize, radius:CGFloat, opacity:Float, shouldRasterize:Bool = true, rasterizationScaleTo: CGFloat = UIScreen.main.scale){

        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        self.layer.shouldRasterize = shouldRasterize
        self.layer.rasterizationScale = rasterizationScaleTo
    }

    func removeShadow(){
        self.layer.shadowColor = UIColor.clear.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 0.0
        self.layer.shadowOpacity = 0.0
    }
    
    /// Insert a blur in a view. Must insert on init of it
    ///
    /// - Parameter style: Blur styles available for blur effect objects.
    /// - Parameter alpha: The view’s alpha value.
    /// - Returns: An object that implements some complex visual effects.
    func insertBlurView (style: UIBlurEffect.Style, alpha: CGFloat = 0.9) -> UIVisualEffectView {
        self.backgroundColor = UIColor.clear

        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.alpha = alpha
        
        blurEffectView.autoresizingMask = [
            .flexibleWidth, .flexibleHeight
        ]
        
        self.insertSubview(blurEffectView, at: 0)
        return blurEffectView
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
    
    func applyConstraints(_ toView: UIView,
                          applyAnchor: [(anchor: AnchorType, constraint: CGFloat)],
                          safeArea: Bool = false) {
        applyAnchor.forEach { element in
            switch element.anchor {
            case .all:
                if #available(iOS 11.0, *) {
                    self.topAnchor.constraint(equalTo: (safeArea ? toView.safeAreaLayoutGuide.topAnchor : toView.topAnchor),
                                              constant: element.constraint).isActive = true
                } else {
                    self.topAnchor.constraint(equalTo: toView.topAnchor,
                                              constant: element.constraint).isActive = true
                }
                self.leadingAnchor.constraint(equalTo: toView.leadingAnchor,
                                              constant: element.constraint).isActive = true
                self.trailingAnchor.constraint(equalTo: toView.trailingAnchor,
                                               constant: element.constraint).isActive = true
                self.bottomAnchor.constraint(equalTo: toView.bottomAnchor,
                                             constant: element.constraint).isActive = true
            case .top:
                if #available(iOS 11.0, *) {
                    self.topAnchor.constraint(equalTo: (safeArea ? toView.safeAreaLayoutGuide.topAnchor : toView.topAnchor),
                                              constant: element.constraint).isActive = true
                } else {
                    self.topAnchor.constraint(equalTo: toView.topAnchor,
                                              constant: element.constraint).isActive = true
                }
                
            case .bottom:
                self.bottomAnchor.constraint(equalTo: toView.bottomAnchor,
                                             constant: element.constraint).isActive = true
                
            case .bottomOf:
                self.topAnchor.constraint(equalTo: toView.bottomAnchor,
                                          constant: element.constraint).isActive = true
                
            case .leading:
                self.leadingAnchor.constraint(equalTo: toView.leadingAnchor,
                                              constant: element.constraint).isActive = true
                
            case .leadingToTrailing:
                self.leadingAnchor.constraint(equalTo: toView.trailingAnchor,
                                              constant: element.constraint).isActive = true
                
            case .trailing:
                self.trailingAnchor.constraint(equalTo: toView.trailingAnchor,
                                               constant: element.constraint).isActive = true
                
            case .trailingToLeading:
                self.trailingAnchor.constraint(equalTo: toView.leadingAnchor,
                                               constant: element.constraint).isActive = true
                
            case .heigth:
                self.heightAnchor.constraint(equalTo: toView.heightAnchor,
                                             constant: element.constraint).isActive = true
                
            case .width:
                self.widthAnchor.constraint(equalTo: toView.widthAnchor,
                                            constant: element.constraint).isActive = true
                
            case .centerX:
                self.centerXAnchor.constraint(equalTo: toView.centerXAnchor,
                                              constant: element.constraint).isActive = true
                
            case .centerY:
                self.centerYAnchor.constraint(equalTo: toView.centerYAnchor,
                                              constant: element.constraint).isActive = true
                
            case .topGreaterThanOrEqualTo:
                self.topAnchor.constraint(greaterThanOrEqualTo: toView.bottomAnchor,
                                          constant: element.constraint).isActive = true
                
            case .topToTopGreaterThanOrEqualTo:
                self.topAnchor.constraint(greaterThanOrEqualTo: toView.topAnchor,
                                          constant: element.constraint).isActive = true
                
            case .bottomGreaterThanOrEqualTo:
                self.bottomAnchor.constraint(greaterThanOrEqualTo: toView.bottomAnchor,
                                             constant: element.constraint).isActive = true
                
            case .left:
                self.leftAnchor.constraint(equalTo: toView.leftAnchor,
                                           constant: element.constraint).isActive = true
                
            case .right:
                self.rightAnchor.constraint(equalTo: toView.rightAnchor,
                                            constant: element.constraint).isActive = true
            }
        }
    }
    
    func applyConstraint(_ toScrollView: UIScrollView) {
        applyConstraints(toScrollView, applyAnchor: [(.top, 0.0), (.leading, 0.0), (.trailing, 0.0), (.bottom, 0.0)])
        let widthConstraint = widthAnchor.constraint(equalTo: toScrollView.widthAnchor)
        widthConstraint.isActive = true
        
        let heigthConstraint = heightAnchor.constraint(equalTo: toScrollView.heightAnchor)
        heigthConstraint.priority = UILayoutPriority(250.0)
        heigthConstraint.isActive = true
    }
}
#endif

