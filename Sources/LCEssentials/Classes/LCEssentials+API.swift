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
#if os(iOS) || os(watchOS)

public enum Result<Value, Error: Swift.Error> {
    case success(Value)
    case failure(Error)
}

public enum httpMethod: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
}
/// Loverde Co.: API generic struct for simple requests
public struct API {
    static let defaultError = NSError.createErrorWith(code: LCEssentials.DEFAULT_ERROR_CODE,
                                                      description: LCEssentials.DEFAULT_ERROR_MSG,
                                                      reasonForError: LCEssentials.DEFAULT_ERROR_MSG)
    
    public static var persistConnectionDelay: Double = 3
    public static var headers: [String: String] = [:]
    public static var defaultParams: [String:Any] = [String: Any]()
    public static var defaultHeaders: [String: String] = ["Accept": "application/json",
                                                          "Content-Type": "application/json; charset=UTF-8",
                                                          "Accept-Encoding": "gzip"]
    public static var url: String = ""
    
    public init(){}
    
    /// Loverde Co.: API Requests made simple way
    ///
    /// - Parameters: params - Dictionary
    /// - Parameters: method - httpMethod enum
    /// - Parameters: jsonEncoding - bool
    /// - Parameters: debug - bool - show or hide
    /// - Parameters: persistConnection - bool - if error, re do the request
    public static func request(_ params: [String: Any],
                               _ method: httpMethod,
                               jsonEncoding: Bool = true,
                               debug: Bool = true,
                               persistConnection: Bool = false,
                               function: String = #function,
                               file: String = #file,
                               line: Int = #line,
                               column: Int = #column,
                               completion: @escaping (Result<Any, Swift.Error>) -> ()){
        do {
            // - Check if URL is valid and replace URL params on address
            if let urlReq = URL(string: url.replaceURL(params)) {
                var request = URLRequest(url: urlReq, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 20)
                if method == .post {
                    var newParams = defaultParams
                    newParams += params
                    if jsonEncoding {
                        let requestObject = try JSONSerialization.data(withJSONObject: newParams)
                        request.httpBody = requestObject
                    }else{
                        var bodyComponents = URLComponents()
                        newParams.forEach({ (key, value) in
                            bodyComponents.queryItems?.append(URLQueryItem(name: key, value: value as? String))
                        })
                        request.httpBody = bodyComponents.query?.data(using: .utf8)
                    }
                }
                request.httpMethod = method.rawValue
                
                // - Put Default Headers togheter with user defined params
                if !headers.isEmpty {
                    headers += defaultHeaders
                    
                    // - Add it to request
                    headers.forEach { (key, value) in
                        request.addValue(value, forHTTPHeaderField: key)
                    }
                }else{
                    defaultHeaders.forEach { (key, value) in
                        request.addValue(value, forHTTPHeaderField: key)
                    }
                }
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    var code: Int = LCEssentials.DEFAULT_ERROR_CODE
                    if let httpResponse = response as? HTTPURLResponse {
                        code = httpResponse.statusCode
                    }
                    
                    // - Debug LOG
                    if debug {
                        self.displayLOG(method: method, request: request, data: data, statusCode: code, error: error)
                    }
                    guard let data = data, error == nil else {
                        
                        // - Case user want to persist connection
                        if persistConnection {
                            printError(title: "INTERNET CONNECTION ERROR", msg: "WILL PERSIST")
                            LCEssentials.backgroundThread(delay: persistConnectionDelay, completion:  {
                                self.request(params, method, 
                                             jsonEncoding: jsonEncoding,
                                             debug: debug,
                                             persistConnection: persistConnection) { (result) in
                                    completion(result)
                                }
                            })
                        }else{
                            if let error = error {
                                completion(Result.failure(error))
                            }
                        }
                        return
                    }
                    
                    // - Check if is JSON result
                    if let jsonString = String(data: data, encoding: .utf8) {
                        completion(Result.success(jsonString))
                    }else{
                        completion(Result.success(data))
                    }
                }
                task.resume()
            }
        } catch {
            completion(Result.failure(error))
        }
    }
    
    public static func request<T: Codable>(_ params: Any,
                                           _ method: httpMethod,
                                           jsonEncoding: Bool = true,
                                           convertFromDictionary: Bool = false,
                                           debug: Bool = true,
                                           persistConnection: Bool = false) async throws -> T {
        
        if let urlReq = URL(string: url.replaceURL(params as? [String: Any] ?? [:] )) {
            var request = URLRequest(url: urlReq, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30)
            if method == .post {
                if jsonEncoding, let params = params as? [String: Any] {
                    let requestObject = try JSONSerialization.data(withJSONObject: params)
                    request.httpBody = requestObject
                } else if let params = params as? [String: Any] {
                    var bodyComponents = URLComponents()
                    params.forEach({ (key, value) in
                        bodyComponents.queryItems?.append(URLQueryItem(name: key, value: value as? String))
                    })
                    request.httpBody = bodyComponents.query?.data(using: .utf8)
                } else if let params = params as? Data {
                    request.httpBody = params
                }
            }
            request.httpMethod = method.rawValue
            
            // - Put Default Headers togheter with user defined params
            if !headers.isEmpty {
                headers += defaultHeaders
                
                // - Add it to request
                headers.forEach { (key, value) in
                    request.addValue(value, forHTTPHeaderField: key)
                }
            }else{
                defaultHeaders.forEach { (key, value) in
                    request.addValue(value, forHTTPHeaderField: key)
                }
            }
            if debug {
                self.displayLOG(method: method, request: request, data: nil, statusCode: 0, error: nil)
            }
            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                
                
                var code: Int = LCEssentials.DEFAULT_ERROR_CODE
                let httpResponse = response as? HTTPURLResponse ?? HTTPURLResponse()
                code = httpResponse.statusCode
                let error = URLError(URLError.Code(rawValue: code))
                switch code {
                case 200..<300:
                    // - Debug LOG
                    if debug {
                        self.displayLOG(method: method, request: request, data: data, statusCode: code, error: nil)
                    }
                    
                    // - Check if is JSON result
                    if let jsonString = String(data: data, encoding: .utf8), let outPut: T = try? JSONDecoder.decode(jsonString) {
                        return outPut
                    //} else if let dict: T = try? JSONDecoder.decode(dictionary: [String: Any].self) {
                    //    return dict
                    } else if let output: T = try? JSONDecoder.decode(data: data) {
                        return output
                    } else if let string: T = data.string as? T {
                        return string
                    }
                case 400..<500:
                    // - Debug LOG
                    if debug {
                        self.displayLOG(method: method, request: request, data: data, statusCode: code, error: error)
                    }
                    if persistConnection {
                        printError(title: "INTERNET CONNECTION ERROR", msg: "WILL PERSIST")
                        let persist: T = try await self.request(params,
                                                                method,
                                                                jsonEncoding: jsonEncoding,
                                                                debug: debug,
                                                                persistConnection: persistConnection)
                        return persist
                    } else {
                        throw error
                    }
                default:
                    // - Debug LOG
                    if debug {
                        self.displayLOG(method: method, request: request, data: data, statusCode: code, error: error)
                    }
                    throw error
                }
            } catch {
                throw error
            }
        }
        throw defaultError
    }
}

