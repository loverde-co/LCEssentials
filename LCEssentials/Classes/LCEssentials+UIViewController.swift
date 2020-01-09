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
import QuartzCore

public extension UIViewController {
    static var identifier: String {
        return "id"+String(describing: self)
    }
    static var segueID: String {
        return "idSegue"+String(describing: self)
    }
    static func instantiate<T: UIViewController>(storyBoard: String, identifier: String? = nil) -> T {
        let storyboard = UIStoryboard(name: storyBoard, bundle: Bundle(for: T.self))
        var identf = ""
        if let id = identifier {
            identf = id
        }else{
            identf = T.identifier
        }
        let controller = storyboard.instantiateViewController(withIdentifier: identf) as! T
        return controller
    }
    
    func present(viewControllerToPresent: UIViewController, completion: @escaping ()->()) {
        CATransaction.begin()
        self.present(viewControllerToPresent, animated: true) {
            CATransaction.setCompletionBlock(completion)
        }
        CATransaction.commit()
    }
}
#endif
