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
func ^^ (radix: Float, power: Float) -> Float {
    return Float(pow(Double(radix), Double(power)))
}


/// Loverde Co: Custom Logs
public func printLog(section:String, description:String){
    print("\n\n[\(section)] \(description)")
}

public func printInfo(title: String, msg: String){
    print("💭 INFO: \(title): \(msg)")
}
public func printWarn(title: String, msg: String){
    print("⚠️ WARN: \(title): \(msg)")
}
public func printError(title: String, msg: String){
    print("🚫 ERROR: \(title): \(msg)")
}

public enum EnumBorderSide {
    case top, bottom, left, right
}

public struct LCEssentials {
    public static let DEFAULT_ERROR_DOMAIN = "LoverdeCoErrorDomain"
    public static let DEFAULT_ERROR_CODE = -99
    public static let DEFAULT_ERROR_MSG = "Error Unknow"
    
    #if os(iOS) || os(macOS)
    public let DEVICE_NAME: String = UIDevice().modelName
    /// - LoverdeCo: Tell if the device is iPhone older family or descontinued
    public var OLDER_DEVICES: Bool {
        return !(LCEssentials().DEVICE_NAME == "iPhone SE" || LCEssentials().DEVICE_NAME == "iPhone 5"
            || LCEssentials().DEVICE_NAME == "iPhone 5c" || LCEssentials().DEVICE_NAME == "iPhone 5s"
            || LCEssentials().DEVICE_NAME == "iPhone 4" || LCEssentials().DEVICE_NAME == "iPhone 4s")
    }
    
    /// - LoverdeCo: Tell if the device is iPhone family small sizes
    public static var SMALL_DEVICES: Bool {
        var isVeryOld = true
        if (LCEssentials().DEVICE_NAME == "iPhone SE" || LCEssentials().DEVICE_NAME == "iPhone 5"
            || LCEssentials().DEVICE_NAME == "iPhone 5c" || LCEssentials().DEVICE_NAME == "iPhone 5s"
            || LCEssentials().DEVICE_NAME == "iPhone 4" || LCEssentials().DEVICE_NAME == "iPhone 4s") {
            isVeryOld = true
        }else{
            isVeryOld = false
        }
        return isVeryOld
    }
    
    /// - LoverdeCo: Tell if the device is iPhone  plus sizes
    public static var BIGGER_DEVICES: Bool {
        var isVeryOld = false
        if (LCEssentials().DEVICE_NAME == "iPhone 6s Plus" || LCEssentials().DEVICE_NAME == "iPhone 7 Plus" || LCEssentials().DEVICE_NAME == "iPhone 8 Plus") {
            isVeryOld = true
        }
        return isVeryOld
    }
    
    /// - LoverdeCo: Tell if the device is iPhone regular sizes
    public static var REGULAR_DEVICES: Bool {
        var isVeryOld = false
        if (LCEssentials().DEVICE_NAME == "iPhone 6" || LCEssentials().DEVICE_NAME == "iPhone 6s"
            || LCEssentials().DEVICE_NAME == "iPhone 7" || LCEssentials().DEVICE_NAME == "iPhone 8") {
            isVeryOld = true
        }
        return isVeryOld
    }
    /// - LoverdeCo: Tell if the device is iPhone family X
    public static var X_DEVICES: Bool {
        var isVeryOld = false
        if (LCEssentials().DEVICE_NAME == "iPhone X" || LCEssentials().DEVICE_NAME == "iPhone XS"
            || LCEssentials().DEVICE_NAME == "iPhone XS Max" || LCEssentials().DEVICE_NAME == "iPhone XR"
            || LCEssentials().DEVICE_NAME == "iPhone 11" || LCEssentials().DEVICE_NAME == "iPhone 11 Pro" || LCEssentials().DEVICE_NAME == "iPhone 11 Pro Max") {
            isVeryOld = true
        }
        return isVeryOld
    }
    #endif
    
    #if !os(macOS)
    /// - LoverdeCo: App's name (if applicable).
    public static var appDisplayName: String? {
        // http://stackoverflow.com/questions/28254377/get-app-name-in-swift
        return Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
    }
    #endif
    
    #if !os(macOS)
    /// - LoverdeCo: App's bundle ID (if applicable).
    public static var appBundleID: String? {
        return Bundle.main.bundleIdentifier
    }
    #endif
    
