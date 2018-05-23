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
import UIKit

@IBDesignable
//MARK: UIView
class Circle: UIView {
    
    @IBInspectable var mainColor: UIColor = UIColor.blue {
        didSet { print("mainColor was set here") }
    }
    @IBInspectable var borderColor: UIColor = UIColor.orange {
        didSet { print("bColor was set here") }
    }
    @IBInspectable var ringThickness: CGFloat = 4 {
        didSet { print("ringThickness was set here") }
    }
    
    @IBInspectable var isSelected: Bool = true
    
    override func draw(_ rect: CGRect) {
        let dotPath = UIBezierPath(ovalIn: rect)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = dotPath.cgPath
        shapeLayer.fillColor = mainColor.cgColor
        layer.addSublayer(shapeLayer)
        
        if (isSelected) { drawRingFittingInsideView(rect: rect) }
    }
    override func layoutSubviews(){
        layer.cornerRadius = bounds.size.width/2;
    }
    
    internal func drawRingFittingInsideView(rect: CGRect)->() {
        let hw:CGFloat = ringThickness/2
        let circlePath = UIBezierPath(ovalIn: rect.insetBy(dx: hw,dy: hw))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = borderColor.cgColor
        shapeLayer.lineWidth = ringThickness
        layer.addSublayer(shapeLayer)
    }
}

@IBDesignable class DottedLine: UIView {
    
    @IBInspectable
    public var lineColor: UIColor = UIColor.black
    
    @IBInspectable
    public var lineWidth: CGFloat = CGFloat(4)
    
    @IBInspectable
    public var round: Bool = false
    
    @IBInspectable
    public var horizontal: Bool = true
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initBackgroundColor()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initBackgroundColor()
    }
    
    override public func prepareForInterfaceBuilder() {
        initBackgroundColor()
    }
    
    override public func draw(_ rect: CGRect) {
        
        let path = UIBezierPath()
        path.lineWidth = lineWidth
        
        if round {
            configureRoundPath(path: path, rect: rect)
        } else {
            configurePath(path: path, rect: rect)
        }
        
        lineColor.setStroke()
        
        path.stroke()
    }
    
    func initBackgroundColor() {
        if backgroundColor == nil {
            backgroundColor = UIColor.clear
        }
    }
    
    private func configurePath(path: UIBezierPath, rect: CGRect) {
        if horizontal {
            let center = rect.height * 0.5
            let drawWidth = rect.size.width - (rect.size.width.truncatingRemainder(dividingBy: (lineWidth * 2))) + lineWidth
            let startPositionX = (rect.size.width - drawWidth) * 0.5 + lineWidth
            
            path.move(to: CGPoint(x: startPositionX, y: center))
            path.addLine(to: CGPoint(x: drawWidth, y: center))
            
        } else {
            let center = rect.width * 0.5
            let drawHeight = rect.size.height - (rect.size.height.truncatingRemainder(dividingBy: (lineWidth * 2))) + lineWidth
            let startPositionY = (rect.size.height - drawHeight) * 0.5 + lineWidth
            
            path.move(to: CGPoint(x: center, y: startPositionY))
            path.addLine(to: CGPoint(x: center, y: drawHeight))
        }
        
        let dashes: [CGFloat] = [lineWidth, lineWidth]
        path.setLineDash(dashes, count: dashes.count, phase: 0)
        path.lineCapStyle = CGLineCap.butt
    }
    
    private func configureRoundPath(path: UIBezierPath, rect: CGRect) {
        if horizontal {
            let center = rect.height * 0.5
            let drawWidth = rect.size.width - (rect.size.width.truncatingRemainder(dividingBy: (lineWidth * 2)))
            let startPositionX = (rect.size.width - drawWidth) * 0.5 + lineWidth
            
            path.move(to: CGPoint(x: startPositionX, y: center))
            path.addLine(to: CGPoint(x: drawWidth, y: center))
            
        } else {
            let center = rect.width * 0.5
            let drawHeight = rect.size.height - (rect.size.height.truncatingRemainder(dividingBy: (lineWidth * 2)))
            let startPositionY = (rect.size.height - drawHeight) * 0.5 + lineWidth
            
            path.move(to: CGPoint(x: center, y: startPositionY))
            path.addLine(to: CGPoint(x: center, y: drawHeight))
        }
        
        let dashes: [CGFloat] = [0, lineWidth * 2]
        path.setLineDash(dashes, count: dashes.count, phase: 0)
        path.lineCapStyle = CGLineCap.round
    }
}


