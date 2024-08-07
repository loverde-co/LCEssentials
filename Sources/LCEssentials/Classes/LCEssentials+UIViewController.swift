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

#if os(iOS) || os(macOS)
import UIKit
import QuartzCore

public enum ToastPosition {
    case top
    case down
}

public extension UIViewController {
    
    var isVisible: Bool {
        // http://stackoverflow.com/questions/2777438/how-to-tell-if-uiviewcontrollers-view-is-visible
        return isViewLoaded && view.window != nil
    }
    
    var isLoaded: Bool {
        return isVisible
    }
    
    var isModal: Bool {
        if let index = navigationController?.viewControllers.firstIndex(of: self), index > 0 {
            return false
        } else if presentingViewController != nil {
            return true
        } else if navigationController?.presentingViewController?.presentedViewController == navigationController {
            return true
        } else if tabBarController?.presentingViewController is UITabBarController {
            return true
        } else {
            return false
        }
    }
    
    @objc func dismissSystemKeyboard(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            self.view.endEditing(true)
        }
        sender.cancelsTouchesInView = false
    }
    
    static var identifier: String {
        return "id"+className
    }
    static var segueID: String {
        return "idSegue"+className
    }
    static var className: String {
        return String(describing: self)
    }
    
    static func instantiate<T: UIViewController>(storyBoard: String, identifier: String? = nil, bundle: Bundle? = Bundle(for: T.self)) -> T {
        let storyboard = UIStoryboard(name: storyBoard, bundle: bundle)
        var identf = T.identifier
        if let id = identifier {
            identf = id
        }
        let controller = storyboard.instantiateViewController(withIdentifier: identf) as! T
        return controller
    }
    
    static func instatiate<T: UIViewController>(nibName: String, bundle: Bundle? = nil) -> T {
        let controller = T(nibName: nibName, bundle: bundle)
        controller.awakeFromNib()
        controller.view.updateConstraints()
        controller.view.layoutIfNeeded()
        return controller
    }
    
    func present(viewControllerToPresent: UIViewController, completion: @escaping ()->()) {
        CATransaction.begin()
        self.present(viewControllerToPresent, animated: true) {
            CATransaction.setCompletionBlock(completion)
        }
        CATransaction.commit()
    }
    
    func closeController(jumpToController: UIViewController? = nil, completion: @escaping ()->()){
        if self.isModal {
            self.dismiss(animated: true) {
                completion()
            }
            return
        }
        guard let jump = jumpToController else {
            self.navigationController?.popViewController(animated: true, {
                completion()
            })
            return
        }
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.navigationController?.popToViewController(jump, animated: true)
        CATransaction.commit()
        
    }
    
    /// - Parameters:
    ///   - name: notification name.
    ///   - selector: selector to run with notified.
    func addNotificationObserver(name: Notification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
    }

    ///
    /// - Parameter name: notification name.
    func removeNotificationObserver(name: Notification.Name) {
        NotificationCenter.default.removeObserver(self, name: name, object: nil)
    }

    /// Unassign as listener from all notifications.
    func removeNotificationsObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func show(toastWith message: String,
              font: UIFont = UIFont.systemFont(ofSize: 12),
              toastPosition: ToastPosition,
              backgroundColor: UIColor = .black,
              textColor: UIColor = .white,
              duration: TimeInterval = 3.0) {

        let yPostition = toastPosition == .top ? (UIDevice.hasNotch ? 44 : 24) : self.view.frame.size.height - 44 - 16//margin

        let frame = CGRect(x: 30,
                           y: yPostition,
                           width: UIScreen.main.bounds.width - 60,
                           height: 44)

        let toast = UILabel(frame: frame)
        toast.backgroundColor = backgroundColor.withAlphaComponent(0.7)
        toast.textColor = textColor
        toast.textAlignment = .center;
        toast.font = font
        toast.text = message
        toast.alpha = 1.0
        toast.layer.cornerRadius = 10;
        toast.clipsToBounds  =  true
        self.view.addSubview(toast)

        UIView.animate(withDuration: duration, delay: 4, options: .curveEaseInOut, animations: {
            toast.alpha = 0.0
        }, completion: {(isCompleted) in
            toast.removeFromSuperview()
        })
    }
}
#endif
