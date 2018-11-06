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
    @objc optional func singleton(get object: Any, withData: Any)
    @objc optional func singleton(set object: Any, withData: Any)
}

public class LCSingleton: NSObject {
    public weak var delegate: LCSingletonDelegate? = nil
    public var object: Any?
    public var data: Any?
    
    public func singleton(set object: Any, withData: Any){
        delegate?.singleton?(get: object, withData: withData)
    }
    
    public func singleton(get object: Any, withData: Any){
        self.object = object
        self.data = withData
        delegate?.singleton?(set: self.object!, withData: self.data!)
    }
}
