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

@objc public protocol LCSingletonDelegate: class {
    @objc optional var dictParams: [String:Any]? { get set }
    @objc optional var arrayParams: [[String:Any]]? { get set }
    
    @objc(updateViewController:)
    optional func update(viewController: AnyObject)
    
    @objc(setParamsDictWithParams:)
    optional func setParamsDict(params: [String:Any]?)
    
    @objc(setParamsArrayWithParams:)
    optional func setParamsArray(params: [[String:Any]]?)
}

public class LCSingleton: UIViewController {
    public weak var delegate: LCSingletonDelegate? = nil
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func singleton(update viewController: LCSingleton){
        self.delegate?.update!(viewController: viewController)
    }
    
    public func singleton(setDictParams params: [String:Any]){
        self.delegate?.setParamsDict!(params: params)
    }
    
    public func singleton(setArrayParams params: [[String:Any]]){
        self.delegate?.setParamsArray!(params: params)
    }
}


extension LCSingleton {
    
}
