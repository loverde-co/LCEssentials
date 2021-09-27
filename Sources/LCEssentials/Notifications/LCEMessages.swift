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


import UIKit

#if os(iOS) || os(macOS)
@objc public protocol LCEMessagesDelegate {
    @objc optional func messages(didTapOnMessage: LCEMessages)
    @objc optional func messages(onDissmiss message: LCEMessages)
}

public enum LCEMessagesDirection {
    case top
    case bottom
}

public enum LCEMessagesDuration: Double {
    case forever = 0
    case twoSec = 2
    case threeSec = 3
    case fourSec = 4
    case fiveSecs = 5
    case sixSecs = 6
    case eightSecs = 8
}

public class LCEMessages: UIViewController {
    
    @IBOutlet private var lblBody: UILabel!
    @IBOutlet private var iconImage: UIImageView!
    @IBOutlet private var iconActivityConstraints: NSLayoutConstraint!
    @IBOutlet private var iconActivityBottomConstraints: NSLayoutConstraint!
    @IBOutlet private var labelBottomConstraints: NSLayoutConstraint!
    @IBOutlet private var activity: UIActivityIndicatorView!
    @IBOutlet private var btClose: UIButton!
    private var fontName: String = "Helvetica Neue"
    private var fontSize: CGFloat = 12
    private var fontColor: UIColor = .white
    private var tapedToHide: Bool = false
    private var isKeyboardObservAdded: Bool = false
    private var isKeyboardShowed: Bool = false
    private var originY: CGFloat {
        get{
            return self.view.frame.origin.y
        }
        set{
        }
    }
    private var setDistanceFromBottom: CGFloat {
        get {
            return 0
        }
        set{
        }
    }
    private var viewController: UIViewController!
    public var delegate: LCEMessagesDelegate?
    public var setBackgroundColor: UIColor = UIColor.cyan
    public var loadingColor: UIColor = UIColor.white
    public var setAnimationDuration: TimeInterval = 0.5
    public var setAnimationDelay: TimeInterval = 0.0
    public var setDirection: LCEMessagesDirection = .bottom
    public var setDuration: LCEMessagesDuration = .fiveSecs
    public var isHidden: Bool = true
    public var tapToDismiss: Bool = true
    public var setHeight: CGFloat = 70
    public var setWidth: CGFloat {
        get{
            return (UIApplication.shared.keyWindow?.bounds.width)!
        }
        set{
        }
    }
    
    static public func instantiate() -> LCEMessages {
        let instance: LCEMessages = LCEMessages.instantiate(storyBoard: "LCEMessages", identifier: LCEMessages.identifier)
        instance.loadView()
        instance.viewController = LCEssentials.getTopViewController(aboveBars: true)
        return instance
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        if !isKeyboardObservAdded {
            addObserverForKeyboard()
        }
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewController = LCEssentials.getTopViewController(aboveBars: true)
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func show(message withBody: String? = nil, withImage: UIImage? = nil, showLoading: Bool = false, viewController: UIViewController? = nil){
        self.viewWillAppear(true)
        if let _ = self.delegate {
            if let currentController = viewController {
                self.viewController = currentController
            }
            if let tabs = self.viewController?.tabBarController, !tabs.tabBar.isHidden {
                
            }
            if setDirection == .top && LCEssentials.X_DEVICES {
                self.iconActivityBottomConstraints.constant = 25
                self.labelBottomConstraints.constant = 25
            }
            //self.view.removeFromSuperview()
            var currOriginY: CGFloat = 0
            if setDirection == .top {
                currOriginY = -self.setHeight
            }else{
                if isKeyboardShowed {
                    currOriginY = originY
                }else{
                    currOriginY = (self.viewController?.view.bounds.height ?? 0 + self.setHeight)
                }
            }
            self.view.frame = CGRect(x: 0, y: currOriginY, width: setWidth, height: setHeight + ( LCEssentials.X_DEVICES ? 40 : 0 ) )
            self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleRightMargin, .flexibleBottomMargin]
            self.view.autoresizesSubviews = true
            self.viewController?.view.addSubview(self.view)
            self.view.layer.zPosition = 1
            self.view.layoutIfNeeded()
        }else{
            fatalError("Ops! Missing delegate!")
        }
        if showLoading {
            activity.isHidden = false
            activity.color = loadingColor
            iconActivityConstraints.constant = 30
        }
        if withImage != nil {
            iconImage.isHidden = false
            iconImage.image = withImage!
            iconImage.tintColor = UIColor.white
            iconActivityConstraints.constant = 30
        }
        if !showLoading && withImage == nil {
            iconActivityConstraints.constant = 0
        }
        
        if withBody != nil {
            lblBody.isHidden = false
            lblBody.text = withBody!
            lblBody.font = UIFont(name: fontName, size: fontSize)
            lblBody.textColor = fontColor
        }
        self.view.backgroundColor = setBackgroundColor
        self.tapedToHide = false
        
        if isHidden {
            anitamete()
        }
    }

