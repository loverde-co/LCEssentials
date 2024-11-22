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

fileprivate weak var kvo_viewReference: UIView?

public extension UIView {
    
    enum AnchorType {
        case all
        case top
        case topToBottom
        case bottom
        case bottomToTop
        case leading
        case trailing
        case heigth
        case width
        case centerX
        case centerY
        case leadingToTrailing
        case leadingToTrailingGreaterThanOrEqualTo
        case trailingToLeading
        case trailingToLeadingGreaterThanOrEqualTo
        case topGreaterThanOrEqualTo
        case bottomGreaterThanOrEqualTo
        case bottomLessThanOrEqualTo
        case topToTopGreaterThanOrEqualTo
        case left
        case right
    }
    
    static var className: String {
        return String(describing: self)
    }
    
    var viewReference: UIView? {
        get {
            kvo_viewReference
        }
        set {
            kvo_viewReference = newValue
        }
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
    
    var centerYConstraints: NSLayoutConstraint? {
        findConstraint(attribute: .centerY, for: self)
    }
    
    var centerXConstraints: NSLayoutConstraint? {
        findConstraint(attribute: .centerX, for: self)
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
    
    /// Loverde Co: Get view's absolute position
    var absolutePosition: CGRect {
        if #available(iOS 15, *), let window = UIApplication.shared.connectedScenes.compactMap({ ($0 as? UIWindowScene)?.keyWindow }).last {
            return self.convert(self.bounds, to: window)
        } else if #available(iOS 13, *), let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first {
            return self.convert(self.bounds, to: window)
        } else if let window = UIApplication.shared.keyWindow {
            return self.convert(self.bounds, to: window)
        }
        return .zero
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
    
    func addSubview(_ subview: UIView, translatesAutoresizingMaskIntoConstraints: Bool = false) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMaskIntoConstraints
    }
    
