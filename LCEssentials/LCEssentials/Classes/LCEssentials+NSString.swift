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

public extension NSString {

    public func randomAlphaNumericString(_ length: Int = 8) -> String {

        let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let allowedCharsCount = UInt32(allowedChars.count)
        var randomString = ""

        for _ in (0..<length) {
            let randomNum = Int(arc4random_uniform(allowedCharsCount))
            let newCharacter = allowedChars[allowedChars.index(allowedChars.startIndex, offsetBy: randomNum)]
            randomString += String(newCharacter)
        }

        return randomString
    }

    public func removeCurrencyBRFormat(_ string:NSString) -> NSString {

        //let string       = "4567,89"
        var toArray         = string.components(separatedBy: "R$ ")
        var backToString    = toArray.joined(separator: "")
        toArray             = backToString.components(separatedBy: ".")
        backToString        = toArray.joined(separator: "")
        toArray             = backToString.components(separatedBy: ",")
        backToString        = toArray.joined(separator: ".")

        return backToString as NSString
    }

    public func createDirectory(_ directoryName: NSString) -> Bool {

        let documentsPath = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        let logsPath = documentsPath.appendingPathComponent(directoryName as String)
        do {
            try FileManager.default.createDirectory(atPath: logsPath.path, withIntermediateDirectories: true, attributes: nil)
            return true
        } catch let error as NSError {
            NSLog("Unable to create directory \(error.debugDescription)")
            return false
        }


    }


}
