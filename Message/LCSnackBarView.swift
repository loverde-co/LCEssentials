//
// Copyright (c) 2024 Loverde Co.
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

// MARK: - Framework headers
import UIKit

// MARK: - Protocols

@objc
public protocol LCSnackBarViewDelegate {
    @objc optional func snackbar(didEndExibition: LCSnackBarView)
}

// MARK: - Interface Headers


// MARK: - Local Defines / ENUMS

public enum LCSnackBarViewType {
    case `default`, rounded
}

public enum LCSnackBarOrientation {
    case top, bottom
}

public enum LCSnackBarTimer: CGFloat {
    case infinity = 0
    case minimum = 2
    case medium = 5
    case maximum = 10
}

// MARK: - Class

public final class LCSnackBarView: UIView {
    
    // MARK: - Private properties
    
//    private lazy var containerStackView: UIStackView = {
//        $0.axis = .horizontal
//        $0.distribution = .fillProportionally
//        $0.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        $0.isLayoutMarginsRelativeArrangement = true
//        $0.translatesAutoresizingMaskIntoConstraints = false
//        $0.borderColor = .red
//        $0.borderWidth = 1
//        return $0
//    }(UIStackView())
    
    private lazy var descriptionLabel: UILabel = {
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.text = nil
        $0.contentMode = .top
        $0.textColor = .black
        $0.backgroundColor = UIColor.clear
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
        $0.textAlignment = .center
        $0.isOpaque = true
        $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.sizeToFit()
        $0.borderColor = .black
        $0.borderWidth = 1
        return $0
    }(UILabel())
    
    private var _style: LCSnackBarViewType
    private var originPositionX: CGFloat = 0.0
    private var originPositionY: CGFloat = 0.0
    private var _orientation: LCSnackBarOrientation
    private var _timer: LCSnackBarTimer = .minimum
    private var _radius: CGFloat = 4.0
    
    private var _width: CGFloat = .zero
    private var _height: CGFloat = .zero
    
    private lazy var systemKeyboardVisible = false
    private lazy var isOpen = false
    
    // MARK: - Internal properties
    
    
    // MARK: - Public properties
    
    public weak var delegate: LCSnackBarViewDelegate?
    
    // MARK: - Initializers
    
    public init(
        style: LCSnackBarViewType = .default,
        orientation: LCSnackBarOrientation = .top,
        delegate: LCSnackBarViewDelegate? = nil
    ) {
            
        self._style = style
        self._orientation = orientation
        self.delegate = delegate
        
        super.init(frame: .zero)
        
        setupDefaultLayout()
        addComponentsAndConstraints()
        setupGestureRecognizer()
        setKeyboardObserver()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - Super Class Overrides
 
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: nil, object: nil)
    }
}

// MARK: - Extensions

public extension LCSnackBarView {
    
    // MARK: - Private methods
    
    private func setupDefaultLayout() {
        backgroundColor = .white
        clipsToBounds = true
    }
    