//MARK: UIButton
@IBDesignable
open class CustomUIButtom: UIButton {
    
    @IBInspectable open var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable open var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    //Normal state bg and border
    @IBInspectable open var normalBorderColor: UIColor? {
        didSet {
            layer.borderColor = normalBorderColor?.cgColor
        }
    }
    
    @IBInspectable open var normalBackgroundColor: UIColor? {
        didSet {
            setBgColorForState(color: normalBackgroundColor, forState: .normal)
        }
    }
    
    @IBInspectable open var selectedBackgroundColor: UIColor? {
        didSet {
            setBgColorForState(color: selectedBackgroundColor, forState: .selected)
        }
    }
    
    
    //Highlighted state bg and border
    @IBInspectable open var highlightedBorderColor: UIColor?
    
    @IBInspectable open var highlightedBackgroundColor: UIColor? {
        didSet {
            setBgColorForState(color: highlightedBackgroundColor, forState: .highlighted)
        }
    }
    
    
    //selected state bg and border
    @IBInspectable open var selectedBorderColor: UIColor? {
        didSet {
            setBgColorForState(color: selectedBorderColor, forState: .selected)
        }
    }
    
    
    private func setBgColorForState(color: UIColor?, forState: UIControlState){
        if color != nil {
            setBackgroundImage(UIImage.imageWithColor(color: color!), for: forState)
            
        } else {
            setBackgroundImage(nil, for: forState)
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        
        if borderWidth > 0 {
            if state == .normal && layer.borderColor == normalBorderColor?.cgColor {
                layer.borderColor = normalBorderColor?.cgColor
            } else if state == .highlighted && highlightedBorderColor != nil{
                layer.borderColor = highlightedBorderColor!.cgColor
            }else if state == .selected && selectedBorderColor != nil{
                layer.borderColor = selectedBorderColor!.cgColor
            }
        }
        
        if setAlignmentCenter {
            self.titleLabel?.textAlignment = NSTextAlignment.center
        }
    }
    
    @IBInspectable open var setUnderline: Bool = false {
        didSet {
            makeUnderline()
        }
    }
    
    @IBInspectable open var setAlignmentCenter: Bool = false {
        didSet {
            setAlignmentCenter = true
        }
    }
    
    @IBInspectable open var underlineString: String = "" {
        didSet {
            setUnderline = false
            self.setAttributedTitle(underlinedString(string: (self.titleLabel?.text)! as NSString, term: (underlineString as NSString)), for: .normal)
        }
    }
    
    private func makeUnderline() {
        
        let customAttributes : [NSAttributedStringKey: Any] = [NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue]
        let title = self.titleLabel?.text
        let attributeString = NSMutableAttributedString(string: (title)!, attributes: customAttributes)
        self.setAttributedTitle(attributeString, for: .normal)
    }
    
    open func underlinedString(string: NSString, term: NSString) -> NSAttributedString {
        let output = NSMutableAttributedString(string: String(string))
        let underlineRange = string.range(of: String(term))
        output.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleNone.rawValue, range: NSMakeRange(0, string.length))
        output.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: underlineRange)
        
        return output
    }
    
    @IBInspectable open var imageAspectFit: Int = 0 {
        didSet {
            self.imageView?.contentMode = UIViewContentMode(rawValue: imageAspectFit)!
        }
    }
    
}

@IBDesignable class CheckBoxButton: UIButton {
    // Images
    var onImage: UIImage!
    var offImage: UIImage!
    
