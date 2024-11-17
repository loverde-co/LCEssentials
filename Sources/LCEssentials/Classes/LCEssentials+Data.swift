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
import CryptoKit
import CommonCrypto


public extension Data {
    
    var prettyJson: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = String(data: data, encoding:.utf8) else { return nil }
        
        return prettyPrintedString
    }
    
    var toDictionay: Dictionary<String, Any>? {
        do {
            return try JSONSerialization.jsonObject(with: self, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    init?(hexString: String) {
        let cleanHex = hexString.replacingOccurrences(of: " ", with: "")
        let length = cleanHex.count / 2
        var data = Data(capacity: length)
        
        for i in 0..<length {
            let start = cleanHex.index(cleanHex.startIndex, offsetBy: i*2)
            let end = cleanHex.index(start, offsetBy: 2)
            guard let byte = UInt8(cleanHex[start..<end], radix: 16) else {
                return nil
            }
            data.append(byte)
        }
        
        self = data
    }
    
    func HMACSHA512(key: Data) -> Data {
        var hmac = HMAC<SHA512>.init(key: SymmetricKey(data: key))
        hmac.update(data: self)
        return Data(hmac.finalize())
    }
    
    func SHA512() -> Data {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
        self.withUnsafeBytes {
            _ = CC_SHA512($0.baseAddress, CC_LONG(self.count), &digest)
        }
        return Data(digest)
    }
    
    func XOR(with other: Data) -> Data {
        return Data(zip(self, other).map { $0 ^ $1 })
    }
    
    func SHA256() -> Data {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        self.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(self.count), &digest)
        }
        return Data(digest)
    }
    
    func object<T: Codable>() -> T? {
        do {
            let outPut: T = try JSONDecoder.decode(data: self)
            return outPut
        } catch {
            printError(title: "DATA DECODE ERROR", msg: error.localizedDescription, prettyPrint: true)
            return nil
        }
    }
    
    func toHexString() -> String {
        return `lazy`.reduce("") {
            var s = String($1, radix: 16)
            if s.count == 1 {
                s = "0" + s
            }
            return $0 + s
        }
    }
    
    ///Loverde Co.: MD5 - Data
    /////Test:
    ///let md5Data = Data.MD5(string:"Hello")
    ///
    ///let md5Hex =  md5Data.toHexString()
    ///print("md5Hex: \(md5Hex)")
    @available(iOS 13.0, *)
    static func MD5(string: String) -> Data {
        let messageData = string.data(using: .utf8)!
        let digestData = Insecure.MD5.hash (data: messageData)
        let digestHex = String(digestData.map { String(format: "%02hhx", $0) }.joined().prefix(32))
        return Data(digestHex.utf8)
    }
}
