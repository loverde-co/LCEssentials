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
#if os(iOS) || os(watchOS)
#if canImport(Security)
import Security
#endif
#if canImport(UIKit)
import UIKit
#endif

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
    
    private static var certData: Data?
    private static var certPassword: String?
    
    static let defaultError = NSError.createErrorWith(code: LCEssentials.DEFAULT_ERROR_CODE,
                                                      description: LCEssentials.DEFAULT_ERROR_MSG,
                                                      reasonForError: LCEssentials.DEFAULT_ERROR_MSG)
    
    public static var persistConnectionDelay: Double = 3
    public static var defaultParams: [String:Any] = [String: Any]()
    var defaultHeaders: [String: String] = ["Accept": "application/json",
                                            "Content-Type": "application/json; charset=UTF-8",
                                            "Accept-Encoding": "gzip"]
    
    public static let shared = API()
    
    private init(){}
    
    /// Loverde Co.: API Requests made simple way
    ///
    /// - Parameters: params - Dictionary
    /// - Parameters: method - httpMethod enum
    /// - Parameters: jsonEncoding - bool
    /// - Parameters: debug - bool - show or hide
    /// - Parameters: persistConnection - bool - if error, re do the request
    public func request(url: String,
                        _ params: [String: Any] = [:],
                        _ method: httpMethod,
                        headers: [String: String] = [:],
                        jsonEncoding: Bool = true,
                        debug: Bool = true,
                        timeoutInterval: TimeInterval = 30,
                        networkServiceType: URLRequest.NetworkServiceType = .default,
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
                    var newParams = API.defaultParams
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
                request.timeoutInterval = timeoutInterval
                request.networkServiceType = networkServiceType
                
                // - Put Default Headers togheter with user defined params
                if !headers.isEmpty {
                    // - Add it to request
                    headers.forEach { (key, value) in
                        request.addValue(value, forHTTPHeaderField: key)
                    }
                }else{
                    defaultHeaders.forEach { (key, value) in
                        request.addValue(value, forHTTPHeaderField: key)
                    }
                }
                let task = URLSession.shared.dataTask(with: request) {
                    data,
                    response,
                    error in
                    var code: Int = LCEssentials.DEFAULT_ERROR_CODE
                    if let httpResponse = response as? HTTPURLResponse {
                        code = httpResponse.statusCode
                    }
                    
                    // - Debug LOG
                    if debug {
                        API.requestLOG(method: method, request: request)
                    }
                    guard let data = data,
                          error == nil else {
                        
                        // - Case user want to persist connection
                        if persistConnection {
                            printError(title: "INTERNET CONNECTION ERROR", msg: "WILL PERSIST")
                            LCEssentials.backgroundThread(
                                delay: API.persistConnectionDelay,
                                completion:  {
                                    self.request(
                                        url: url,
                                        params,
                                        method,
                                        headers: headers,
                                        jsonEncoding: jsonEncoding,
                                        debug: debug,
                                        timeoutInterval: timeoutInterval,
                                        networkServiceType: networkServiceType,
                                        persistConnection: persistConnection,
                                        completion: completion
                                    )
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
    
    public func request<T: Codable>(url: String,
                                    _ params: Any? = nil,
                                    _ method: httpMethod,
                                    headers: [String: String] = [:],
                                    jsonEncoding: Bool = true,
                                    debug: Bool = true,
                                    timeoutInterval: TimeInterval = 30,
                                    networkServiceType: URLRequest.NetworkServiceType = .default,
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
            request.timeoutInterval = timeoutInterval
            request.networkServiceType = networkServiceType
            
            // - Put Default Headers togheter with user defined params
            if !headers.isEmpty {
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
                API.requestLOG(method: method, request: request)
            }
            
            let session = URLSession(
                configuration: .default,
                delegate: URLSessionDelegateHandler(
                    certData: API.certData,
                    password: API.certPassword
                ),
                delegateQueue: nil
            )
            do {
                let (data, response) = try await session.data(for: request)
                
                
                var code: Int = LCEssentials.DEFAULT_ERROR_CODE
                let httpResponse = response as? HTTPURLResponse ?? HTTPURLResponse()
                code = httpResponse.statusCode
                let error = URLError(URLError.Code(rawValue: code))
                switch code {
                case 200..<300:
                    // - Debug LOG
                    if debug {
                        API.responseLOG(method: method, request: request, data: data, statusCode: code, error: nil)
                    }
                    
                    // - Check if is JSON result and try decode it
                    if let string = data.string as? T, T.self == String.self {
                        return string
                    }
                    // - Normal decoding
                    do {
                        return try JSONDecoder.decode(data: data)
                    } catch {
                        printError(title: "JSONDecoder", msg: error.localizedDescription)
                        throw error
                    }
                case 400..<500:
                    // - Debug LOG
                    if debug {
                        API.responseLOG(method: method, request: request, data: data, statusCode: code, error: error)
                    }
                    if persistConnection {
                        printError(title: "INTERNET CONNECTION ERROR", msg: "WILL PERSIST")
                        let persist: T = try await self.request(
                            url: url,
                            params,
                            method,
                            headers: headers,
                            jsonEncoding: jsonEncoding,
                            debug: debug,
                            timeoutInterval: timeoutInterval,
                            networkServiceType: networkServiceType,
                            persistConnection: persistConnection
                        )
                        return persist
                    } else {
                        throw error
                    }
                default:
                    // - Debug LOG
                    if debug {
                        API.responseLOG(method: method, request: request, data: data, statusCode: code, error: error)
                    }
                    throw error
                }
            } catch {
                throw error
            }
        }
        throw API.defaultError
    }
    
    public func setupCertificationRequest(certData: Data, password: String = "") {
        API.certData = certData
        API.certPassword = password
    }
}

#if canImport(Security)
private class URLSessionDelegateHandler: NSObject, URLSessionDelegate {
    
    private var certData: Data?
    private var certPass: String?
    
    init(certData: Data? = nil, password: String? = nil) {
        super.init()
        self.certData = certData
        self.certPass = password
    }
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodClientCertificate {
            // Carregar o certificado do cliente
            guard let identity = getIdentity() else {
                completionHandler(.performDefaultHandling, nil)
                return
            }

            // Criar o URLCredential com a identidade
            let credential = URLCredential(identity: identity, certificates: nil, persistence: .forSession)
            completionHandler(.useCredential, credential)
        } else if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            // Validar o certificado do servidor
            if let serverTrust = challenge.protectionSpace.serverTrust {
                let serverCredential = URLCredential(trust: serverTrust)
                completionHandler(.useCredential, serverCredential)
            } else {
                completionHandler(.cancelAuthenticationChallenge, nil)
            }
        } else {
            completionHandler(.performDefaultHandling, nil)
        }
    }
    
    private func getIdentity() -> SecIdentity? {
        guard let certData = self.certData else { return nil }
        // Especifique a senha usada ao exportar o .p12
        let options: [String: Any] = [kSecImportExportPassphrase as String: self.certPass ?? ""]
        var items: CFArray?

        // Importar o certificado .p12 para obter a identidade
        let status = SecPKCS12Import(certData as CFData, options as CFDictionary, &items)
        
        if status == errSecSuccess,
           let item = (items as? [[String: Any]])?.first,
           let identityRef = item[kSecImportItemIdentity as String] as CFTypeRef?,
           CFGetTypeID(identityRef) == SecIdentityGetTypeID() {
            return (identityRef as! SecIdentity)
        } else {
            print("Erro ao importar a identidade do certificado: \(status)")
            return nil
        }

    }
    
    private func isPKCS12(data: Data, password: String) -> Bool {
        let options: [String: Any] = [kSecImportExportPassphrase as String: password]
        
        var items: CFArray?
        let status = SecPKCS12Import(data as CFData, options as CFDictionary, &items)
        
        return status == errSecSuccess
    }
}
#endif

extension Error {
    public var statusCode: Int {
        get{
            return self._code
        }
    }
}

extension API {
    
    fileprivate static func requestLOG(method: httpMethod, request: URLRequest) {
        
        print("\n<=========================  INTERNET CONNECTION - REQUEST =========================>")
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
        print("<======================================================================================>")
   }
    
    fileprivate static func responseLOG(method: httpMethod, request: URLRequest, data: Data?, statusCode: Int, error: Error?) {
        ///
         print("\n<=========================  INTERNET CONNECTION - RESPONSE =========================>")
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
        print("<======================================================================================>")
    }
}
#endif