extension Error {
    public var statusCode: Int {
        get{
            return self._code
        }
    }
}

extension API {
    
    fileprivate static func displayLOG(method: httpMethod, request: URLRequest, data: Data?, statusCode: Int, error: Error?) {
        ///
         print("\n<=========================  INTERNET CONNECTION - START =========================>")
         printLog(title: "DATE AND TIME", msg: Date().debugDescription)
         printLog(title: "METHOD", msg: method.rawValue)
         printLog(title: "REQUEST", msg: String(describing: request))
         printLog(title: "HEADERS", msg: request.allHTTPHeaderFields?.debugDescription ?? "")
         
         //
         if let dataBody = request.httpBody, let prettyJson = dataBody.prettyJson {
             printLog(title: "PARAMETERS", msg: prettyJson)
         } else if let dataBody = request.httpBody {
             printLog(title: "PARAMETERS", msg: String(data: dataBody, encoding: .utf8) ?? "-")
         }
         //
         printLog(title: "STATUS CODE", msg: String(describing: statusCode))
         //
         if let dataResponse = data, let prettyJson = dataResponse.prettyJson {
             printLog(title: "RESPONSE", msg: prettyJson)
         } else {
             printLog(title: "RESPONSE", msg: String(data: data ?? Data(), encoding: .utf8) ?? "-")
         }
         //
         if let error = error {
             switch error.statusCode {
             case NSURLErrorTimedOut:
                 printError(title: "RESPONSE ERROR TIMEOUT", msg: "DESCRICAO: \(error.localizedDescription)")
                 
             case NSURLErrorNotConnectedToInternet:
                 printError(title: "RESPONSE ERROR NO INTERNET", msg: "DESCRICAO: \(error.localizedDescription)")
                 
             case NSURLErrorNetworkConnectionLost:
                 printError(title: "RESPONSE ERROR CONNECTION LOST", msg: "DESCRICAO: \(error.localizedDescription)")
                 
             case NSURLErrorCancelledReasonUserForceQuitApplication:
                 printError(title: "RESPONSE ERROR APP QUIT", msg: "DESCRICAO: \(error.localizedDescription)")
                 
             case NSURLErrorCancelledReasonBackgroundUpdatesDisabled:
                 printError(title: "RESPONSE ERROR BG DISABLED", msg: "DESCRICAO: \(error.localizedDescription)")
                 
             case NSURLErrorBackgroundSessionWasDisconnected:
                 printError(title: "RESPONSE ERROR BG SESSION DISCONNECTED", msg: "DESCRICAO: \(error.localizedDescription)")
                 
             default:
                 printError(title: "GENERAL", msg: error.localizedDescription)
             }
         }else if let data = data, statusCode != 200 {
             // - Check if is JSON result
             if let jsonString = String(data: data, encoding: .utf8) {
                 printError(title: "JSON STATUS CODE \(statusCode)", msg: jsonString)
             }else{
                 printError(title: "DATA STATUS CODE \(statusCode)", msg: data.debugDescription)
             }
         }
         //
         print("<=========================  INTERNET CONNECTION - END =========================>")
    }
}
#endif