    #if os(iOS)
    /// - LoverdeCo: StatusBar height
    public static var statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
    #endif
    
    #if !os(macOS)
    /// - LoverdeCo: App current build number (if applicable).
    public static var appBuild: String? {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
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
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
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
        return Bundle.main.appStoreReceiptURL?.path.contains("sandboxReceipt") == true
    }
    #endif
    
    #if os(iOS)
    /// - LoverdeCo: Check if multitasking is supported in current device.
    public static var isMultitaskingSupported: Bool {
        return UIDevice.current.isMultitaskingSupported
    }
    #endif
    
    #if os(iOS)
    /// - LoverdeCo: Current status bar network activity indicator state.
    public static var isNetworkActivityIndicatorVisible: Bool {
        get {
            return UIApplication.shared.isNetworkActivityIndicatorVisible
        }
        set {
            UIApplication.shared.isNetworkActivityIndicatorVisible = newValue
        }
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
            return UIApplication.shared.isStatusBarHidden
        }
//        set {
//            UIApplication.shared.isStatusBarHidden = newValue
//        }
    }
    #endif
    
    #if os(iOS) || os(tvOS)
    /// - LoverdeCo: Key window (read only, if applicable).
    public static var keyWindow: UIView? {
        return UIApplication.shared.keyWindow
    }
    #endif
    
    #if os(iOS) || os(tvOS)
    @available(*, deprecated, message: "This will be removed on 0.4.* version of this repository")
    public static var mostTopViewController: UIViewController? {
        get {
            return UIApplication.shared.keyWindow?.rootViewController
        }
        set {
            UIApplication.shared.keyWindow?.rootViewController = newValue
        }
    }
    /// - LoverdeCo: Most top view controller (if applicable).
    public static func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
    #endif
    
    #if os(iOS) || os(tvOS)
    /// - LoverdeCo: Shared instance UIApplication.
    public static var sharedApplication: UIApplication {
        return UIApplication.shared
    }
    #endif
    
    #if os(iOS)
    ///- LoverdeCo: Current status bar style (if applicable).
    public static var statusBarStyle: UIStatusBarStyle? {
        get {
            return UIApplication.shared.statusBarStyle
        }
//        set {
//            if let style = newValue {
//                UIApplication.shared.statusBarStyle = style
//            }
//        }
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
    static func shareApp(message:String = "", url: String){
        let textToShare = message
        let root = UIApplication.shared.keyWindow?.rootViewController
        if let myWebsite = NSURL(string: url) {
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.popoverPresentationController?.sourceView = root?.view
            root?.modalPresentationStyle = .fullScreen
            root?.present(activityVC, animated: true, completion: nil)
        }
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
    static func setRootViewControllerWithAnimation(fromView from: UIView, toViewController to: UIViewController, duration: TimeInterval = 0.6, options: UIViewAnimationOptions, completion: (() -> Void)? = nil) {
        
        let appDelegate = UIApplication.shared.delegate
        
        UIView.transition(from: from, to: to.view, duration: duration, options: options, completion: {
            _ in
            appDelegate?.window??.rootViewController = to
            if( completion != nil ){ completion!() }
        })
    }
    #endif
    
    /// - LoverdeCo: Delay function or closure call.
    ///
    /// - Parameters:
    ///   - milliseconds: execute closure after the given delay.
    ///   - queue: a queue that completion closure should be executed on (default is DispatchQueue.main).
    ///   - completion: closure to be executed after delay.
    ///   - Returns: DispatchWorkItem task. You can call .cancel() on it to cancel delayed execution.
    @discardableResult static func delay(milliseconds: Double, queue: DispatchQueue = .main, completion: @escaping () -> Void) -> DispatchWorkItem {
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
    static func debounce(millisecondsDelay: Int, queue: DispatchQueue = .main, action: @escaping (() -> Void)) -> () -> Void {
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
        _ = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationUserDidTakeScreenshot,
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
    
    /// - LoverdeCo: Decode Object to JSON string
    ///
    /// - Parameter object: Codable/Decodable
    /// - returns: String
    public static func decode(toJSON object: T) throws -> String{
        let jsonData = try! JSONEncoder().encode(object)
        guard let json = String(data: jsonData, encoding: .utf8) else{
            throw NSError(domain: "JSONEcoding", code: 0, userInfo: nil)
        }
        return json
    }
}
