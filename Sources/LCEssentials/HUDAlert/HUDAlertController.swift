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
@objc public protocol HUDAlertViewControllerDelegate {
    @objc optional func didOpen(alert: HUDAlertViewController)
    @objc optional func didClose(alert: HUDAlertViewController)
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
    
    public convenience init(title: String, type: HUDAlertActionType, _ completion: (() -> Void)? = nil) {
        self.init()
        //
        self.title = title
        self.type = type
        self.completionBlock = completion
    }
}

public class HUDAlertViewController: UIViewController {
    
    fileprivate var viewController: UIViewController
    
    lazy var actions: [HUDAlertAction] = []
    
    let greenColor: UIColor = UIColor(hex: "609c70")
    let redColor: UIColor = UIColor(hex: "a32a2e")
    let blueColor: UIColor = UIColor(hex: "2a50a8")
    let greyColor: UIColor = UIColor(hex: "a6a6a6")
    
    public weak var delegate: HUDAlertViewControllerDelegate?
    public var isLoadingAlert: Bool = true

    public var customView: HUDAlertView {
        return (view as? HUDAlertView) ?? HUDAlertView()
    }
    
    public init() {
        self.viewController = UIViewController()
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required public init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        view = HUDAlertView()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        if isLoaded {
            printLog(title: "VIEW DIDLOAD", msg: "IS LOADED", prettyPrint: true)
        }
    }
    
    public func setTitle(_ title: String = "", font: UIFont = UIFont.systemFont(ofSize: 16.0), color: UIColor = .black) {
        self.customView.titleLabel.text = title
        self.customView.titleLabel.font = font
        self.customView.titleLabel.textColor = color
    }
    
    public func setDescription(_ desc: String = "", font: UIFont = .systemFont(ofSize: 14.0), color: UIColor = .black) {
        self.customView.descLabel.text = desc
        self.customView.descLabel.font = font
        self.customView.descLabel.textColor = color
    }
    
    public func configureAlertWith(title: String,
                                   description: String? = nil,
                                   viewController: UIViewController? = nil,
                                   actionButtons: [HUDAlertAction] = []) {
        
        if let viewController {
            self.viewController = viewController
        } else if let topViewController = LCEssentials.getTopViewController(aboveBars: true) {
            self.viewController = topViewController
        } else {
            fatalError("Ops! No UIViewController was found.")
        }
        
        if self.isLoadingAlert {
            self.customView.rotatinProgress.progress = 0.8
            self.customView.rotatinProgress.heightConstraint?.constant = 40
        }else{
            self.customView.rotatinProgress.progress = 0
            self.customView.rotatinProgress.heightConstraint?.constant = 0
        }
        
        self.customView.containerView.cornerRadius = 8
        self.customView.titleLabel.text = title
        self.customView.descLabel.text = description
        self.actions.removeAll()
        self.customView.stackButtons.removeAllArrangedSubviews()
        
        if !actionButtons.isEmpty {
            
            for (index, element) in actionButtons.enumerated() {
                
                lazy var button: UIButton = {
                    $0.isOpaque = true
                    $0.translatesAutoresizingMaskIntoConstraints = false
                    $0.setTitleForAllStates(element.title)
                    $0.tag = index
                    $0.isExclusiveTouch = true
                    $0.isUserInteractionEnabled = true
                    $0.cornerRadius = 5
                    $0.setHeight(size: 47.0)
                    $0.addTarget(self, action: #selector(self.actionButton(sender:)), for: .touchUpInside)
                    return $0
                }(UIButton(type: .custom))
                
                switch element.type {
                case .cancel:
                    button.borderWidth = 1
                    button.borderColor = self.blueColor
                    button.backgroundColor = .white
                    button.setTitleColorForAllStates(self.blueColor)
                case .destructive:
                    button.borderWidth = 0
                    button.borderColor = nil
                    button.backgroundColor = self.redColor
                    button.setTitleColorForAllStates(.white)
                case .normal:
                    button.borderWidth = 0
                    button.borderColor = nil
                    button.backgroundColor = self.blueColor
                    button.setTitleColorForAllStates(.white)
                case .discrete:
                    button.borderWidth = 0
                    button.borderColor = nil
                    button.backgroundColor = self.greyColor
                    button.setTitleColorForAllStates(.white)
                case .green:
                    button.borderWidth = 0
                    button.borderColor = nil
                    button.backgroundColor = self.greenColor
                    button.setTitleColorForAllStates(.white)
                }
                
                self.customView.stackButtons.isHidden = false
                self.customView.stackButtons.spacing = 10
                self.customView.stackButtons.heightConstraint?.isActive = false
                self.customView.stackButtons.addArrangedSubview(button)
                self.actions.append(element)
            }
        } else {
            self.actions.removeAll()
            self.customView.stackButtons.removeAllArrangedSubviews()
            self.customView.stackButtons.spacing = 0
            self.customView.stackButtons.heightConstraint?.isActive = true
            self.customView.stackButtons.heightConstraint?.constant = 0
            self.customView.stackButtons.isHidden = true
        }
    }
    
    @objc private func actionButton(sender: UIButton) {
        self.actions[exist: sender.tag]?.completionBlock?()
        self.closeAlert()
    }
    
    public func showAlert(){
        if self.presentingViewController != nil {
            self.closeAlert()
            LCEssentials.backgroundThread(delay: 0.2, completion: {
                self.showAlert()
            })
            return
        }
        
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overFullScreen
        
        self.viewController.present(self, animated: false, completion: {
            self.animateIn {
                self.delegate?.didOpen?(alert: self)
            }
        })
    }
    
    public func closeAlert(){
        animateOut {
            self.dismiss(animated: false) {
                self.delegate?.didClose?(alert: self)
            }
        }
    }
    
    private func animateIn(completion: @escaping() -> Void) {
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.allowUserInteraction, .allowAnimatedContent, .curveEaseOut], animations: {
            self.view.alpha = 1.0
        }) { (completed) in
            self.performSpringAnimationIn(for: self.customView.containerView) {
                completion()
            }
        }
    }
    
    private func animateOut(completion: @escaping() -> Void) {
        
        self.performSpringAnimationOut(for: self.customView.containerView) {
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
