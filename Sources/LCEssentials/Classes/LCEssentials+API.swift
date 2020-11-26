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
    static let defaultError = NSError(domain: LCEssentials.DEFAULT_ERROR_DOMAIN, code: LCEssentials.DEFAULT_ERROR_CODE, userInfo: [ NSLocalizedDescriptionKey: LCEssentials.DEFAULT_ERROR_MSG ])
    public static var persistConnectionDelay: Double = 3
    public static var headers: [String: String]!
    public static var defaultParams: [String:Any] = [String: Any]()
    public static var defaultHeaders: [String: String] = ["Accept": "application/json", "Content-Type": "application/json; charset=UTF-8", "Accept-Encoding": "gzip"]
    public static var url: String = ""
    
    /// Loverde Co.: API Requests made simple way
    ///
    /// - Parameters: params - Dictionary
    /// - Parameters: method - httpMethod enum
    /// - Parameters: jsonEncoding - bool
    /// - Parameters: debug - bool - show or hide
    /// - Parameters: persistConnection - bool - if error, re do the request
    public static func request(_ params: [String: Any], _ method: httpMethod, jsonEncoding: Bool = true, debug:Bool = true, persistConnection:Bool = false,
                               function: String = #function, file: String = #file, line: Int = #line, column: Int = #column, completion: @escaping (Result<Any, Swift.Error>) -> ()){
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
                        print("\n<=========================  INTERNET CONNECTION - START =========================>")
                        printLog(title: "DATE AND TIME", msg: Date().debugDescription)
                        printLog(title: "FUNCTION", msg: function)
                        //printLog(title: "FILE", msg: LCEssentials.sourceFileName(filePath: file)+" LINE: \(line) COLUMN: \(column)")
                        printLog(title: "METHOD", msg: method.rawValue)
                        printLog(title: "REQUEST", msg: String(describing: request))
                        printLog(title: "HEADERS", msg: request.allHTTPHeaderFields!.debugDescription)
                        
                        //
                        if let data = request.httpBody, let jsonString = String(data: data, encoding: .utf8) {
                            printLog(title: "PARAMETERS", msg: jsonString)
                        } else {
                            printLog(title: "PARAMETERS", msg: "-")
                        }
                        //
                        printLog(title: "STATUS CODE", msg: String(describing: code))
                        //
                        if let data2 = data, let jsonString = String(data: data2, encoding: .utf8) {
                            printLog(title: "RESPONSE", msg: jsonString)
                        } else {
                            printLog(title: "RESPONSE", msg: "-")
                        }
                        //
                        if let error = error {
                            if error.statusCode == NSURLErrorTimedOut {
                                printError(title: "RESPONSE ERROR TIMEOUT", msg: "DESCRICAO: \(error.localizedDescription)")
                            }else
                            if error.statusCode == NSURLErrorNotConnectedToInternet {
                                printError(title: "RESPONSE ERROR NO INTERNET", msg: "DESCRICAO: \(error.localizedDescription)")
                            }else
                            if error.statusCode == NSURLErrorNetworkConnectionLost {
                                printError(title: "RESPONSE ERROR CONNECTION LOST", msg: "DESCRICAO: \(error.localizedDescription)")
                            }else
                            if error.statusCode == NSURLErrorCancelledReasonUserForceQuitApplication {
                                printError(title: "RESPONSE ERROR APP QUIT", msg: "DESCRICAO: \(error.localizedDescription)")
                            }else
                            if error.statusCode == NSURLErrorCancelledReasonBackgroundUpdatesDisabled {
                                printError(title: "RESPONSE ERROR BG DISABLED", msg: "DESCRICAO: \(error.localizedDescription)")
                            }else
                            if error.statusCode == NSURLErrorBackgroundSessionWasDisconnected {
                                printError(title: "RESPONSE ERROR BG SESSION DISCONNECTED", msg: "DESCRICAO: \(error.localizedDescription)")
                            }else{
                                printError(title: "ERROR GENERAL", msg: error.localizedDescription)
                            }
                        }else if let data = data, code != 200 {
                            // - Check if is JSON result
                            if let jsonString = String(data: data, encoding: .utf8) {
                                printError(title: "JSON STATUS CODE \(code)", msg: jsonString)
                            }else{
                                printError(title: "DATA STATUS CODE \(code)", msg: data.debugDescription)
                            }
                        }
                        //
                        print("<=========================  INTERNET CONNECTION - END =========================>")
                    }
                    guard let data = data, error == nil else {
                        
                        // - Case user want to persist connection
                        if persistConnection {
                            printError(title: "INTERNET CONNECTION ERROR", msg: "WILL PERSIST")
                            LCEssentials.backgroundThread(delay: persistConnectionDelay, completion:  {
                                self.request(params, method, jsonEncoding: jsonEncoding, debug: debug, persistConnection: persistConnection) { (result) in
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
}

extension Error {
    var statusCode: Int {
        get{
            return self._code
        }
    }
}
#endif