    func addSubviews(_ subviews: [UIView], translatesAutoresizingMaskIntoConstraints: Bool = false) {
        for subview in subviews {
            self.addSubview(subview, translatesAutoresizingMaskIntoConstraints: translatesAutoresizingMaskIntoConstraints)
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
    
    func findAView<T>(_ ofType: T.Type) -> T? {
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
    func setHeight(size: CGFloat) -> Self {
        heightAnchor.constraint(equalToConstant: size).isActive = true
        return self
    }
    
    @discardableResult
    func setHeight(min: CGFloat) -> Self {
        heightAnchor.constraint(greaterThanOrEqualToConstant: min).isActive = true
        return self
    }
    
    @discardableResult
    func setWidth(size: CGFloat) -> Self {
        widthAnchor.constraint(equalToConstant: size).isActive = true
        return self
    }
    
    @discardableResult
    func setWidth(min: CGFloat) -> Self {
        widthAnchor.constraint(greaterThanOrEqualToConstant: min).isActive = true
        return self
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
        
        let dotPath = UIBezierPath(ovalIn: CGRect(x: x, y: y, width: radius, height: radius))
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
    func setX(x: CGFloat) {
        var frame:CGRect = self.frame
        frame.origin.x = x
        self.frame = frame
    }
    /**
     Set y Position

     :param: y CGFloat
     */
    func setY(y: CGFloat) {
        var frame:CGRect = self.frame
        frame.origin.y = y
        self.frame = frame
    }
    /**
     Set Width

     :param: width CGFloat
     */
    func setFrameWidth(width: CGFloat) {
        var frame:CGRect = self.frame
        frame.size.width = width
        self.frame = frame
    }
    /**
     Set Height

     :param: height CGFloat
     */
    func setFrameHeight(height: CGFloat) {
        var frame:CGRect = self.frame
        frame.size.height = height
        self.frame = frame
    }
    
    func setWidth(_ toView: UIView? = nil, constant: CGFloat, _ multiplier: CGFloat = 0) -> Self {
        if let toView = toView {
            widthAnchor.constraint(equalTo: toView.widthAnchor, multiplier: multiplier, constant: constant).isActive = true
        } else if multiplier == 0 {
            widthAnchor.constraint(equalToConstant: constant).isActive = true
        }
        return self
    }
    
    func setHeight(_ toView: UIView? = nil, constant: CGFloat, _ multiplier: CGFloat = 0) -> Self {
        if let toView = toView {
            heightAnchor.constraint(equalTo: toView.heightAnchor, multiplier: multiplier, constant: constant).isActive = true
        } else if multiplier == 0 {
            heightAnchor.constraint(equalToConstant: constant).isActive = true
        }
        return self
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
    /// ```swift
    /// MyView.setConstraintsTo(parentView: AnotherView, anchorType: AnchorType.leading, value: 10.0)
    /// MyView.setConstraintsTo(anchorType: AnchorType.trailing,
    ///                          value: -10.0)
    ///        .setConstraintsTo(parentView: SuperMegaView,
    ///                          anchorType: AnchorType.bottomToTop,
    ///                          value: -12.0)
    /// ```
    ///
    /// - Parameters:
    ///   - parentView: The View you whant to constraint to.
    ///   - anchorType: AnchorType you whant to apply"
    ///   - value: CGFloat value for that constraints to
    ///   - safeArea: Bool in case you whant top and bottom to be applied to Safe Area Layout Guide. Default is FALSE
    /// - Returns:
    /// All active constraints you apply.
    ///
    @discardableResult
    func setConstraintsTo(parentView: UIView, anchorType: AnchorType, value: CGFloat, safeArea: Bool = false) -> Self {
        self.viewReference = parentView
        switch anchorType {
        case .all:
            let topAnchor: NSLayoutConstraint
            if #available(iOS 11.0, *) {
                topAnchor = self.topAnchor.constraint(equalTo: (safeArea ? parentView.safeAreaLayoutGuide.topAnchor : parentView.topAnchor),
                                                      constant: value)
                topAnchor.identifier = "topAnchor"
                topAnchor.isActive = true
            } else {
                topAnchor = self.topAnchor.constraint(equalTo: parentView.topAnchor,
                                                      constant: value)
                topAnchor.identifier = "topAnchor"
                topAnchor.isActive = true
            }
            var negativeValue = value
            switch value {
            case _ where value < 0:
                break
            case 0:
                break
            case _ where value > 0:
                negativeValue = -negativeValue
            default:
                break
            }
            self.leadingAnchor.constraint(equalTo: parentView.leadingAnchor,
                                          constant: value).isActive = true
            self.trailingAnchor.constraint(equalTo: parentView.trailingAnchor,
                                           constant: negativeValue).isActive = true
            self.bottomAnchor.constraint(equalTo: parentView.bottomAnchor,
                                         constant: negativeValue).isActive = true
        case .top:
            if #available(iOS 11.0, *) {
                self.topAnchor.constraint(equalTo: (safeArea ? parentView.safeAreaLayoutGuide.topAnchor : parentView.topAnchor),
                                          constant: value).isActive = true
            } else {
                self.topAnchor.constraint(equalTo: parentView.topAnchor,
                                          constant: value).isActive = true
            }
            
        case .topToBottom:
            self.topAnchor.constraint(equalTo: parentView.bottomAnchor,
                                      constant: value).isActive = true
            
        case .bottom:
            self.bottomAnchor.constraint(equalTo: parentView.bottomAnchor,
                                         constant: value).isActive = true
            
        case .bottomToTop:
            self.bottomAnchor.constraint(equalTo: parentView.topAnchor,
                                         constant: value).isActive = true
            
        case .leading:
            self.leadingAnchor.constraint(equalTo: parentView.leadingAnchor,
                                          constant: value).isActive = true
            
        case .leadingToTrailing:
            self.leadingAnchor.constraint(equalTo: parentView.trailingAnchor,
                                          constant: value).isActive = true
            
        case .leadingToTrailingGreaterThanOrEqualTo:
            self.leadingAnchor.constraint(greaterThanOrEqualTo: parentView.trailingAnchor,
                                          constant: value).isActive = true
            
        case .trailing:
            self.trailingAnchor.constraint(equalTo: parentView.trailingAnchor,
                                           constant: value).isActive = true
            
        case .trailingToLeading:
            self.trailingAnchor.constraint(equalTo: parentView.leadingAnchor,
                                           constant: value).isActive = true
            
        case .trailingToLeadingGreaterThanOrEqualTo:
            self.trailingAnchor.constraint(greaterThanOrEqualTo: parentView.leadingAnchor,
                                           constant: value).isActive = true
            
        case .heigth:
            self.heightAnchor.constraint(equalTo: parentView.heightAnchor,
                                         constant: value).isActive = true
            
        case .width:
            self.widthAnchor.constraint(equalTo: parentView.widthAnchor,
                                        constant: value).isActive = true
            
        case .centerX:
            self.centerXAnchor.constraint(equalTo: parentView.centerXAnchor,
                                          constant: value).isActive = true
            
        case .centerY:
            self.centerYAnchor.constraint(equalTo: parentView.centerYAnchor,
                                          constant: value).isActive = true
            
        case .topGreaterThanOrEqualTo:
            self.topAnchor.constraint(greaterThanOrEqualTo: parentView.bottomAnchor,
                                      constant: value).isActive = true
            
        case .topToTopGreaterThanOrEqualTo:
            if #available(iOS 11.0, *) {
                self.topAnchor.constraint(greaterThanOrEqualTo: (safeArea ? parentView.safeAreaLayoutGuide.topAnchor : parentView.topAnchor),
                                          constant: value).isActive = true
            } else {
                self.topAnchor.constraint(greaterThanOrEqualTo: parentView.topAnchor,
                                          constant: value).isActive = true
            }
            
        case .bottomGreaterThanOrEqualTo:
            self.bottomAnchor.constraint(greaterThanOrEqualTo: parentView.bottomAnchor,
                                         constant: value).isActive = true
            
        case .bottomLessThanOrEqualTo:
            self.bottomAnchor.constraint(lessThanOrEqualTo: parentView.bottomAnchor,
                                         constant: value).isActive = true
            
        case .left:
            self.leftAnchor.constraint(equalTo: parentView.leftAnchor,
                                       constant: value).isActive = true
            
        case .right:
            self.rightAnchor.constraint(equalTo: parentView.rightAnchor,
                                        constant: value).isActive = true
        }
        return self
    }
    
    @discardableResult
    func setConstraintsTo(_ parentView: UIView,
                          _ anchorType: AnchorType,
                          _ value: CGFloat,
                          _ safeArea: Bool = false) -> Self {
        
        return self.setConstraintsTo(parentView: parentView,
                                     anchorType: anchorType,
                                     value: value,
                                     safeArea: safeArea)
    }
    
    @discardableResult
    func setConstraintsTo(anchorType: AnchorType, value: CGFloat, safeArea: Bool = false) -> UIView {
        guard let currentView = self.viewReference
        else { fatalError("Ops! Faltou o parentView. Utilize setConstraintsTo(parentView... primeiro.") }
        self.setConstraintsTo(parentView: currentView, anchorType: anchorType, value: value, safeArea: safeArea)
        return self
    }
    
    @discardableResult
    func setConstraints(_ anchorType: AnchorType, _ value: CGFloat, _ safeArea: Bool = false) -> UIView {
        return self.setConstraintsTo(anchorType: anchorType,
                                     value: value,
                                     safeArea: safeArea)
    }
    
    func setConstraints(_ toScrollView: UIScrollView, direction: UICollectionView.ScrollDirection = .vertical) {
        if self is UIScrollView { fatalError("You cannot apply this to self ScrollView.") }
        self.setConstraintsTo(toScrollView, .top, 0)
            .setConstraints(.leading, 0)
            .setConstraints(.trailing, 0)
            .setConstraints(.bottom, 0)
        
        let widthConstraint = widthAnchor.constraint(equalTo: toScrollView.widthAnchor)
        if direction == .horizontal {
            widthConstraint.priority = UILayoutPriority(250.0)
        }
        widthConstraint.isActive = true
        
        let heigthConstraint = heightAnchor.constraint(equalTo: toScrollView.heightAnchor)
        if direction == .vertical {
            heigthConstraint.priority = UILayoutPriority(250.0)
        }
        heigthConstraint.isActive = true
    }
}
#endif
