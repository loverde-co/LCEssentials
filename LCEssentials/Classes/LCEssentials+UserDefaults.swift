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

public extension UserDefaults {

    enum UserDefaultsKeys: String {
        case isLoggedIn
        case isFirstTimeOnApp
    }

    func setIsLoggedIn(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        synchronize()
    }

    func setIsFirstTimeOnApp(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isFirstTimeOnApp.rawValue)
        synchronize()
    }

    func isLoggedIn() -> Bool {
        return bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }

    func isFirstTimeOnApp() -> Bool {
        return bool(forKey: UserDefaultsKeys.isFirstTimeOnApp.rawValue)
    }
    
    func setObject<T: Encodable>(object: T, forKey: String){
        if let encoded = try? JSONEncoder().encode(object) {
            UserDefaults.standard.set(encoded, forKey: forKey)
            UserDefaults.standard.synchronize()
        }
    }
    func getObject<T: Decodable>(_ type: T.Type, forKey: String) -> T? {
        if let userData = data(forKey: forKey) {
            return try? JSONDecoder().decode(type, from: userData)
        }
        return nil
    }
    /// SwifterSwift: Retrieves a Codable object from UserDefaults.
    ///
    /// - Parameters:
    ///   - type: Class that conforms to the Codable protocol.
    ///   - key: Identifier of the object.
    ///   - decoder: Custom JSONDecoder instance. Defaults to `JSONDecoder()`.
    /// - Returns: Codable object for key (if exists).
    func object<T: Codable>(_ type: T.Type, with key: String, usingDecoder decoder: JSONDecoder = JSONDecoder()) -> T? {
        guard let data = value(forKey: key) as? Data else { return nil }
        return try? decoder.decode(type.self, from: data)
    }

    /// SwifterSwift: Allows storing of Codable objects to UserDefaults.
    ///
    /// - Parameters:
    ///   - object: Codable object to store.
    ///   - key: Identifier of the object.
    ///   - encoder: Custom JSONEncoder instance. Defaults to `JSONEncoder()`.
    func set<T: Codable>(object: T, forKey key: String, usingEncoder encoder: JSONEncoder = JSONEncoder()) {
        let data = try? encoder.encode(object)
        set(data, forKey: key)
        synchronize()
    }
    
    func removeSavedObject(forKey: String) -> Bool {
        if let _ = object(forKey: forKey) as? String {
            DispatchQueue.main.async {
                self.removeObject(forKey: forKey)
                self.synchronize()
            }
            return true
        }
        return false
    }
}