    var CheckedImage: String! {
        didSet {
            if CheckedImage != nil {
                onImage = UIImage(named: CheckedImage)! as UIImage
            }else{
                fatalError("Ops! Missing ON image!")
            }
        }
    }
    
    var UncheckedImage: String! {
        didSet {
            if UncheckedImage != nil {
                offImage = UIImage(named: UncheckedImage)! as UIImage
            }else{
                fatalError("Ops! Missing OFF image!")
            }
        }
    }
    
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(onImage, for: UIControlState.normal)
            } else {
                self.setImage(offImage, for: UIControlState.normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControlEvents.touchUpInside)
        self.isChecked = false
    }
    
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}



@IBDesignable class RadioNotifButton: UIButton {
    // Images
    var onImage: UIImage!
    var offImage: UIImage!
    
    var CheckedImage: String! {
        didSet {
            if CheckedImage != nil {
                onImage = UIImage(named: CheckedImage)! as UIImage
            }else{
                fatalError("Ops! Missing ON image!")
            }
        }
    }
    
    var UncheckedImage: String! {
        didSet {
            if UncheckedImage != nil {
                offImage = UIImage(named: UncheckedImage)! as UIImage
            }else{
                fatalError("Ops! Missing OFF image!")
            }
        }
    }
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(onImage, for: UIControlState.normal)
            } else {
                self.setImage(offImage, for: UIControlState.normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControlEvents.touchUpInside)
        self.isChecked = false
    }
    
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}
//MARK: - UITextField

@IBDesignable class CustomUITextField : UITextField {
    
    private var color: UIColor?
    private var width: CGFloat = 0.0
    
    @IBInspectable var setBorderTop : Bool = false {
        didSet {
            let border = CALayer()
            border.backgroundColor = self.color?.cgColor
            border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.width)
            self.layer.addSublayer(border)
            
        }
    }
    @IBInspectable var setBorderBottom : Bool = false {
        didSet {
            let border = CALayer()
            border.backgroundColor = self.color?.cgColor
            border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: self.width)
            self.layer.addSublayer(border)
            
        }
    }
    @IBInspectable var setBorderLeft : Bool = false {
        didSet {
            let border = CALayer()
            border.backgroundColor = self.color?.cgColor
            border.frame = CGRect(x: 0, y: 0, width: self.width, height: self.frame.size.height)
            self.layer.addSublayer(border)
            
        }
    }
    @IBInspectable var setBorderRight : Bool = false {
        didSet {
            let border = CALayer()
            border.backgroundColor = self.color?.cgColor
            border.frame = CGRect(x: self.frame.size.width - self.width, y: 0, width: width, height: self.frame.size.height)
            self.layer.addSublayer(border)
            
        }
    }
    @IBInspectable var setBorderWidth: CGFloat = 0.0 {
        didSet {
            self.width = setBorderWidth
        }
    }
    @IBInspectable var setBorderColor: UIColor! {
        didSet {
            self.color = setBorderColor
        }
    }
    
    @IBInspectable var paddingLeft: CGFloat = 0
    @IBInspectable var paddingRight: CGFloat = 0
    @IBInspectable var paddingTop: CGFloat = 0
    @IBInspectable var paddingBottom: CGFloat = 0
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + paddingLeft, y: bounds.origin.y + paddingTop, width: bounds.size.width - paddingLeft - paddingRight, height: bounds.size.height - paddingTop - paddingBottom)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
}
//MARK: UIView
@IBDesignable class CustomUIView : UIView {
    
    private var color: UIColor?
    private var width: CGFloat = 0.0
    private var gradientColorTop: UIColor?
    private var gradientColorBottom: UIColor?
    
