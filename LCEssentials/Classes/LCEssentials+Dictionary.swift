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

extension Dictionary {

    //MARK: - Append Dictionary
    static func += (lhs: inout [Key: Value], rhs: [Key: Value]) {
        rhs.forEach { lhs[$0] = $1}
    }

    /// SwifterSwift: Remove keys contained in the sequence from the dictionary
    ///
    ///        let dict: [String: String] = ["key1": "value1", "key2": "value2", "key3": "value3"]
    ///        let result = dict-["key1", "key2"]
    ///        result.keys.contains("key3") -> true
    ///        result.keys.contains("key1") -> false
    ///        result.keys.contains("key2") -> false
    ///
    /// - Parameters:
    ///   - lhs: dictionary
    ///   - rhs: array with the keys to be removed.
    /// - Returns: a new dictionary with keys removed.
    static func - <S: Sequence>(lhs: [Key: Value], keys: S) -> [Key: Value] where S.Element == Key {
        var result = lhs
        result.removeAll(keys: keys)
        return result
    }

    /// SwifterSwift: Remove keys contained in the sequence from the dictionary
    ///
    ///        var dict: [String: String] = ["key1": "value1", "key2": "value2", "key3": "value3"]
    ///        dict-=["key1", "key2"]
    ///        dict.keys.contains("key3") -> true
    ///        dict.keys.contains("key1") -> false
    ///        dict.keys.contains("key2") -> false
    ///
    /// - Parameters:
    ///   - lhs: dictionary
    ///   - rhs: array with the keys to be removed.
    static func -= <S: Sequence>(lhs: inout [Key: Value], keys: S) where S.Element == Key {
        lhs.removeAll(keys: keys)
    }

    /// - LoverdeCo: Convert Dictonary to Object
    ///
    /// - returns: Object: Codable/Decodable
    public func toObjetct<T: Codable>() -> T {
        let jsonData = try! JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        let output: T = try! JSONHelper.decode(jsonString)
        return output
    }
    
    /// - LoverdeCo: Convert Dictonary to JSON
    ///
    /// - returns: JSON String
    public func toJSON() -> String {
        let jsonData = try! JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        return jsonString
    }

    /// SwifterSwift: Check if key exists in dictionary.
    ///
    ///        let dict: [String: Any] = ["testKey": "testValue", "testArrayKey": [1, 2, 3, 4, 5]]
    ///        dict.has(key: "testKey") -> true
    ///        dict.has(key: "anotherKey") -> false
    ///
    /// - Parameter key: key to search for
    /// - Returns: true if key exists in dictionary.
    func has(key: Key) -> Bool {
        return index(forKey: key) != nil
    }

    /// SwifterSwift: Remove all keys contained in the keys parameter from the dictionary.
    ///
    ///        var dict : [String: String] = ["key1" : "value1", "key2" : "value2", "key3" : "value3"]
    ///        dict.removeAll(keys: ["key1", "key2"])
    ///        dict.keys.contains("key3") -> true
    ///        dict.keys.contains("key1") -> false
    ///        dict.keys.contains("key2") -> false
    ///
    /// - Parameter keys: keys to be removed
    mutating func removeAll<S: Sequence>(keys: S) where S.Element == Key {
        keys.forEach { removeValue(forKey: $0) }
    }

    /// SwifterSwift: Remove a value for a random key from the dictionary.
    @discardableResult
    mutating func removeValueForRandomKey() -> Value? {
        guard let randomKey = keys.randomElement() else { return nil }
        return removeValue(forKey: randomKey)
    }
    
    var queryString: String {
       var output: String = ""
       for (key,value) in self {
           output +=  "\(key)=\(value)&"
       }
       output = String(output.dropLast())
       return output
    }
}


// MARK: - Methods (Value: Equatable)
public extension Dictionary where Value: Equatable {

    /// SwifterSwift: Returns an array of all keys that have the given value in dictionary.
    ///
    ///        let dict = ["key1": "value1", "key2": "value1", "key3": "value2"]
    ///        dict.keys(forValue: "value1") -> ["key1", "key2"]
    ///        dict.keys(forValue: "value2") -> ["key3"]
    ///        dict.keys(forValue: "value3") -> []
    ///
    /// - Parameter value: Value for which keys are to be fetched.
    /// - Returns: An array containing keys that have the given value.
    func keys(forValue value: Value) -> [Key] {
        return keys.filter { self[$0] == value }
    }

}

// MARK: - Methods (ExpressibleByStringLiteral)
public extension Dictionary where Key: StringProtocol {

    /// SwifterSwift: Lowercase all keys in dictionary.
    ///
    ///        var dict = ["tEstKeY": "value"]
    ///        dict.lowercaseAllKeys()
    ///        print(dict) // prints "["testkey": "value"]"
    ///
    mutating func lowercaseAllKeys() {
        // http://stackoverflow.com/questions/33180028/extend-dictionary-where-key-is-of-type-string
        for key in keys {
            if let lowercaseKey = String(describing: key).lowercased() as? Key {
                self[lowercaseKey] = removeValue(forKey: key)
            }
        }
    }
}
