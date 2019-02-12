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

    public enum UserDefaultsKeys: String {
        case isLoggedIn
        case isFirstTimeOnApp
    }

    public func setIsLoggedIn(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        synchronize()
    }

    public func setIsFirstTimeOnApp(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isFirstTimeOnApp.rawValue)
        synchronize()
    }

    public func isLoggedIn() -> Bool {
        return bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }

    public func isFirstTimeOnApp() -> Bool {
        return bool(forKey: UserDefaultsKeys.isFirstTimeOnApp.rawValue)
    }
    
    public func setObject<T>(object: T, forKey: String) where T: Codable{
        if let encoded = try? JSONEncoder().encode(object) {
            UserDefaults.standard.set(encoded, forKey: forKey)
            UserDefaults.standard.synchronize()
        }
    }
    public func getObject<T>(forKey: String) -> T? where T: Codable {
        if let userData = data(forKey: forKey) {
            return try? JSONDecoder().decode(T.self, from: userData)
        }
        return nil
    }
    
    public func saveObject<T>(object: T, forKey: String) where T: Codable {
        let json = try! JSONHelper<T>.decode(toJSON: object)
        DispatchQueue.main.async {
            self.set(json, forKey: forKey)
            self.synchronize()
        }
    }
    
    public func getSavedObject<T>(forKey: String) -> T? where T: Codable {
        if let dict = object(forKey: forKey) as? String {
            let obj = try! JSONHelper<T>.decode(dict)
            return obj
        }
        return nil
    }
    
    public func removeSavedObject(forKey: String) -> Bool {
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
