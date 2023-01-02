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
 

import UIKit

public extension Optional {
    /// Get self of default value (if self is nil).
    ///
    ///        let foo: String? = nil
    ///        print(foo.unwrapped(or: "bar")) -> "bar"
    ///
    ///        let bar: String? = "bar"
    ///        print(bar.unwrapped(or: "foo")) -> "bar"
    ///
    /// - Parameter defaultValue: default value to return if self is nil.
    /// - Returns: self if not nil or default value if nil.
    func unwrapped(or defaultValue: Wrapped) -> Wrapped {
        // http://www.russbishop.net/improving-optionals
        return self ?? defaultValue
    }

    /// Gets the wrapped value of an optional. If the optional is `nil`, throw a custom error.
    ///
    ///        let foo: String? = nil
    ///        try print(foo.unwrapped(or: MyError.notFound)) -> error: MyError.notFound
    ///
    ///        let bar: String? = "bar"
    ///        try print(bar.unwrapped(or: MyError.notFound)) -> "bar"
    ///
    /// - Parameter error: The error to throw if the optional is `nil`.
    /// - Returns: The value wrapped by the optional.
    /// - Throws: The error passed in.
    func unwrapped(or error: Error) throws -> Wrapped {
        guard let wrapped = self else { throw error }
        return wrapped
    }

    /// Runs a block to Wrapped if not nil
    ///
    ///        let foo: String? = nil
    ///        foo.run { unwrappedFoo in
    ///            // block will never run sice foo is nill
    ///            print(unwrappedFoo)
    ///        }
    ///
    ///        let bar: String? = "bar"
    ///        bar.run { unwrappedBar in
    ///            // block will run sice bar is not nill
    ///            print(unwrappedBar) -> "bar"
    ///        }
    ///
    /// - Parameter block: a block to run if self is not nil.
    func run(_ block: (Wrapped) -> Void) {
        // http://www.russbishop.net/improving-optionals
        _ = map(block)
    }
}
