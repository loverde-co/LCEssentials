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
        case height
        case heightGreaterThanOrEqualTo
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
    
    /// First width constraint for this view.
    var widthConstraint: NSLayoutConstraint? {
        findConstraint(attribute: .width, for: self)
    }
    
    /// First height constraint for this view.
    var heightConstraint: NSLayoutConstraint? {
        findConstraint(attribute: .height, for: self)
    }
    
    /// First leading constraint for this view.
    var leadingConstraint: NSLayoutConstraint? {
        findConstraint(attribute: .leading, for: self)
    }
    
    /// First trailing constraint for this view.
    var trailingConstraint: NSLayoutConstraint? {
        findConstraint(attribute: .trailing, for: self)
    }
    
    /// First top constraint for this view.
    var topConstraint: NSLayoutConstraint? {
        findConstraint(attribute: .top, for: self)
    }
    
    /// First bottom constraint for this view.
    var bottomConstraint: NSLayoutConstraint? {
        findConstraint(attribute: .bottom, for: self)
    }
    
    var globalPoint: CGPoint? {
       return self.superview?.convert(self.frame.origin, to: nil)
    }

    var globalFrame: CGRect? {
       return self.superview?.convert(self.frame, to: nil)
    }
    
    /// Loverde Co: Border color of view
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

    /// Loverde Co: Border width of view;
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    /// Loverde Co: Corner radius of view;
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
    
    /// Get view's parent view controller
    var parentViewController: UIViewController? {
        weak var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
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
    
    /// Returns all the subviews of a given type recursively in the
    /// view hierarchy rooted on the view it its called.
    ///
    /// - Parameter ofType: Class of the view to search.
    /// - Returns: All subviews with a specified type.
    func subviews<T>(ofType _: T.Type) -> [T] {
        var views = [T]()
        for subview in subviews {
            if let view = subview as? T {
                views.append(view)
            } else if !subview.subviews.isEmpty {
                views.append(contentsOf: subview.subviews(ofType: T.self))
            }
        }
        return views
    }
    
    func findAView<T: UIView>(_ ofType: T.Type) -> T? {
        if let finded = subviews.first(where: { $0 is T }) as? T {
            return finded
        } else {
            for view in subviews {
                return view.findAView(ofType)
            }
        }
        return nil
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
    
    /// Search constraints until we find one for the given view
    /// and attribute. This will enumerate ancestors since constraints are
    /// always added to the common ancestor.
    ///
    /// - Parameter attribute: the attribute to find.
    /// - Parameter at: the view to find.
    /// - Returns: matching constraint.
    func findConstraint(attribute: NSLayoutConstraint.Attribute, for view: UIView) -> NSLayoutConstraint? {
        let constraint = constraints.first {
            ($0.firstAttribute == attribute && $0.firstItem as? UIView == view) ||
            ($0.secondAttribute == attribute && $0.secondItem as? UIView == view)
        }
        return constraint ?? superview?.findConstraint(attribute: attribute, for: view)
    }
    
    func constraints(on anchor: NSLayoutYAxisAnchor) -> [NSLayoutConstraint] {
        guard let superview = superview else { return [] }
        return superview.constraints.filtered(view: self, anchor: anchor)
    }
    
    func constraints(on anchor: NSLayoutXAxisAnchor) -> [NSLayoutConstraint] {
        guard let superview = superview else { return [] }
        return superview.constraints.filtered(view: self, anchor: anchor)
    }
    
    func constraints(on anchor: NSLayoutDimension) -> [NSLayoutConstraint] {
        guard let superview = superview else { return [] }
        return constraints.filtered(view: self, anchor: anchor) + superview.constraints.filtered(view: self, anchor: anchor)
    }

    func drawCircle(inCoord x: CGFloat,
                    y: CGFloat,
                    with radius: CGFloat,
                    strokeColor: UIColor = UIColor.red,
                    fillColor: UIColor = UIColor.gray,
                    isEmpty: Bool = false) -> [String:Any] {
        
        let dotPath = UIBezierPath(ovalIn: CGRect(x: x,y: y, width: radius, height: radius))
        let layer = CAShapeLayer()
        if !isEmpty {
            layer.path = dotPath.cgPath
            layer.strokeColor = strokeColor.cgColor
            layer.fillColor = fillColor.cgColor
            self.layer.addSublayer(layer)
        }
        return ["path": dotPath,"layer": layer]
    }

    func applyShadow(color: UIColor, offSet:CGSize,
                     radius: CGFloat,
                     opacity: Float,
                     shouldRasterize: Bool = true,
                     rasterizationScaleTo: CGFloat = UIScreen.main.scale){

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
    func insertBlurView(style: UIBlurEffect.Style,
                        color: UIColor = .black,
                        alpha: CGFloat = 0.9) {
        self.backgroundColor = color

        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.alpha = alpha
        
        blurEffectView.autoresizingMask = [
            .flexibleWidth, .flexibleHeight
        ]
        
        self.insertSubview(blurEffectView, at: 0)
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
    
    /// Apply constraint to a View more easily.
    ///
    ///        "MyView.setConstraints(AnotherView, applyAnchor: [(AnchorType.leading, 10.0), AnchorType.height, 0.0])"
    ///        "MyView.setConstraints(ContainerView, applyAnchor: [(AnchorType.all, 0.0)])"
    ///
    /// - Parameters:
    ///   - toView: The View you whant to constraint to.
    ///   - applyAnchor: Array of ENUM AnchorType and constraint value (CGFloat) to apply to "toView"
    ///   - safeArea: Bool in case you whant top and bottom to be applied to Safe Area Layout Guide. Default is FALSE
    /// - Returns:
    /// All active constraints you apply.
    func setConstraints(_ toView: UIView,
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
                
            case .height:
                self.heightAnchor.constraint(equalTo: toView.heightAnchor,
                                             constant: element.constraint).isActive = true
                
            case .heightGreaterThanOrEqualTo:
                self.heightAnchor.constraint(greaterThanOrEqualToConstant: element.constraint).isActive = true
                
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
                self.topAnchor.constraint(greaterThanOrEqualTo: (safeArea ? toView.safeAreaLayoutGuide.topAnchor : toView.topAnchor),
                                          constant: element.constraint).isActive = true
                
            case .bottomGreaterThanOrEqualTo:
                self.bottomAnchor.constraint(greaterThanOrEqualTo: (safeArea ? toView.safeAreaLayoutGuide.bottomAnchor : toView.bottomAnchor),
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
    
    /// Apply constraint to a View more easily.
    ///
    ///        "MyView.applyConstraints(AnotherView, applyAnchor: (AnchorType.leading, 10.0))"
    ///        "MyView.applyConstraints(ContainerView, applyAnchor: (AnchorType.all, 0.0))"
    ///
    /// - Parameters:
    ///   - toView: The View you whant to constraint to.
    ///   - applyAnchor: A tuple of enum AnchorType and CGFloat value to apply constraint to "toView"
    ///   - safeArea: Bool in case you whant top and bottom to be applied to Safe Area Layout Guide. Default is FALSE
    /// - Returns:
    /// All active constraints you apply.
    func setConstraints(_ toView: UIView,
                        applyAnchor: (anchor: AnchorType, constraint: CGFloat),
                        safeArea: Bool = false) {
        
        switch applyAnchor.anchor {
        case .all:
            let topAnchor: NSLayoutConstraint
            if #available(iOS 11.0, *) {
                topAnchor = self.topAnchor.constraint(equalTo: (safeArea ? toView.safeAreaLayoutGuide.topAnchor : toView.topAnchor),
                                                      constant: applyAnchor.constraint)
                topAnchor.identifier = "topAnchor"
                topAnchor.isActive = true
            } else {
                topAnchor = self.topAnchor.constraint(equalTo: toView.topAnchor,
                                                      constant: applyAnchor.constraint)
                topAnchor.identifier = "topAnchor"
                topAnchor.isActive = true
            }
            self.leadingAnchor.constraint(equalTo: toView.leadingAnchor,
                                          constant: applyAnchor.constraint).isActive = true
            self.trailingAnchor.constraint(equalTo: toView.trailingAnchor,
                                           constant: applyAnchor.constraint).isActive = true
            self.bottomAnchor.constraint(equalTo: toView.bottomAnchor,
                                         constant: applyAnchor.constraint).isActive = true
        case .top:
            if #available(iOS 11.0, *) {
                self.topAnchor.constraint(equalTo: (safeArea ? toView.safeAreaLayoutGuide.topAnchor : toView.topAnchor),
                                          constant: applyAnchor.constraint).isActive = true
            } else {
                self.topAnchor.constraint(equalTo: toView.topAnchor,
                                          constant: applyAnchor.constraint).isActive = true
            }
            
        case .bottom:
            self.bottomAnchor.constraint(equalTo: toView.bottomAnchor,
                                         constant: applyAnchor.constraint).isActive = true
            
        case .bottomOf:
            self.topAnchor.constraint(equalTo: toView.bottomAnchor,
                                      constant: applyAnchor.constraint).isActive = true
            
        case .leading:
            self.leadingAnchor.constraint(equalTo: toView.leadingAnchor,
                                          constant: applyAnchor.constraint).isActive = true
            
        case .leadingToTrailing:
            self.leadingAnchor.constraint(equalTo: toView.trailingAnchor,
                                          constant: applyAnchor.constraint).isActive = true
            
        case .trailing:
            self.trailingAnchor.constraint(equalTo: toView.trailingAnchor,
                                           constant: applyAnchor.constraint).isActive = true
            
        case .trailingToLeading:
            self.trailingAnchor.constraint(equalTo: toView.leadingAnchor,
                                           constant: applyAnchor.constraint).isActive = true
            
        case .height:
            self.heightAnchor.constraint(equalTo: toView.heightAnchor,
                                         constant: applyAnchor.constraint).isActive = true
            
        case .heightGreaterThanOrEqualTo:
            self.heightAnchor.constraint(greaterThanOrEqualToConstant: applyAnchor.constraint).isActive = true
            
        case .width:
            self.widthAnchor.constraint(equalTo: toView.widthAnchor,
                                        constant: applyAnchor.constraint).isActive = true
            
        case .centerX:
            self.centerXAnchor.constraint(equalTo: toView.centerXAnchor,
                                          constant: applyAnchor.constraint).isActive = true
            
        case .centerY:
            self.centerYAnchor.constraint(equalTo: toView.centerYAnchor,
                                          constant: applyAnchor.constraint).isActive = true
            
        case .topGreaterThanOrEqualTo:
            self.topAnchor.constraint(greaterThanOrEqualTo: toView.bottomAnchor,
                                      constant: applyAnchor.constraint).isActive = true
            
        case .topToTopGreaterThanOrEqualTo:
            if #available(iOS 11.0, *) {
                self.topAnchor.constraint(greaterThanOrEqualTo: (safeArea ? toView.safeAreaLayoutGuide.topAnchor : toView.topAnchor),
                                          constant: applyAnchor.constraint).isActive = true
            } else {
                self.topAnchor.constraint(greaterThanOrEqualTo: toView.topAnchor,
                                          constant: applyAnchor.constraint).isActive = true
            }
            
        case .bottomGreaterThanOrEqualTo:
            self.bottomAnchor.constraint(greaterThanOrEqualTo: toView.bottomAnchor,
                                         constant: applyAnchor.constraint).isActive = true
            
        case .left:
            self.leftAnchor.constraint(equalTo: toView.leftAnchor,
                                       constant: applyAnchor.constraint).isActive = true
            
        case .right:
            self.rightAnchor.constraint(equalTo: toView.rightAnchor,
                                        constant: applyAnchor.constraint).isActive = true
        }
    }
    
    func applyConstraint(_ toScrollView: UIScrollView, orientation: UIScrollView.orientation = .vertical) {
        if self is UIScrollView { fatalError("You cannot apply this to self ScrollView.") }
        
        self.setConstraints(toScrollView, applyAnchor: [(AnchorType.top, 0.0),
                                                        (AnchorType.leading, 0.0),
                                                        (AnchorType.trailing, 0.0),
                                                        (AnchorType.bottom, 0.0)])
        
        let widthConstraint = widthAnchor.constraint(equalTo: toScrollView.widthAnchor)
        let heigthConstraint = heightAnchor.constraint(equalTo: toScrollView.heightAnchor)
        
        switch orientation {
        case .horizontal:
            widthConstraint.priority = UILayoutPriority(250.0)
        case .vertical:
            heigthConstraint.priority = UILayoutPriority(250.0)
        }
        
        widthConstraint.isActive = true
        heigthConstraint.isActive = true
    }
}
#endif
