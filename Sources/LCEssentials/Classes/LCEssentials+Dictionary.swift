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

public extension Dictionary {
    
    /// Deep fetch or set a value from nested dictionaries.
    ///
    ///        var dict =  ["key": ["key1": ["key2": "value"]]]
    ///        dict[path: ["key", "key1", "key2"]] = "newValue"
    ///        dict[path: ["key", "key1", "key2"]] -> "newValue"
    ///
    /// - Note: Value fetching is iterative, while setting is recursive.
    ///
    /// - Complexity: O(N), _N_ being the length of the path passed in.
    ///
    /// - Parameter path: An array of keys to the desired value.
    ///
    /// - Returns: The value for the key-path passed in. `nil` if no value is found.
    subscript(path path: [Key]) -> Any? {
        get {
            guard !path.isEmpty else { return nil }
            var result: Any? = self
            for key in path {
                if let element = (result as? [Key: Any])?[key] {
                    result = element
                } else {
                    return nil
                }
            }
            return result
        }
        set {
            if let first = path.first {
                if path.count == 1, let new = newValue as? Value {
                    return self[first] = new
                }
                if var nested = self[first] as? [Key: Any] {
                    nested[path: Array(path.dropFirst())] = newValue
                    return self[first] = nested as? Value
                }
            }
        }
    }
    
    
    var queryString: String {
       var output: String = ""
       for (key,value) in self {
           output +=  "\(key)=\(value)&"
       }
       output = String(output.dropLast())
       return output
    }

    var convertToJSON: String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
            if let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) as? String {
                return jsonString
            }
            return "Data to String with UFT8 Encoded error parsing"
        } catch {
            return "\(error.localizedDescription)"
        }
    }
    
    /// Creates a Dictionary from a given sequence grouped by a given key path.
    ///
    /// - Parameters:
    ///   - sequence: Sequence being grouped.
    ///   - keypath: The key path to group by.
    init<S: Sequence>(grouping sequence: S, by keyPath: KeyPath<S.Element, Key>) where Value == [S.Element] {
        self.init(grouping: sequence, by: { $0[keyPath: keyPath] })
    }
    
    //MARK: - Append Dictionary
    static func += (lhs: inout [Key: Value], rhs: [Key: Value]) {
        rhs.forEach { lhs[$0] = $1}
    }

    /// Remove keys contained in the sequence from the dictionary
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

    /// Remove keys contained in the sequence from the dictionary
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
    func toObjetct<T: Codable>() -> T {
        let jsonString = self.convertToJSON
        let output: T = try! JSONDecoder.decode(jsonString)
        return output
    }

    /// Check if key exists in dictionary.
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

    /// Remove all keys contained in the keys parameter from the dictionary.
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

    /// Remove a value for a random key from the dictionary.
    @discardableResult
    mutating func removeValueForRandomKey() -> Value? {
        guard let randomKey = keys.randomElement() else { return nil }
        return removeValue(forKey: randomKey)
    }
    
#if canImport(Foundation)
    /// JSON Data from dictionary.
    ///
    /// - Parameter prettify: set true to prettify data (default is false).
    /// - Returns: optional JSON Data (if applicable).
    func jsonData(prettify: Bool = false) -> Data? {
        guard JSONSerialization.isValidJSONObject(self) else {
            return nil
        }
        let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization
            .WritingOptions()
        return try? JSONSerialization.data(withJSONObject: self, options: options)
    }
#endif
    
#if canImport(Foundation)
    /// JSON String from dictionary.
    ///
    ///        dict.jsonString() -> "{"testKey":"testValue","testArrayKey":[1,2,3,4,5]}"
    ///
    ///        dict.jsonString(prettify: true)
    ///        /*
    ///        returns the following string:
    ///
    ///        "{
    ///        "testKey" : "testValue",
    ///        "testArrayKey" : [
    ///            1,
    ///            2,
    ///            3,
    ///            4,
    ///            5
    ///        ]
    ///        }"
    ///
    ///        */
    ///
    /// - Parameter prettify: set true to prettify string (default is false).
    /// - Returns: optional JSON String (if applicable).
    func jsonString(prettify: Bool = false) -> String? {
        guard JSONSerialization.isValidJSONObject(self) else { return nil }
        let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization
            .WritingOptions()
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: options) else { return nil }
        return String(data: jsonData, encoding: .utf8)
    }
#endif
    
    /// Returns a dictionary containing the results of mapping the given closure over the sequence’s
    /// elements.
    /// - Parameter transform: A mapping closure. `transform` accepts an element of this sequence as its parameter and
    /// returns a transformed value of the same or of a different type.
    /// - Returns: A dictionary containing the transformed elements of this sequence.
    func mapKeysAndValues<K, V>(_ transform: ((key: Key, value: Value)) throws -> (K, V)) rethrows -> [K: V] {
        return try [K: V](uniqueKeysWithValues: map(transform))
    }
    
    /// Returns a dictionary containing the non-`nil` results of calling the given transformation with
    /// each element of this sequence.
    /// - Parameter transform: A closure that accepts an element of this sequence as its argument and returns an
    /// optional value.
    /// - Returns: A dictionary of the non-`nil` results of calling `transform` with each element of the sequence.
    /// - Complexity: *O(m + n)*, where _m_ is the length of this sequence and _n_ is the length of the result.
    func compactMapKeysAndValues<K, V>(_ transform: ((key: Key, value: Value)) throws -> (K, V)?) rethrows -> [K: V] {
        return try [K: V](uniqueKeysWithValues: compactMap(transform))
    }
    
    /// Creates a new dictionary using specified keys.
    ///
    ///        var dict =  ["key1": 1, "key2": 2, "key3": 3, "key4": 4]
    ///        dict.pick(keys: ["key1", "key3", "key4"]) -> ["key1": 1, "key3": 3, "key4": 4]
    ///        dict.pick(keys: ["key2"]) -> ["key2": 2]
    ///
    /// - Complexity: O(K), where _K_ is the length of the keys array.
    ///
    /// - Parameter keys: An array of keys that will be the entries in the resulting dictionary.
    ///
    /// - Returns: A new dictionary that contains the specified keys only. If none of the keys exist, an empty
    /// dictionary will be returned.
    func pick(keys: [Key]) -> [Key: Value] {
        keys.reduce(into: [Key: Value]()) { result, item in
            result[item] = self[item]
        }
    }
    
    /// Merge the keys/values of two dictionaries.
    ///
    ///        let dict: [String: String] = ["key1": "value1"]
    ///        let dict2: [String: String] = ["key2": "value2"]
    ///        let result = dict + dict2
    ///        result["key1"] -> "value1"
    ///        result["key2"] -> "value2"
    ///
    /// - Parameters:
    ///   - lhs: dictionary.
    ///   - rhs: dictionary.
    /// - Returns: An dictionary with keys and values from both.
    static func + (lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
        var result = lhs
        rhs.forEach { result[$0] = $1 }
        return result
    }
}


// MARK: - Methods (Value: Equatable)
public extension Dictionary where Value: Equatable {

    /// Returns an array of all keys that have the given value in dictionary.
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

    /// Lowercase all keys in dictionary.
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
