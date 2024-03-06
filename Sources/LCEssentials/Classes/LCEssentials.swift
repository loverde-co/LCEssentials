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
import UIKit
import AVFoundation
#if os(watchOS)
import WatchKit
#endif
//import CommonCrypto


precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
infix operator ^^ : PowerPrecedence
public func ^^ (radix: Float, power: Float) -> Float {
    return Float(pow(Double(radix), Double(power)))
}


/// Loverde Co: Custom Logs
public func printLog(title: String, msg: Any, prettyPrint: Bool = false){
    if prettyPrint {
        print("\n<=========================  \(title) - START =========================>")
        print(msg)
        print("\n<=========================  \(title) - END ===========================>")
    }else{
        print("\(title): \(msg)")
    }
}

public func printInfo(title: String, msg: Any, prettyPrint: Bool = false, function: String = #function, file: String = #file, line: Int = #line, column: Int = #column){
    if prettyPrint {
        print("\n<=========================  ℹ️ INFO: \(title) - START =========================>")
        print("[\(file): FUNC: \(function): LINE: \(line) - COLUMN: \(column)]\n")
        print(msg)
        print("\n<=========================  ℹ️ INFO: \(title) - END ===========================>")
    }else{
        print("ℹ️ INFO: \(title): \(msg)")
    }
}
public func printWarn(title: String, msg: Any, prettyPrint: Bool = false, function: String = #function, file: String = #file, line: Int = #line, column: Int = #column){
    if prettyPrint {
        print("\n<=========================  ⚠️ WARN: \(title) - START =========================>")
        print("[\(file): FUNC: \(function): LINE: \(line) - COLUMN: \(column)]\n")
        print(msg)
        print("\n<=========================  ⚠️ WARN: \(title) - END ===========================>")
    }else{
        print("⚠️ WARN: \(title): \(msg)")
    }
}
public func printError(title: String, msg: Any, prettyPrint: Bool = false, function: String = #function, file: String = #file, line: Int = #line, column: Int = #column){
    if prettyPrint {
        print("\n<=========================  🚫 ERROR: \(title) - START =========================>")
        print("[\(file): FUNC: \(function): LINE: \(line) - COLUMN: \(column)]\n")
        print(msg)
        print("\n<=========================  🚫 ERROR: \(title) - END ===========================>")
    }else{
        print("🚫 ERROR: \(title): \(msg)")
    }
}

public struct LCEssentials {
    public static let DEFAULT_ERROR_DOMAIN = "LoverdeCoErrorDomain"
    public static let DEFAULT_ERROR_CODE = -99
    public static let DEFAULT_ERROR_MSG = "Error Unknow"
    
    #if os(iOS) || os(macOS)
    /// Extract the file name from the file path
    ///
    /// - Parameter filePath: Full file path in bundle
    /// - Returns: File Name with extension
    public static func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
    #endif
    
    #if !os(macOS)
    /// - LoverdeCo: App's name (if applicable).
    public static var appDisplayName: String? {
        return UIApplication.shared.displayName
    }
    #endif
    
    #if !os(macOS)
    /// - LoverdeCo: App's bundle ID (if applicable).
    public static var appBundleID: String? {
        return Bundle.main.bundleIdentifier
    }
    #endif
    
    #if !os(macOS)
    /// - LoverdeCo: App current build number (if applicable).
    public static var appBuild: String? {
        return UIApplication.shared.buildNumber
    }
    #endif
    
    #if os(iOS) || os(tvOS)
    /// - LoverdeCo: Application icon badge current number.
    public static var applicationIconBadgeNumber: Int {
        get {
            return UIApplication.shared.applicationIconBadgeNumber
        }
        set {
            UIApplication.shared.applicationIconBadgeNumber = newValue
        }
    }
    #endif
    
    #if !os(macOS)
    /// - LoverdeCo: App's current version (if applicable).
    public static var appVersion: String? {
        return UIApplication.shared.version
    }
    #endif
    
    #if os(iOS)
    /// - LoverdeCo: Current battery level.
    public static var batteryLevel: Float {
        return UIDevice.current.batteryLevel
    }
    #endif
    
    #if os(iOS) || os(tvOS)
    /// - LoverdeCo: Shared instance of current device.
    public static var currentDevice: UIDevice {
        return UIDevice.current
    }
    #elseif os(watchOS)
    /// - LoverdeCo: Shared instance of current device.
    public static var currentDevice: WKInterfaceDevice {
        return WKInterfaceDevice.current()
    }
    #endif
    
    #if !os(macOS)
    /// - LoverdeCo: Screen height.
    public static var screenHeight: CGFloat {
        #if os(iOS) || os(tvOS)
        return UIScreen.main.bounds.height
        #elseif os(watchOS)
        return currentDevice.screenBounds.height
        #endif
    }
    #endif
    