    public func setFont(name: String = "Helvetica Neue", size:CGFloat = 12, color:UIColor? = nil){
        fontColor = color != nil ? color! : fontColor
        fontSize = size
        fontName = name
    }
    
    public func dismiss(completion: (() -> Void)? = nil){
        hidde {
            completion?()
        }
    }
    
    private func hidde(completion: (() -> Void)? = nil){
        if setDirection == .bottom {
            toBottom(completion: {
                self.delegate?.messages?(onDissmiss: self)
            })
        }else{
            toUp(completion: {
                self.delegate?.messages?(onDissmiss: self)
            })
        }
        isHidden = true
    }
    
    private func anitamete(completion: (() -> Void)? = nil){
        if setDirection == .bottom {
            toUp(completion: {
                completion?()
            })
        }else{
            toBottom(completion: {
                completion?()
            })
        }
        isHidden = false
    }
    
    private func toUp(completion:(()->Void)?){
        UIView.animate(withDuration: setAnimationDuration, delay: setAnimationDelay, options: [.curveEaseIn],
                       animations: {
                        self.view.frame.origin.y -= self.setHeight + ( LCEssentials.X_DEVICES ? 40 : 0 )
                        self.view.layoutIfNeeded()
        }, completion: {(_ completed: Bool) -> Void in
            completion?()
            if self.setDirection == .top {
                self.view.removeFromSuperview()
                self.view.frame.origin.y = self.originY
            }else{
                if self.setDuration != .forever {
                    LCEssentials.backgroundThread(delay: self.setDuration.rawValue, completion: {
                        if !self.tapedToHide {
                            self.hidde()
                        }
                    })
                }
            }
        })
    }
    
    private func toBottom(completion:(()->Void)?){
        UIView.animate(withDuration: setAnimationDuration, delay: setAnimationDelay, options: [.curveLinear],
                       animations: {
                        self.view.frame.origin.y += self.setDirection == .top ? (self.view.frame.origin.y * -1) : self.setHeight + ( LCEssentials.X_DEVICES ? 40 : 0 )
                        self.view.layoutIfNeeded()
        },  completion: {(_ completed: Bool) -> Void in
            if self.setDirection == .bottom {
                self.view.removeFromSuperview()
                self.view.frame.origin.y = self.originY
            }else{
                if self.setDuration != .forever {
                    LCEssentials.backgroundThread(delay: self.setDuration.rawValue, completion: {
                        if !self.tapedToHide {
                            self.hidde()
                        }
                    })
                }
            }
        })
    }
    
    @IBAction func tappedOnMessage(_ sender: Any){
        if tapToDismiss {
            tapedToHide = true
            hidde()
        }
        if delegate != nil { delegate?.messages?(didTapOnMessage: self) }
    }
    
    public func addObserverForKeyboard(){
        isKeyboardObservAdded = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    public func removeObserverForKeyboard(){
        isKeyboardObservAdded = false
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWasShown(notification: NSNotification){
        isKeyboardShowed = true
        let info = notification.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        let newOriginY: CGFloat = (self.viewController!.view.frame.height) - (keyboardSize!.height + ( isHidden ? 0 : self.setHeight) )
        if self.setDirection == .bottom {
            self.view.frame.origin = CGPoint(x: 0, y: newOriginY)
            originY = newOriginY
        }
    }
    
    @objc private func keyboardWillBeHidden(notification: NSNotification){
        isKeyboardShowed = false
        if self.setDirection == .bottom && (self.delegate is UIViewController) && isKeyboardObservAdded {
            UIView.animate(withDuration: 1) {
                let newOriginY: CGFloat = (self.delegate as! UIViewController).view.frame.size.height - ( self.isHidden ? 0 : self.setHeight  + ( LCEssentials.X_DEVICES ? 40 : 0 ) )
                self.view.frame.origin = CGPoint(x: 0, y: newOriginY)
                self.originY = newOriginY
            }
        }
    }
    
    deinit {
        removeObserverForKeyboard()
    }
}
#endif