    @IBInspectable var setBorderTop : Bool = false {
        didSet {
            let border = CALayer()
            border.backgroundColor = self.color?.cgColor
            border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.width)
            self.layer.addSublayer(border)
            
        }
    }
    @IBInspectable var setBorderBottom : Bool = false {
        didSet {
            let border = CALayer()
            border.backgroundColor = self.color?.cgColor
            border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: self.width)
            self.layer.addSublayer(border)
            
        }
    }
    @IBInspectable var setBorderLeft : Bool = false {
        didSet {
            let border = CALayer()
            border.backgroundColor = self.color?.cgColor
            border.frame = CGRect(x: 0, y: 0, width: self.width, height: self.frame.size.height)
            self.layer.addSublayer(border)
            
        }
    }
    @IBInspectable var setBorderRight : Bool = false {
        didSet {
            let border = CALayer()
            border.backgroundColor = self.color?.cgColor
            border.frame = CGRect(x: self.frame.size.width - self.width, y: 0, width: width, height: self.frame.size.height)
            self.layer.addSublayer(border)
        }
    }
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var setBorderWidth: CGFloat = 0.0 {
        didSet {
            self.width = setBorderWidth
        }
    }
    @IBInspectable var setBorderColor: UIColor! {
        didSet {
            self.color = setBorderColor
        }
    }
    
    //    @IBInspectable var gradientFirstColor: UIColor! {
    //        didSet {
    //            self.gradientColorTop = gradientFirstColor
    //        }
    //    }
    //
    //    @IBInspectable var gradientSecondColor: UIColor! {
    //        didSet {
    //            self.gradientColorBottom = gradientSecondColor
    //        }
    //    }
    //
    //    @IBInspectable var transparentFirstColor: Bool! {
    //        didSet {
    //            self.gradientColorTop? = gradientFirstColor.withAlphaComponent(0)
    //        }
    //    }
    //
    //    @IBInspectable var transparentSecondColor: Bool! {
    //        didSet {
    //            self.gradientColorBottom? = gradientSecondColor.withAlphaComponent(0)
    //        }
    //    }
    //
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        
        if( setBorderTop || setBorderLeft || setBorderRight || setBorderBottom ) {
            layer.backgroundColor = self.color?.cgColor
        }
        //        if (gradientFirstColor != nil) && (gradientSecondColor != nil) {
        //            self.addGradient()
        //        }
    }
    //
    //    func addGradient(){
    //        let gradient = CAGradientLayer()
    //        let color01: UIColor!
    //        let color02: UIColor!
    //        gradient.frame = self.bounds
    //        if transparentFirstColor {
    //            color01 = self.gradientColorTop?.withAlphaComponent(0)
    //        }else{
    //            color01 = self.gradientColorTop
    //        }
    //        if transparentSecondColor {
    //            color02 = self.gradientColorBottom?.withAlphaComponent(0)
    //        }else{
    //            color02 = self.gradientColorBottom
    //        }
    //        gradient.colors = [color01.cgColor, color02.cgColor]
    //
    //        self.layer.insertSublayer(gradient, at: 0)
    //    }
    
    @IBInspectable var shadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadow()
            }
        }
    }
    
    
    func addShadow(shadowColor: CGColor = UIColor.black.cgColor,
                   shadowOffset: CGSize = CGSize(width: 1.0, height: 2.0),
                   shadowOpacity: Float = 0.4,
                   shadowRadius: CGFloat = 3.0) {
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
}

//MARK: - UIPageControll
@IBDesignable class CustomUIPageControl: UIPageControl {
    
    private var color: UIColor!
    private var size: CGFloat! // 7.0 is great for border
    
    @IBInspectable var borderColor: UIColor! {
        didSet {
            self.color = borderColor
        }
    }
    
    @IBInspectable var borderSize: CGFloat = 0.0 {
        didSet {
            if borderSize > 0 {
                self.size = borderSize
                let image = UIImage.outlinedEllipse(size: CGSize(width: self.size, height: self.size), color: self.color)
                self.pageIndicatorTintColor = UIColor.init(patternImage: image!)
            }
        }
    }
}

//MARK: - UILabel
@IBDesignable class CustomTabBadge: UILabel {
    
}

