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

#if os(iOS) || os(macOS)

public class RotatingCircularGradientProgressBar: UIView {
    public var color: UIColor = .gray {
        didSet { setNeedsDisplay() }
    }
    public var gradientColor: UIColor = .white {
        didSet { setNeedsDisplay() }
    }
    public var ringWidth: CGFloat = 2

    public var progress: CGFloat = 0 {
        didSet { setNeedsDisplay() }
    }

    private var progressLayer = CAShapeLayer()
    private var backgroundMask = CAShapeLayer()
    private let gradientLayer = CAGradientLayer()

    public init() {
        super.init(frame: .zero)
        
        setupLayers()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupLayers() {
        backgroundMask.lineWidth = ringWidth
        backgroundMask.fillColor = nil
        backgroundMask.strokeColor = UIColor.white.cgColor
        layer.mask = backgroundMask

        progressLayer.lineWidth = ringWidth
        progressLayer.fillColor = nil

        layer.addSublayer(gradientLayer)

        gradientLayer.mask = progressLayer
        gradientLayer.locations = [0.35, 0.5, 0.65]
    }

    private func createAnimation() {
        // MARK: Rotation Animation

        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")

        rotationAnimation.fromValue = CGFloat(Double.pi / 2)
        rotationAnimation.toValue = CGFloat(2.5 * Double.pi)
        rotationAnimation.repeatCount = Float.infinity
        rotationAnimation.duration = 1

        gradientLayer.add(rotationAnimation, forKey: "rotationAnimation")


        // MARK: Gradient Animation
        let startPointAnimation = CAKeyframeAnimation(keyPath: "startPoint")
        startPointAnimation.values = [CGPoint.zero, CGPoint(x: 1, y: 0), CGPoint(x: 1, y: 1)]

        startPointAnimation.repeatCount = Float.infinity
        startPointAnimation.duration = 1

        let endPointAnimation = CAKeyframeAnimation(keyPath: "endPoint")
        endPointAnimation.values = [CGPoint(x: 1, y: 1), CGPoint(x: 0, y: 1), CGPoint.zero]
        
        endPointAnimation.repeatCount = Float.infinity
        endPointAnimation.duration = 1

        gradientLayer.add(startPointAnimation, forKey: "startPointAnimation")
        gradientLayer.add(endPointAnimation, forKey: "endPointAnimation")
    }

    public override func draw(_ rect: CGRect) {
        let circlePath = UIBezierPath(ovalIn: rect.insetBy(dx: ringWidth / 2, dy: ringWidth / 2))
        backgroundMask.path = circlePath.cgPath

        progressLayer.path = circlePath.cgPath
        progressLayer.lineCap = .round
        progressLayer.strokeStart = 0
        progressLayer.strokeEnd = progress
        progressLayer.strokeColor = UIColor.white.cgColor

        gradientLayer.frame = rect
        gradientLayer.colors = [color.cgColor, gradientColor.cgColor, color.cgColor]
        
        createAnimation()
    }
}

//MARK: - UIPageControll
@IBDesignable open class UIPageControlCustom: UIPageControl {
    
    private var color: UIColor!
    private var size: CGFloat! // 7.0 is great for border
    
    open var borderSize: CGFloat = 0.0 {
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
@IBDesignable open class CustomUILabel: UILabel {
    var topInset: CGFloat = 0.0
    var bottomInset: CGFloat = 0.0
    var leftInset: CGFloat = 0.0
    var rightInset: CGFloat = 0.0

    open override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        var newRect = rect
        if let stringText = text {
            let stringTextAsNSString = stringText as NSString
            let labelStringSize = stringTextAsNSString.boundingRect(with: CGSize(width: self.frame.width,height: CGFloat.greatestFiniteMagnitude),
                                                                    options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                                    attributes: [NSAttributedString.Key.font: font!],
                                                                    context: nil).size
            newRect = CGRect(x:0,y: 0,width: self.frame.width, height:ceil(labelStringSize.height))
        
        }
        super.drawText(in: newRect.inset(by: insets))
    }

    open override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }

    open override var bounds: CGRect {
        didSet {
            // ensures this works within stack views if multi-line
            preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset)
        }
    }
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
    }
    
    open var strikeThroughString: String = "" {
        didSet {
            self.attributedText = makeStrikeThorugh(string: self.text! as NSString, term: (strikeThroughString as NSString))
        }
    }
    
    func makeStrikeThorugh(string: NSString, term: NSString) -> NSAttributedString {
        let output = NSMutableAttributedString(string: String(string))
        let underlineRange = string.range(of: String(term))
        output.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSMakeRange(0, string.length))
        output.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: underlineRange)
        
        return output
    }
}


@objc public protocol StarsRatingDelegate {
    @objc optional func didSelectRating(_ control: StarsRating, rating: Int)
}

@IBDesignable

open class StarsRating: UIView {
    
    // MARK: Properties
    
    open var rating : Int = 0 {
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
    var maxRating : Int = 5 {
        didSet {
            setNeedsLayout()
        }
    }
    var filledStarImage : UIImage? {
        didSet {
            setNeedsDisplay()
        }
    }
    var emptyStarImage : UIImage? {
        didSet {
            setNeedsDisplay()
        }
    }
    open var spacing : Int = 5 {
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
                
                button.setImage(emptyStarImage, for: UIControl.State())
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
#endif
