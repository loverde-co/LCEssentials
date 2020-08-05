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
@objc public protocol LCENotifiactionRunTimeDelegate {
    @objc optional func messages(didTapOnMessage: LCENotificationRunTime, withData: Any?)
    @objc optional func messages(didSwipeOnMessage: LCENotificationRunTime, withData: Any?)
}

public class LCENotificationRunTime: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    public var setAnimationDuration: TimeInterval = 0.5
    public var setAnimationDelay: TimeInterval = 0.0
    public var setDuration: Double = 5
    public var isHidden: Bool = true
    public var setHeight:CGFloat = 130
    public var setTitle: String? {
        didSet {
            lblTitle.text = setTitle
        }
    }
    public var setDesc: String? {
        didSet {
            lblDesc.text = setDesc
        }
    }
    public var setImage: UIImage? {
        didSet {
            image.image = setImage
        }
    }
    
    @IBOutlet weak var swipeUp: UISwipeGestureRecognizer!
    @IBOutlet weak var tap: UITapGestureRecognizer!
    private var rootView: UIView?
    public var anyData: Any?
    public var delegate: LCENotifiactionRunTimeDelegate?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}

extension LCENotificationRunTime {
    
    static public func instantiate() -> LCENotificationRunTime {
        let instance: LCENotificationRunTime = LCENotificationRunTime.instantiate(storyBoard: "LCENotificationRunTime", identifier: LCENotificationRunTime.identifier)
        instance.loadView()
        return instance
    }
    
    public func show(){
        self.isHidden = true
        rootView = UIApplication.shared.keyWindow?.subviews.last
        self.view.frame.origin.y = self.view.frame.origin.y - setHeight
        self.view.addGestureRecognizer(swipeUp)
        self.view.addGestureRecognizer(tap)
        self.view.layer.removeAllAnimations()
        self.view.removeFromSuperview()
        self.view.frame = CGRect(x: 0, y: -self.setHeight, width: self.view.frame.size.width, height: self.setHeight)
        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleRightMargin, .flexibleBottomMargin]
        self.view.autoresizesSubviews = true
        if let root = rootView {
            root.addSubview(self.view)
            root.bringSubview(toFront: self.view)
            if let controller = root.getParentViewController() {
                controller.addChildViewController(self)
            }
        }
        self.view.layer.zPosition = 1
        if isHidden {
            isHidden = false
            moveDown()
        }
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
    
    private func moveUp(){
        UIView.animate(withDuration: setAnimationDuration, delay: setAnimationDelay, options: [.curveEaseIn],
                       animations: {
                        self.view.frame.origin.y -= self.setHeight
                        self.view.layoutIfNeeded()
        }, completion: {(_ completed: Bool) -> Void in
            //self.view.removeFromSuperview()
            self.isHidden = true
        })
    }
    
    private func moveDown(){
        UIView.animate(withDuration: setAnimationDuration, delay: setAnimationDelay, options: [.curveEaseIn],
                       animations: {
                        self.view.frame.origin.y += self.setHeight
                        self.view.layoutIfNeeded()
        }, completion: {(_ completed: Bool) -> Void in
            //self.view.removeFromSuperview()
            LCEssentials.backgroundThread(delay: self.setDuration, completion: {
                self.moveUp()
            })
        })
    }
    
    @IBAction func handlerSwipeGesture(gesture: UISwipeGestureRecognizer){
        if gesture.direction == UISwipeGestureRecognizerDirection.up {
            //LCEssentials.printWarn(title: "GESTURE SWIPE", msg: "TO UP")
            self.delegate?.messages?(didSwipeOnMessage: self, withData: anyData)
            self.moveUp()
        }
    }
    
    @IBAction func handlerTapGesture(gesture: UITapGestureRecognizer){
        if gesture.numberOfTapsRequired == 1 {
            //LCEssentials.printWarn(title: "GESTURE TAP", msg: "ONE")
            self.delegate?.messages?(didTapOnMessage: self, withData: anyData)
            self.moveUp()
        }
    }
}
extension LCENotificationRunTime: UIGestureRecognizerDelegate {
    
}

#endif
