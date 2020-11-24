//  
// Copyright (c) 2020 Loverde Co.
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
@objc public protocol HUDAlertControllerDelegate {
    @objc optional func alert(didOpen alert: HUDAlertController)
    @objc optional func alert(didClose alert: HUDAlertController)
}

public enum HUDAlertActionType: Int {
    case cancel = 0
    case normal = 1
    case destructive = 2
    case discrete = 3
    case green = 4
}

public class HUDAlertAction {
    
    public typealias CompletionBlock = () -> Void
    
    var title: String = ""
    var tag: Int = 0
    var type: HUDAlertActionType = .cancel
    var completionBlock: CompletionBlock? = nil
    
    public convenience init(_ title: String, _ type: HUDAlertActionType, _ block: CompletionBlock?) {
        self.init()
        //
        self.title = title
        self.type = type
        self.completionBlock = block
    }
}

public class HUDAlertController: UIViewController {

    public var delegate: HUDAlertControllerDelegate?
    public var isLoadingAlert: Bool = true
    private lazy var actions: [HUDAlertAction] = [HUDAlertAction]()
    private let greenColor: UIColor = UIColor(hex: "609c70")
    private let redColor: UIColor = UIColor(hex: "a32a2e")
    private let blueColor: UIColor = UIColor(hex: "2a50a8")
    private let greyColor: UIColor = UIColor(hex: "a6a6a6")
    private var viewController: UIViewController!
    
    @IBOutlet private var rotatinProgress: RotatingCircularGradientProgressBar!
    @IBOutlet private var imageHeight: NSLayoutConstraint!
    @IBOutlet private var lblTitle: UILabel!
    @IBOutlet private var lblDescr: UILabel!
    @IBOutlet private var stackView: UIStackView!
    @IBOutlet private var stackHeight: NSLayoutConstraint!
    @IBOutlet private var containerView: UIView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    static public func instantiate() -> HUDAlertController {
        let instance: HUDAlertController = HUDAlertController.instantiate(storyBoard: "HUDAlertController", identifier: HUDAlertController.identifier)
        instance.loadView()
        return instance
    }

    private func setupView(){
    }
    
    public func setAlert(with title: String, description: String? = nil, viewController: UIViewController? = nil, options: [HUDAlertAction]? = nil){
        self.viewController = LCEssentials.getTopViewController()
        if let currentController = viewController {
            self.viewController = currentController
        }
        self.view.removeFromSuperview()
        self.removeFromParent()
        
        if isLoadingAlert {
            rotatinProgress.progress = 0.8
            imageHeight.constant = 40
        }else{
            rotatinProgress.progress = 0
            imageHeight.constant = 0
        }
        
        self.containerView.cornerRadius = 8
        self.lblTitle.text = title
        if let desc = description {
            self.lblDescr.text = desc
        }else{
            self.lblDescr.text = nil
        }
        self.actions.removeAll()
        self.stackView.removeArrangedSubviews()
        var internalTag: Int = 0
        var totalHeight: CGFloat = 0.0
        if let options = options {
            for action in options {
                totalHeight += 45.0
                let button: UIButton = UIButton(type: .custom)
                button.frame = CGRect(x: 0, y: 0, width: stackView.frame.width, height: 45)
                button.tag = internalTag
                internalTag += 1
                button.isExclusiveTouch = true
                button.isUserInteractionEnabled = true
                button.addTarget(self, action: #selector(self.actionButton(sender:)), for: .touchUpInside)
                
                switch action.type {
                case .cancel:
                    button.cornerRadius = 5
                    button.borderWidth = 1
                    button.borderColor = blueColor
                    button.backgroundColor = .white
                    button.setTitleForAllStates(action.title)
                    button.setTitleColor(blueColor, for: .normal)
                    
                case .destructive:
                    button.cornerRadius = 5
                    button.backgroundColor = redColor
                    button.setTitleForAllStates(action.title)
                    button.setTitleColor(.white, for: .normal)
                    
                case .normal:
                    button.cornerRadius = 5
                    button.backgroundColor = blueColor
                    button.setTitleForAllStates(action.title)
                    button.setTitleColor(.white, for: .normal)
                    
                case .discrete:
                    button.cornerRadius = 5
                    button.backgroundColor = greyColor
                    button.setTitleForAllStates(action.title)
                    button.setTitleColor(.white, for: .normal)
                case .green:
                    button.cornerRadius = 5
                    button.backgroundColor = greenColor
                    button.setTitleForAllStates(action.title)
                    button.setTitleColor(.white, for: .normal)
                }
                self.actions.append(action)
                self.stackView.addArrangedSubview(button)
                self.stackView.spacing = 10
                totalHeight += (CGFloat(self.actions.count - 1) * 10.0)
                self.stackHeight.constant = totalHeight
                self.stackView.isHidden = false
            }
        }else{
            self.actions.removeAll()
            self.stackView.removeArrangedSubviews()
            self.stackView.spacing = 0
            self.stackHeight.constant = 0
            self.stackView.isHidden = true
        }
        
        self.viewController.view.addSubview(self.view)
        self.viewController.view.bringSubviewToFront(self.view)
        self.viewController.addChild(self)
        self.view.layoutSubviews()
        
    }
    
    public func setFontTitle(name: String, size: CGFloat = 12, color: UIColor = .black){
        lblTitle.font = UIFont(name: name, size: size)
        lblTitle.textColor = color
    }
    
    public func setFontDescription(name: String, size: CGFloat = 12, color: UIColor = .black){
        lblDescr.font = UIFont(name: name, size: size)
        lblDescr.textColor = color
    }
    
    public func showAlert(){
        animateIn {
            self.delegate?.alert?(didOpen: self)
        }
    }
    
    public func closeAlert(){
        animateOut {
            self.view.removeFromSuperview()
            self.delegate?.alert?(didClose: self)
        }
    }
    @objc private func actionButton(sender: UIButton) {
        let action = self.actions[sender.tag]
        if let block = action.completionBlock {
            //stackView.isUserInteractionEnabled = false
            //
            self.closeAlert()
            block()
        } else {
            self.closeAlert()
        }
    }
    private func animateIn(completion: @escaping() -> Void) {
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.allowUserInteraction, .allowAnimatedContent, .curveEaseOut], animations: {
            self.view.alpha = 1.0
        }) { (completed) in
            self.performSpringAnimationIn(for: self.containerView) {
                completion()
            }
        }
    }
    
    private func animateOut(completion: @escaping() -> Void) {
        
        self.performSpringAnimationOut(for: self.containerView) {
            UIView.animate(withDuration: 0.1, delay: 0.0, options: [.allowUserInteraction, .allowAnimatedContent, .curveEaseIn], animations: {
                self.view.alpha = 0.0
            }) { (completed) in
                completion()
            }
        }
    }
    
    private func performSpringAnimationIn(for view: UIView, completion: @escaping() -> Void) {
        view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        //
        UIView.animate(withDuration: 0.15, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            view.transform = CGAffineTransform(scaleX: 1, y: 1)
            view.alpha = 1.0
        }) { (completed) in
            completion()
        }
    }
    
    
    private func performSpringAnimationOut(for view: UIView, completion: @escaping() -> Void) {
        UIView.animate(withDuration: 0.15, animations: {
            view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            view.alpha = 0.0
        }) { (completed) in
            completion()
        }
    }
    
}
#endif
