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

//MARK: - Codables convertions
public extension Encodable {
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))) as? [String: Any] ?? [:]
    }
    var json: String {
        return self.dictionary.convertToJSON
    }
    
    var data: Data {
        return self.json.data
    }
}

extension JSONDecoder {
    
    /// - LoverdeCo: Decode JSON Data to Object
    ///
    /// - Parameter data: Data
    /// - returns: Object: Codable/Decodable
    public static func decode<T: Codable>(data: Data) throws -> T {
        var error = NSError()
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        do {
            return try decoder.decode(T.self, from: data)
        } catch let DecodingError.keyNotFound(key, context) {
            let msg = "Missing key '\(key.stringValue)' in JSON: \(context.debugDescription)"
            error = NSError.createErrorWith(code: 0, description: msg, reasonForError: msg)
        } catch let DecodingError.typeMismatch(type, context) {
            let msg = "Type mismatch for type '\(type)': \(context.debugDescription)"
            error = NSError.createErrorWith(code: 0, description: msg, reasonForError: msg)
        } catch let DecodingError.valueNotFound(value, context) {
            let msg = "Missing value '\(value)' in JSON: \(context.debugDescription)"
            error = NSError.createErrorWith(code: 0, description: msg, reasonForError: msg)
        } catch {
            throw error
        }
        throw error
    }
    
    /// - LoverdeCo: Decode JSON String to Object
    ///
    /// - Parameter json: String
    /// - returns: Object: Codable/Decodable
    public static func decode<T: Codable>(_ json: String, using encoding: String.Encoding = .utf8) throws -> T {
        var error = NSError()
        if let jsonData = json.data(using: .utf8) {
            do {
                return try decode(data: jsonData)
            } catch let DecodingError.keyNotFound(key, context) {
                let msg = "Missing key '\(key.stringValue)' in JSON: \(context.debugDescription)"
                error = NSError.createErrorWith(code: 0, description: msg, reasonForError: msg)
            } catch let DecodingError.typeMismatch(type, context) {
                let msg = "Type mismatch for type '\(type)': \(context.debugDescription)"
                error = NSError.createErrorWith(code: 0, description: msg, reasonForError: msg)
            } catch let DecodingError.valueNotFound(value, context) {
                let msg = "Missing value '\(value)' in JSON: \(context.debugDescription)"
                error = NSError.createErrorWith(code: 0, description: msg, reasonForError: msg)
            } catch {
                throw error
            }
        }
        throw error
    }
    
    /// - LoverdeCo: Decode JSON URL to Object
    ///
    /// - Parameter url: URL
    /// - returns: Object: Codable/Decodable
    public static func decode<T: Codable>(fromURL url: URL) throws -> T {
        return try decode(data: try! Data(contentsOf: url))
    }
    
    public static func decode<T: Codable>(dictionary: Any) throws -> T {
        do {
            let json = try JSONSerialization.data(withJSONObject: dictionary)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(T.self, from: json)
        } catch {
            printError(title: "JSONDecoder.decode<T: Codable>", msg: error, prettyPrint: true)
            throw error
        }
    }
}
