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

public extension UIViewController {
    
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
            self.navigationController?.popViewControllerWithHandler {
                completion()
            }
            return
        }
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.navigationController?.popToViewController(jump, animated: true)
        CATransaction.commit()
        
    }
}
#endif