    #if os(iOS)
    /// - LoverdeCo: Current orientation of device.
    public static var deviceOrientation: UIDeviceOrientation {
        return currentDevice.orientation
    }
    #endif
    
    #if !os(macOS)
    /// - LoverdeCo: Screen width.
    public static var screenWidth: CGFloat {
        #if os(iOS) || os(tvOS)
        return UIScreen.main.bounds.width
        #elseif os(watchOS)
        return currentDevice.screenBounds.width
        #endif
    }
    #endif
    
    /// - LoverdeCo: Check if app is running in debug mode.
    public static var isInDebuggingMode: Bool {
        // http://stackoverflow.com/questions/9063100/xcode-ios-how-to-determine-whether-code-is-running-in-debug-release-build
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    #if !os(macOS)
    /// - LoverdeCo: Check if app is running in TestFlight mode.
    public static var isInTestFlight: Bool {
        // http://stackoverflow.com/questions/12431994/detect-testflight
        return Bundle.main.appStoreReceiptURL?.path.contains("sandboxReceipt", caseSensitive: false) == true
    }
    #endif
    
    #if os(iOS)
    /// - LoverdeCo: Check if multitasking is supported in current device.
    public static var isMultitaskingSupported: Bool {
        return UIDevice.current.isMultitaskingSupported
    }
    #endif
    
    #if os(iOS)
    /// - LoverdeCo: Check if device is iPad.
    public static var isPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    #endif
    
    #if os(iOS)
    /// - LoverdeCo: Check if device is iPhone.
    public static var isPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    #endif
    
    #if os(iOS) || os(tvOS)
    /// - LoverdeCo: Check if device is registered for remote notifications for current app (read-only).
    public static var isRegisteredForRemoteNotifications: Bool {
        return UIApplication.shared.isRegisteredForRemoteNotifications
    }
    #endif
    
    /// - LoverdeCo: Check if application is running on simulator (read-only).
    public static var isRunningOnSimulator: Bool {
        // http://stackoverflow.com/questions/24869481/detect-if-app-is-being-built-for-device-or-simulator-in-swift
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
    
    #if os(iOS)
    ///- LoverdeCo: Status bar visibility state.
    public static var isStatusBarHidden: Bool {
        get {
            if #available(iOS 13.0, *) {
                let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
                return window?.windowScene?.statusBarManager?.isStatusBarHidden ?? true
            } else {
                return UIApplication.shared.isStatusBarHidden
            }
        }
    }
    #endif
    
    #if os(iOS) || os(tvOS)
    /// - LoverdeCo: Key window (read only, if applicable).
    public static var keyWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        } else {
            return UIApplication.shared.keyWindow
        }
    }
    #endif
    
    #if os(iOS) || os(tvOS)
    /// - LoverdeCo: Most top view controller (if applicable).
    public static func getTopViewController(base: UIViewController? = UIViewController(),
                                            aboveBars: Bool = true) -> UIViewController? {
        var viewController = base
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            viewController = window?.rootViewController
        } else {
            viewController = UIApplication.shared.keyWindow?.rootViewController
        }
        
        if let nav = viewController as? UINavigationController {
            if aboveBars {
                return nav
            }
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = viewController as? UITabBarController,
                    let selected = tab.selectedViewController {
            if aboveBars {
                return tab
            }
            return getTopViewController(base: selected)

        } else if let presented = viewController?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return viewController
    }
    #endif
    
    #if os(iOS) || os(tvOS)
    /// - LoverdeCo: Shared instance UIApplication.
    public static var sharedApplication: UIApplication {
        return UIApplication.shared
    }
    #endif
    
    #if !os(macOS)
    /// - LoverdeCo: System current version (read-only).
    public static var systemVersion: String {
        return currentDevice.systemVersion
    }
    #endif
    
    public init(){}
    
    
    
}

// MARK: - Methods
public extension LCEssentials {
    
    #if os(iOS) || os(macOS)
    /// - LoverdeCo: Share link with message
    ///
    /// - Parameters:
    ///   - message: String with message you whant to send
    ///   - url: String with url you want to share
    static func shareApp(message:String = "", url: String = ""){
        let textToShare = message
        let root = self.getTopViewController(aboveBars: true)
        
        var objectsToShare = [textToShare] as [Any]
        if let myWebsite = NSURL(string: url) {
            objectsToShare.append(myWebsite)
        }
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        activityVC.popoverPresentationController?.sourceView = root?.view
        root?.modalPresentationStyle = .fullScreen
        root?.present(activityVC, animated: true, completion: nil)
    }
    /// - LoverdeCo: Make a call
    ///
    /// - Parameters:
    ///   - number: string phone number
    static func call(_ number: String!) {
        if let url = URL(string: "tel://" + number) {
            UIApplication.shared.canOpenURL(url)
        }
    }
    /// - LoverdeCo: Open link on Safari
    ///
    /// - Parameters:
    ///   - urlStr: url string to open
    static func openSafari(_ urlStr: String){
        if let url = URL(string: urlStr) {
            UIApplication.shared.canOpenURL(url)
        }
    }
    #endif
    