    private func setupGestureRecognizer() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTapGestureAction))
        gesture.numberOfTapsRequired = 1
        gesture.cancelsTouchesInView = false
        addGestureRecognizer(gesture)
    }
    
    private func setKeyboardObserver() {
        // Show
        NotificationCenter
            .default
            .addObserver(
                self,
                selector: #selector(self.keyboardWillShow(_:)),
                name: UIResponder.keyboardWillShowNotification,
                object: nil
            )
        
        // Hidde
        NotificationCenter
            .default
            .addObserver(
                self,
                selector: #selector(self.keyboardWillHide(_:)),
                name: UIResponder.keyboardWillHideNotification,
                object: nil
            )
    }
    
    @objc private func keyboardWillShow(_ notification: Notification?) -> Void {
        
//        if let info = notification?.userInfo {
//            
//            systemKeyboardVisible = true
//            //
//            let curveUserInfoKey    = UIResponder.keyboardAnimationCurveUserInfoKey
//            let durationUserInfoKey = UIResponder.keyboardAnimationDurationUserInfoKey
//            let frameEndUserInfoKey = UIResponder.keyboardFrameEndUserInfoKey
//            //
//            var animationCurve: UIView.AnimationOptions = .curveEaseOut
//            var animationDuration: TimeInterval = 0.25
//            var height:CGFloat = 0.0
//            
//            //  Getting keyboard animation.
//            if let curve = info[curveUserInfoKey] as? UIView.AnimationOptions {
//                animationCurve = curve
//            }
//            
//            //  Getting keyboard animation duration
//            if let duration = info[durationUserInfoKey] as? TimeInterval {
//                animationDuration = duration
//            }
//            
//            //  Getting UIKeyboardSize.
//            if let kbFrame = info[frameEndUserInfoKey] as? CGRect {
//                height = kbFrame.size.height
//            }
//            
//            DispatchQueue.main.async { [weak self] in
//                //                height
//                //                animationDuration
//                //                animationCurve
//            }
//        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification?) -> Void {
        DispatchQueue.main.async { [weak self] in
            self?.systemKeyboardVisible = false
            // keyboard is hidded
        }
    }
    
    private func updateStyle() {
        switch _style {
        case .rounded:
            _width = UIScreen.main.bounds.width - 20
            cornerRadius = _radius
            originPositionX = 10
        default:
            _width = UIScreen.main.bounds.width
            cornerRadius = 0
            originPositionX = 0
        }
    }
    
    private func positioningView(_ view: UIView) {
        switch _orientation {
        case .bottom:
            _height = (descriptionLabel.lineNumbers().cgFloat * descriptionLabel.font.pointSize) + 20 + UIDevice.bottomNotch
            originPositionY = UIScreen.main.bounds.height
            //containerStackView.alignment = .top
        default:
            _height = (descriptionLabel.lineNumbers().cgFloat * descriptionLabel.font.pointSize) + 20 + UIDevice.topNotch
            originPositionY = -_height
            //containerStackView.alignment = .bottom
        }
        
        view
        .addSubview(self,
                    translatesAutoresizingMaskIntoConstraints: true)
        
        frame = CGRect(x: originPositionX,
                       y: originPositionY,
                       width: _width,
                       height: _height)
    }
    
    private func showSnackBar(controller: UIViewController, completion: @escaping (() -> Void)) {
        if isOpen {
            return
        }
        isHidden = true
        updateStyle()
        positioningView(controller.view)
        let distance = CGFloat(_style == .rounded ? (_orientation == .top ? UIDevice.topNotch : UIDevice.bottomNotch) : 0)
        layoutIfNeeded()
        UIView.animate(withDuration: 0.6,
                       delay: 0.6,
                       options: .curveEaseInOut) { [weak self] in
            self?.layoutIfNeeded()
            //self?.containerStackView.layoutIfNeeded()
            self?.isHidden = false
            if self?._orientation == .top {
                self?.frame.origin.y += (self?._height ?? 0) + distance
            } else {
                self?.frame.origin.y -= (self?._height ?? 0) + distance
            }
        } completion: { finished in
            completion()
            self.isOpen = true
            guard self._timer != .infinity else { return }
            LCEssentials.backgroundThread(delay: self._timer.rawValue,
                                          background: nil,
                                          completion: {
                self.closeSnackBar(controller: controller, completion: {})
            })
        }
    }
    
    private func closeSnackBar(controller: UIViewController, completion: @escaping (() -> Void)) {
        let distance = CGFloat(_style == .rounded ? (_orientation == .top ? UIDevice.topNotch : UIDevice.bottomNotch) : 0)
        layoutIfNeeded()
        //containerStackView.layoutIfNeeded()
        UIView.animate(withDuration: 0.6,
                       delay: 0.6,
                       options: .curveEaseInOut) { [weak self] in
            self?.layoutIfNeeded()
            //self?.containerStackView.layoutIfNeeded()
            if self?._orientation == .top {
                self?.frame.origin.y -= (self?._height ?? 0) + distance
            } else {
                self?.frame.origin.y += (self?._height ?? 0) + distance
            }
        } completion: { finished in
            self.delegate?.snackbar?(didEndExibition: self)
            self.isOpen = false
            self.removeFromSuperview()
            completion()
        }
    }
    
    @objc
    private func onTapGestureAction(_ : UITapGestureRecognizer) {
        if let controller = LCEssentials.getTopViewController(aboveBars: true),
           _timer == .infinity {
            self.closeSnackBar(controller: controller, completion: {})
        }
    }
    
    private func addComponentsAndConstraints() {
        
//        // MARK: - Add Subviews
//      
        addSubview(descriptionLabel, translatesAutoresizingMaskIntoConstraints: false)
//        containerStackView
//            .addArrangedSubviews([descriptionLabel])
//        
//        addSubviews([containerStackView])
//        
//        // MARK: - Add Constraints
//        
        descriptionLabel
            .setConstraintsTo(self, .top, 10)
            .setConstraints(.leading, 10)
            .setConstraints(.trailing, -10)
            .setConstraints(.bottom, -10)
        
//        containerStackView
//            .setConstraintsTo(self, .top, 10, true)
//            .setConstraints(.leading, 10)
//            .setConstraints(.trailing, -10)
//            .setConstraints(.bottom, -10, true)
    }
}

public extension LCSnackBarView {
    
    // MARK: - Public methods
    
    @discardableResult
    func configure(text: String) -> Self {
        descriptionLabel.text = text
        return self
    }
    
    @discardableResult
    func configure(textColor: UIColor) -> Self {
        descriptionLabel.textColor = textColor
        return self
    }
    
    @discardableResult
    func configure(textFont: UIFont, alignment: NSTextAlignment = .center) -> Self {
        descriptionLabel.font = textFont
        descriptionLabel.textAlignment = alignment
        return self
    }
    
    @discardableResult
    func configure(backgroundColor: UIColor) -> Self {
        self.backgroundColor = backgroundColor
        return self
    }
    
    @discardableResult
    func configure(exibition timer: LCSnackBarTimer) -> Self {
        _timer = timer
        return self
    }
    
    func present(completion: (()->())? = nil) {
        if let controller = LCEssentials.getTopViewController(aboveBars: true) {
            showSnackBar(controller: controller) {
                completion?()
            }
        }
    }
}
