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
import Alamofire

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

public struct API {
    static let defaultError = NSError(domain: LCEssentials().DEFAULT_ERROR_DOMAIN, code: LCEssentials().DEFAULT_ERROR_CODE, userInfo: [ NSLocalizedDescriptionKey: "Unknown error" ])
    public static var persistConnectionDelay: Double = 3
    public static var headers: HTTPHeaders = ["Accept": "application/json", "Content-Type": "application/json; charset=UTF-8", "Accept-Encoding": "gzip"]
    public static var defaultParams: [String:Any]!
    public static var url: String = ""
    
    static func processRequest(requestResponse: AFDataResponse<Any>, withAction: String, withDictParams: [String:Any]?, jsonEncoding: Bool = false, debug:Bool, persistConnection:Bool, completions: @escaping(Any?, NSError?)->()){
        if debug { printLog(section: "API \((requestResponse.request?.httpMethod)!) - RESPONSE", description: (NSString(data: requestResponse.request?.httpBody ?? Data(), encoding: String.Encoding.utf8.rawValue)!) as String) }
        switch (requestResponse.result) {
        case .success:
            if debug { printInfo(title: "API \((requestResponse.request?.httpMethod)!) - RESPONSE SUCCESS", msg: "URI: \(withAction) - RESPONSE: \(requestResponse.debugDescription)") }
            //let json = (requestResponse.value as! [String: Any]).toJSON()
            let dict = requestResponse.value as! [String: Any]
            completions(dict, nil)
            break
        case .failure(let error):
            if debug { printError(title: "API \((requestResponse.request?.httpMethod)!) - RESPONSE ERROR", msg: "URI: \(withAction) - RESPONSE: \(requestResponse.debugDescription)") }
            if error._code == NSURLErrorTimedOut {
                if debug { printError(title: "API \((requestResponse.request?.httpMethod)!) - RESPONSE ERROR TIMEOUT", msg: "URI: \(withAction) - RESPONSE: \(requestResponse.debugDescription)") }
            }
            if error._code == NSURLErrorNotConnectedToInternet {
                if debug { printError(title: "API \((requestResponse.request?.httpMethod)!) - RESPONSE ERROR NO INTERNET", msg: "URI: \(withAction) - RESPONSE: \(requestResponse.debugDescription)") }
            }
            if error._code == NSURLErrorNetworkConnectionLost {
                if debug { printError(title: "API \((requestResponse.request?.httpMethod)!) - RESPONSE ERROR CONNECTION LOST", msg: "URI: \(withAction) - RESPONSE: \(requestResponse.debugDescription)") }
            }
            if error._code == NSURLErrorCancelledReasonUserForceQuitApplication {
                if debug { printError(title: "API \((requestResponse.request?.httpMethod)!) - RESPONSE ERROR APP QUIT", msg: "URI: \(withAction) - RESPONSE: \(requestResponse.debugDescription)") }
            }
            if error._code == NSURLErrorCancelledReasonBackgroundUpdatesDisabled {
                if debug { printError(title: "API \((requestResponse.request?.httpMethod)!) - RESPONSE ERROR BG DISABLED", msg: "URI: \(withAction) - RESPONSE: \(requestResponse.debugDescription)") }
            }
            if error._code == NSURLErrorBackgroundSessionWasDisconnected {
                if debug { printError(title: "API \((requestResponse.request?.httpMethod)!) - RESPONSE ERROR BG SESSION DISCONNECTED", msg: "URI: \(withAction) - RESPONSE: \(requestResponse.debugDescription)") }
            }
            
            completions(nil, requestResponse.error! as NSError)
            
            break
        }
    }
}