    // MARK: - Background Thread
    static func backgroundThread(delay: Double = 0.0, background: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global().async {
            background?()
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                completion?()
            }
        }
    }
    
    #if os(iOS) || os(macOS)
    //MARK: - Set Root View Controller
    static func setRootViewController(to viewController: UIViewController,
                                      duration: TimeInterval = 0.6,
                                      options: UIView.AnimationOptions = .transitionCrossDissolve,
                                      completion: ((Bool) -> Void)? = nil) {
        
        if let snapshot = self.keyWindow?.snapshotView(afterScreenUpdates: true) {
            viewController.view.addSubview(snapshot)
            
            self.keyWindow?.rootViewController = viewController
            UIView.transition(with: snapshot,
                              duration: duration,
                              options: options,
                              animations: {
                snapshot.layer.opacity = 0
            }, completion: { status in
                snapshot.removeFromSuperview()
                completion?(true)
            })
        } else {
            completion?(false)
        }
    }
    #endif
    
    /// - LoverdeCo: Delay function or closure call.
    ///
    /// - Parameters:
    ///   - milliseconds: execute closure after the given delay.
    ///   - queue: a queue that completion closure should be executed on (default is DispatchQueue.main).
    ///   - completion: closure to be executed after delay.
    ///   - Returns: DispatchWorkItem task. You can call .cancel() on it to cancel delayed execution.
    @discardableResult static func delay(milliseconds: Double,
                                         queue: DispatchQueue = .main,
                                         completion: @escaping () -> Void) -> DispatchWorkItem {
        
        let task = DispatchWorkItem { completion() }
        queue.asyncAfter(deadline: .now() + (milliseconds/1000), execute: task)
        return task
    }
    
    /// - LoverdeCo: Debounce function or closure call.
    ///
    /// - Parameters:
    ///   - millisecondsOffset: allow execution of method if it was not called since millisecondsOffset.
    ///   - queue: a queue that action closure should be executed on (default is DispatchQueue.main).
    ///   - action: closure to be executed in a debounced way.
    static func debounce(millisecondsDelay: Int,
                         queue: DispatchQueue = .main,
                         action: @escaping (() -> Void)) -> () -> Void {
        // http://stackoverflow.com/questions/27116684/how-can-i-debounce-a-method-call
        var lastFireTime = DispatchTime.now()
        let dispatchDelay = DispatchTimeInterval.milliseconds(millisecondsDelay)
        let dispatchTime: DispatchTime = lastFireTime + dispatchDelay
        return {
            queue.asyncAfter(deadline: dispatchTime) {
                let when: DispatchTime = lastFireTime + dispatchDelay
                let now = DispatchTime.now()
                if now.rawValue >= when.rawValue {
                    lastFireTime = DispatchTime.now()
                    action()
                }
            }
        }
    }
    
    #if os(iOS) || os(tvOS)
    /// - LoverdeCo: Called when user takes a screenshot
    ///
    /// - Parameter action: a closure to run when user takes a screenshot
    static func didTakeScreenShot(_ action: @escaping (_ notification: Notification) -> Void) {
        // http://stackoverflow.com/questions/13484516/ios-detection-of-screenshot
        _ = NotificationCenter.default.addObserver(forName: UIApplication.userDidTakeScreenshotNotification,
                                                   object: nil,
                                                   queue: OperationQueue.main) { notification in
                                                    action(notification)
        }
    }
    #endif
}


//MARK: - JSON Helper Codable/Decodable
public struct JSONHelper<T: Codable> {
    
    /// - LoverdeCo: Decode JSON Data to Object
    ///
    /// - Parameter data: Data
    /// - returns: Object: Codable/Decodable
    public static func decode(data: Data) throws -> T {
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    /// - LoverdeCo: Decode JSON String to Object
    ///
    /// - Parameter json: String
    /// - returns: Object: Codable/Decodable
    public static func decode(_ json: String, using encoding: String.Encoding = .utf8) throws -> T {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        return try decode(data: data)
    }
    
    /// - LoverdeCo: Decode JSON URL to Object
    ///
    /// - Parameter url: URL
    /// - returns: Object: Codable/Decodable
    public static func decode(fromURL url: URL) throws -> T {
        return try decode(data: try! Data(contentsOf: url))
    }
}
