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

@objc public protocol LCMessagesDelegate {
    @objc optional func messages(didTapOnMessage: LCMessages)
}

public enum LCMessagesDirection {
    case top
    case bottom
}

public enum LCMessagesDuration: Double {
    case forever = 0
    case twoSec = 2
    case fiveSecs = 5
    case eightSecs = 8
}

public class LCMessages: UIViewController {
    
    @IBOutlet private var lblBody: UILabel!
    @IBOutlet private var iconImage: UIImageView!
    @IBOutlet private var iconActivityConstraints: NSLayoutConstraint!
    @IBOutlet private var activity: UIActivityIndicatorView!
    @IBOutlet private var btClose: UIButton!
    private var rootViewController = UIApplication.shared.keyWindow?.rootViewController!
    private var referenceView: UIViewController!
    private var isKeyboardObservAdded: Bool = false
    private var originY: CGFloat {
        get{
            return self.view.frame.origin.y
        }
        set{
        }
    }
    private var setDistanceFromBottom: CGFloat {
        get {
            var newDistance: CGFloat = 0
            if UIDevice().modelName == "iPhone X" && setDirection == .bottom {
                newDistance = newDistance + 50
            }
            return newDistance
        }
        set{
            self.setDistanceFromBottom = newValue
        }
    }
    public var delegate: LCMessagesDelegate?
    public var setTitleColor: UIColor = UIColor.white
    public var setBodyColor: UIColor = UIColor.white
    public var setBackgroundColor: UIColor = UIColor.cyan
    public var loadingColor: UIColor = UIColor.white
    public var setAnimationDuration: TimeInterval = 0.5
    public var setAnimationDelay: TimeInterval = 0.0
    public var setDirection: LCMessagesDirection = .bottom
    public var setDuration: LCMessagesDuration = .fiveSecs
    public var isHidden: Bool = true
    public var tapToDismiss: Bool = true
    public var setHeight: CGFloat {
        get{
            return 70
        }
        set {
            self.setHeight = newValue
        }
    }
    public var setWidth: CGFloat {
        get{
            return (UIApplication.shared.keyWindow?.bounds.width)!
        }
        set{
            self.setWidth = newValue
        }
    }
    
    static public func instantiate() -> LCMessages {
        let storyboard = UIStoryboard(name: "LCMessages", bundle: Bundle(for: LCMessages.self))
        let controller = storyboard.instantiateViewController(withIdentifier: "idLCMessages") as! LCMessages
        return controller
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        if !isKeyboardObservAdded {
            addObserverForKeyboard()
        }
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.frame.origin.y = setDirection == .top ? (self.setDistanceFromBottom - self.setHeight) : ( self.view.frame.origin.y == 0 ? (referenceView.view.frame.height - setDistanceFromBottom) : self.view.frame.origin.y + self.view.frame.size.height )
        originY = self.view.frame.origin.y
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func show(withBody: String? = nil, withImage: UIImage? = nil, showLoading: Bool = false, showInView: UIView? = nil){
        if self.delegate is UIViewController {
            if showInView != nil {
                referenceView = showInView!.getParentViewController()
                if referenceView.navigationController != nil && setDirection == .top {
                    if (referenceView.navigationController?.isNavigationBarHidden)! {
                        setDistanceFromBottom = 0
                    }else{
                        setDistanceFromBottom = (referenceView.navigationController?.navigationBar.frame.height)!
                    }
                }
                self.view.removeFromSuperview()
                self.view.frame = CGRect(x: 0, y: originY , width: setWidth, height: setHeight)
                self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleRightMargin, .flexibleBottomMargin]
                self.view.autoresizesSubviews = true
                referenceView.view.addSubview(self.view)
                self.view.layer.zPosition = 1
            }else{
                DispatchQueue.main.async {
                    self.referenceView = self.rootViewController!
                    self.rootViewController?.view.addSubview(self.view)
                    self.referenceView.addChildViewController(self)
                }
            }
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
            lblBody.textColor = setBodyColor
        }
        self.view.backgroundColor = setBackgroundColor
        if isHidden {
            anitamete()
        }
    }
    
    public func dismiss(){
        hidde()
    }
    
    private func hidde(){
        if setDirection == .bottom {
            toBottom()
        }else{
            toUp()
        }
        isHidden = true
    }
    
    private func anitamete(){
        if setDirection == .bottom {
            toUp()
        }else{
            toBottom()
        }
        isHidden = false
    }
    
    private func toUp(){
        UIView.animate(withDuration: setAnimationDuration, delay: setAnimationDelay, options: [.curveEaseIn],
                       animations: {
                        self.view.frame.origin.y -= self.setHeight
                        self.view.layoutIfNeeded()
        }, completion: {(_ completed: Bool) -> Void in
            if self.setDirection == .top {
                self.view.removeFromSuperview()
                self.view.frame.origin.y = 0
            }else{
                if self.setDuration != .forever {
                    Defaults().backgroundThread(delay: self.setDuration.rawValue, completion: {
                        self.hidde()
                    })
                }
            }
        })
    }
    
    private func toBottom(){
        UIView.animate(withDuration: setAnimationDuration, delay: setAnimationDelay, options: [.curveLinear],
                       animations: {
                        self.view.frame.origin.y += self.setDirection == .top ? (self.view.frame.origin.y * -1) : self.setHeight
                        self.view.layoutIfNeeded()
        },  completion: {(_ completed: Bool) -> Void in
            if self.setDirection == .bottom {
                self.view.removeFromSuperview()
                self.view.frame.origin.y = 0
            }else{
                if self.setDuration != .forever {
                    Defaults().backgroundThread(delay: self.setDuration.rawValue, completion: {
                        self.hidde()
                    })
                }
            }
        })
    }
    
    @IBAction public func tappedOnMessage(_ sender: Any){
        if tapToDismiss { hidde() }
        if delegate != nil { delegate?.messages?(didTapOnMessage: self) }
    }
    
    public func addObserverForKeyboard(){
        isKeyboardObservAdded = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc private func keyboardWasShown(notification: NSNotification){
        //print("LCMessages VAI EXIBIR TECLADO")
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        if self.setDirection == .bottom {
            var reference: UIViewController!
            if self.referenceView != nil {
                reference = self.referenceView
            }else{
                reference = self.delegate as! UIViewController
            }
            self.view.frame.origin = CGPoint(x: 0, y: (reference.view.frame.size.height) - (keyboardSize!.height + self.setHeight ) )
        }
    }
    
    @objc private func keyboardWillBeHidden(notification: NSNotification){
        //print("LCMessages VAI ESCONDER TECLADO")
        if !isHidden && self.setDirection == .bottom {
            UIView.animate(withDuration: 1) {
                self.view.frame.origin = CGPoint(x: 0, y: self.referenceView.view.frame.size.height - self.setHeight )
            }
        }
    }
    
    deinit {
        isKeyboardObservAdded = false
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
}