extension API {
    //MARK: - POST
    public static func connect(_ params: [String: Any], _ method: httpMethod, jsonEncoding: Bool = false, debug:Bool = true, persistConnection:Bool = false, completion: @escaping (Result<Any, Swift.Error>) -> ()){
        do {
            if let urlReq = URL(string: method == .get ? url.replaceURL(params) : url) {
                var request = URLRequest(url: urlReq, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 20)
                if method == .post {
                    var newParams = API.defaultParams
                    newParams! += params
                    let requestObject = try JSONSerialization.data(withJSONObject: newParams!)
                    request.httpBody = requestObject
                }
                request.httpMethod = method.rawValue
                
                request.headers = headers

                let task = URLSession.shared.dataTask(with: request) {data, response, error in
                    var code: Int = 999
                    if let httpResponse = response as? HTTPURLResponse {
                        code = httpResponse.statusCode
                    }
                    if debug {
                       ///
                        do {
                            print("\n<=========================  INTERNET CONNECTION - START =========================>")
                            printInfo(title: "FUNCTION", msg: #function)
                            printInfo(title: "METHOD", msg: method.rawValue)
                            printInfo(title: "REQUEST", msg: String(describing: request))
                            printInfo(title: "HEADERS", msg: String(describing: request.allHTTPHeaderFields))
                            
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
                                if error._code == NSURLErrorTimedOut {
                                    if debug { printError(title: "RESPONSE ERROR TIMEOUT", msg: "DESCRICAO: \(error.localizedDescription)") }
                                }else
                                if error._code == NSURLErrorNotConnectedToInternet {
                                    if debug { printError(title: "RESPONSE ERROR NO INTERNET", msg: "DESCRICAO: \(error.localizedDescription)") }
                                }else
                                if error._code == NSURLErrorNetworkConnectionLost {
                                    if debug { printError(title: "RESPONSE ERROR CONNECTION LOST", msg: "DESCRICAO: \(error.localizedDescription)") }
                                }else
                                if error._code == NSURLErrorCancelledReasonUserForceQuitApplication {
                                    if debug { printError(title: "RESPONSE ERROR APP QUIT", msg: "DESCRICAO: \(error.localizedDescription)") }
                                }else
                                if error._code == NSURLErrorCancelledReasonBackgroundUpdatesDisabled {
                                    if debug { printError(title: "RESPONSE ERROR BG DISABLED", msg: "DESCRICAO: \(error.localizedDescription)") }
                                }else
                                if error._code == NSURLErrorBackgroundSessionWasDisconnected {
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
                        if persistConnection {
                            LCEssentials.backgroundThread(delay: persistConnectionDelay) {
                                self.connect(params, method, jsonEncoding: jsonEncoding, debug: debug, persistConnection: persistConnection) { (result) in
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
    
    
    public static func post(withAction: String, withDictParams: [String:Any]?, jsonEncoding: Bool = false, debug:Bool = true, persistConnection:Bool = false, showStringParseError: Bool = false, completions: ((Any?) -> Void)? = nil){
        
        let manager: Session = {
            let configuration = URLSessionConfiguration.default
            configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
            return Session(configuration: configuration)
        }()
        //
        //
        var newParams = API.defaultParams
        if let params = withDictParams {
            newParams! += params
        }
        //
        //-- SHOW PARSE ERROR --//
        if showStringParseError {
            manager.request(withAction, method: HTTPMethod.post, parameters: newParams, encoding: (jsonEncoding ? JSONEncoding.default : URLEncoding.httpBody), headers: API.headers).responseString { (response) in
                printInfo(title: "POST", msg: response.debugDescription)
            }
        }
        //
        // -- DO THE REQUEST -- //
        //
        manager.request(withAction, method: HTTPMethod.post, parameters: newParams, encoding: (jsonEncoding ? JSONEncoding.default : URLEncoding.httpBody), headers: API.headers).responseJSON { (response) in
            API.processRequest(requestResponse: response, withAction: withAction, withDictParams: newParams, debug: debug, persistConnection: persistConnection, completions: { (AnyThing, backError) in
                if backError != nil {
                    print("\n\n[API POST - REQUEST - \( persistConnection ? "VAI" : "NAO VAI" ) - REMOTMAR A CONEXAO]\n\n")
                    if persistConnection {
                        LCEssentials.backgroundThread(delay: API.persistConnectionDelay, background: nil, completion: {
                            self.post(withAction: withAction, withDictParams: newParams, debug: debug, persistConnection: persistConnection, completions: { (Anything) in
                                completions?(Anything)
                            })
                        })
                    }else{
                        completions?(backError)
                    }
                }else{
                    completions?(AnyThing)
                }
            })
            manager.session.invalidateAndCancel()
        }
    }
    
    //MARK: - GET
    public static func get(withAction: String, withDictParams: [String:Any]?, debug:Bool = true, persistConnection:Bool = false, showStringParseError: Bool = false, completions: ((Any?) -> Void)? = nil){
        let manager: Session = {
            let configuration = URLSessionConfiguration.default
            configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
            return Session(configuration: configuration)
        }()
        //
        //
        var newParams = API.defaultParams
        if let params = withDictParams {
            newParams! += params
        }
        //
        //-- SHOW PARSE ERROR --//
        if showStringParseError {
            manager.request(withAction, method: HTTPMethod.get, parameters: newParams, headers: API.headers).responseString { (response) in
                printInfo(title: "GET", msg: response.debugDescription)
            }
        }
        //
        // -- DO THE REQUEST -- //
        //
        manager.request(withAction, method: HTTPMethod.get, parameters: newParams, headers: API.headers).responseJSON { (response) in
            API.processRequest(requestResponse: response, withAction: withAction, withDictParams: newParams, debug: debug, persistConnection: persistConnection, completions: { (AnyThing, backError) in
                if backError != nil {
                    print("\n\n[API POST - REQUEST - \( persistConnection ? "VAI" : "NAO VAI" ) - REMOTMAR A CONEXAO]\n\n")
                    if persistConnection {
                        LCEssentials.backgroundThread(delay: API.persistConnectionDelay, background: nil, completion: {
                            self.post(withAction: withAction, withDictParams: newParams, debug: debug, persistConnection: persistConnection, completions: { (Anything) in
                                completions?(Anything)
                            })
                        })
                    }else{
                        completions?(backError)
                    }
                }else{
                    completions?(AnyThing)
                }
            })
            manager.session.invalidateAndCancel()
        }
    }
}
#endif