@IBDesignable class CustomUILabel: UILabel {
    override func drawText(in rect: CGRect) {
        if let stringText = text {
            let stringTextAsNSString = stringText as NSString
            let labelStringSize = stringTextAsNSString.boundingRect(with: CGSize(width: self.frame.width,height: CGFloat.greatestFiniteMagnitude),
                                                                    options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                                    attributes: [NSAttributedStringKey.font: font],
                                                                    context: nil).size
            super.drawText(in: CGRect(x:0,y: 0,width: self.frame.width, height:ceil(labelStringSize.height)))
        } else {
            super.drawText(in: rect)
        }
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
    }
    
    @IBInspectable var strikeThroughString: String = "" {
        didSet {
            self.attributedText = makeStrikeThorugh(string: self.text! as NSString, term: (strikeThroughString as NSString))
        }
    }
    
    func makeStrikeThorugh(string: NSString, term: NSString) -> NSAttributedString {
        let output = NSMutableAttributedString(string: String(string))
        let underlineRange = string.range(of: String(term))
        output.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 0, range: NSMakeRange(0, string.length))
        output.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: underlineRange)
        
        return output
    }
}


@objc public protocol StarsRatingDelegate {
    @objc optional func didSelectRating(_ control: StarsRating, rating: Int)
}

@IBDesignable

open class StarsRating: UIView {
    
    // MARK: Properties
    
    @IBInspectable open var rating : Int = 0 {
        didSet {
            if rating < 0 {
                rating = 0
            }
            if rating > maxRating {
                rating = maxRating
            }
            setNeedsLayout()
        }
    }
    @IBInspectable var maxRating : Int = 5 {
        didSet {
            setNeedsLayout()
        }
    }
    @IBInspectable var filledStarImage : UIImage? {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var emptyStarImage : UIImage? {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable open var spacing : Int = 5 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    weak open var delegate : StarsRatingDelegate?
    
    fileprivate var ratingButtons = [UIButton]()
    fileprivate var buttonSize : Int {
        return Int(self.frame.height)
    }
    fileprivate var width : Int {
        return (buttonSize + spacing) * maxRating
    }
    
    // MARK: Initialization
    
    func initRate() {
        if ratingButtons.count == 0 {
            
            for _ in 0..<maxRating {
                let button = UIButton()
                
                button.setImage(emptyStarImage, for: UIControlState())
                button.setImage(filledStarImage, for: .selected)
                button.setImage(filledStarImage, for: [.highlighted, .selected])
                button.isUserInteractionEnabled = false
                
                button.adjustsImageWhenHighlighted = false
                ratingButtons += [button]
                addSubview(button)
            }
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        self.initRate()
        
        // Set the button's width and height to a square the size of the frame's height.
        var buttonFrame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        
        // Offset each button's origin by the length of the button plus spacing.
        for (index, button) in ratingButtons.enumerated() {
            buttonFrame.origin.x = CGFloat(index * (buttonSize + spacing))
            button.frame = buttonFrame
        }
        updateButtonSelectionStates()
    }
    
    override open var intrinsicContentSize : CGSize {
        return CGSize(width: width, height: buttonSize)
    }
    
    func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerated() {
            // If the index of a button is less than the rating, that button should be selected.
            button.isSelected = index < rating
        }
    }
    
    // MARK: Gesture recognizer
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleStarTouches(touches, withEvent: event)
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleStarTouches(touches, withEvent: event)
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.didSelectRating?(self, rating: self.rating)
    }
    
    func handleStarTouches(_ touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: self)
            
            if position.x > -50 && position.x < CGFloat(width + 50) {
                ratingButtonSelected(position)
            }
        }
    }
    
    func ratingButtonSelected(_ position: CGPoint) {
        for (index, button) in ratingButtons.enumerated() {
            if position.x > button.frame.minX {
                self.rating = index + 1
            } else if position.x < 0 {
                self.rating = 0
            }
        }
    }
    
}
