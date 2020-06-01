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
#if os(iOS)

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
    static let defaultError = NSError(domain: LCEssentials.DEFAULT_ERROR_DOMAIN, code: LCEssentials.DEFAULT_ERROR_CODE, userInfo: [ NSLocalizedDescriptionKey: "Unknown error" ])
    public static var persistConnectionDelay: Double = 3
    public static var headers: [String: String]!
    public static var defaultParams: [String:Any]!
    public static var defaultHeaders: [String: String] = ["Accept": "application/json", "Content-Type": "application/json; charset=UTF-8", "Accept-Encoding": "gzip"]
    public static var url: String = ""
    
    /// Loverde Co.: API Requests made simple way
    ///
    /// - Parameters: params - Dictionary
    /// - Parameters: method - httpMethod enum
    /// - Parameters: params - Dictionary
    public static func request(_ params: [String: Any], _ method: httpMethod, jsonEncoding: Bool = true, debug:Bool = true, persistConnection:Bool = false, completion: @escaping (Result<Any, Swift.Error>) -> ()){
        do {
            // - Check if URL is valid and replace URL params on address
            if let urlReq = URL(string: url.replaceURL(params)) {
                var request = URLRequest(url: urlReq, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 20)
                if method == .post {
                    var newParams = defaultParams
                    newParams! += params
                    if jsonEncoding {
                        let requestObject = try JSONSerialization.data(withJSONObject: newParams!)
                        request.httpBody = requestObject
                    }else{
                        var bodyComponents = URLComponents()
                        newParams?.forEach({ (key, value) in
                            bodyComponents.queryItems?.append(URLQueryItem(name: key, value: value as? String))
                        })
                        request.httpBody = bodyComponents.query?.data(using: .utf8)
                    }
                }
                request.httpMethod = method.rawValue
                
                // - Put Default Headers togheter with user defined params
                if let _ = headers {
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
                let task = URLSession.shared.dataTask(with: request) {data, response, error in
                    var code: Int = LCEssentials.DEFAULT_ERROR_CODE
                    if let httpResponse = response as? HTTPURLResponse {
                        code = httpResponse.statusCode
                    }
                    
                    // - Debug LOG
                    if debug {
                       ///
                        do {
                            print("\n<=========================  INTERNET CONNECTION - START =========================>")
                            printInfo(title: "FUNCTION", msg: #function)
                            printInfo(title: "METHOD", msg: method.rawValue)
                            printInfo(title: "REQUEST", msg: String(describing: request))
                            printInfo(title: "HEADERS", msg: request.allHTTPHeaderFields!.debugDescription)
                            
                            //
                            if let data = request.httpBody {
                                printInfo(title: "PARAMETERS", msg: String(describing: try JSONSerialization.jsonObject(with: data, options: .allowFragments)))
                            } else {
                                printInfo(title: "PARAMETERS", msg: "")
                            }
                            //
                            printInfo(title: "STATUS CODE", msg: String(describing: code))
                            //
                            if let data2 = data {
                                printInfo(title: "RESPONSE", msg: String(describing: try JSONSerialization.jsonObject(with: data2, options: .allowFragments)))
                            } else {
                                printInfo(title: "RESPONSE", msg: "")
                            }
                            //
                            if let error = error {
                                if error.statusCode == NSURLErrorTimedOut {
                                    if debug { printError(title: "RESPONSE ERROR TIMEOUT", msg: "DESCRICAO: \(error.localizedDescription)") }
                                }else
                                if error.statusCode == NSURLErrorNotConnectedToInternet {
                                    if debug { printError(title: "RESPONSE ERROR NO INTERNET", msg: "DESCRICAO: \(error.localizedDescription)") }
                                }else
                                if error.statusCode == NSURLErrorNetworkConnectionLost {
                                    if debug { printError(title: "RESPONSE ERROR CONNECTION LOST", msg: "DESCRICAO: \(error.localizedDescription)") }
                                }else
                                if error.statusCode == NSURLErrorCancelledReasonUserForceQuitApplication {
                                    if debug { printError(title: "RESPONSE ERROR APP QUIT", msg: "DESCRICAO: \(error.localizedDescription)") }
                                }else
                                if error.statusCode == NSURLErrorCancelledReasonBackgroundUpdatesDisabled {
                                    if debug { printError(title: "RESPONSE ERROR BG DISABLED", msg: "DESCRICAO: \(error.localizedDescription)") }
                                }else
                                if error.statusCode == NSURLErrorBackgroundSessionWasDisconnected {
                                    if debug { printError(title: "RESPONSE ERROR BG SESSION DISCONNECTED", msg: "DESCRICAO: \(error.localizedDescription)") }
                                }else{
                                    printError(title: "ERROR GENERAL", msg: error.localizedDescription)
                                }
                            }
                            //
                            print("<=========================  INTERNET CONNECTION - END =========================>")
                        } catch {
                            printError(title: "INTERNET CONNECTION ERROR", msg: "DESCRICAO: \(error.localizedDescription)")
                        }
                        ///
                    }
                    guard let data = data, error == nil else {
                        
                        // - Case user want to persist connection
                        if persistConnection {
                            LCEssentials.backgroundThread(delay: persistConnectionDelay) {
                                self.request(params, method, jsonEncoding: jsonEncoding, debug: debug, persistConnection: persistConnection) { (result) in
                                    completion(result)
                                }
                            }
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
}

extension Error {
    var statusCode: Int {
        get{
            return self._code
        }
    }
}
#endif
