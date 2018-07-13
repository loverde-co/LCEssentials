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
//import CommonCrypto


precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
infix operator ^^ : PowerPrecedence
func ^^ (radix: Float, power: Float) -> Float {
    return Float(pow(Double(radix), Double(power)))
}

//MARK: - Append Dictionary
public func += <K, V> (left: inout [K:V], right: [K:V]) {
    for (k, v) in right {
        left[k] = v
    }
}

public enum EnumBorderSide {
    case top, bottom, left, right
}

public struct LCEssentials {
    public let DEFAULT_ERROR_DOMAIN = "LoverdeCoErrorDomain"
    public let DEFAULT_ERROR_CODE = -99
    public let DEFAULT_ERROR_MSG = "Error Unknow"
    public let IS_PROD = false
//    #if targetEnvironment(simulator)
//    public let DEVICE_IS_SIMULATOR = true
//    #else
//    public let DEVICE_IS_SIMULATOR = false
//    #endif
    public let DEVICE_NAME: String = UIDevice().modelName
    public var OLDER_DEVICES: Bool {
        return !(LCEssentials().DEVICE_NAME == "iPhone 5" || LCEssentials().DEVICE_NAME == "iPhone 5c" || LCEssentials().DEVICE_NAME == "iPhone 5s" || LCEssentials().DEVICE_NAME == "iPhone 4" || LCEssentials().DEVICE_NAME == "iPhone 4s")
    }

    public init(){}

    static func getAppVersion() -> String {

        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return version
        } else {
            return "Unknow"
        }
    }

    static func getBuildNumber() -> String {

        if let version = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            return version
        } else {
            return "Unknow"
        }

    }

    // MARK: - Background Thread
    public func backgroundThread(delay: Double = 0.0, background: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global().async {
            if(background != nil){ background!(); }

            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                if(completion != nil){ completion!(); }
            }
        }
        
    }
    
    //MARK: - Set Root View Controller
    public func setRootViewControllerWithAnimation(fromView from: UIView, toViewController to: UIViewController, duration: TimeInterval = 0.6, options: UIViewAnimationOptions, completion: (() -> Void)? = nil) {

        let appDelegate = UIApplication.shared.delegate

        UIView.transition(from: from, to: to.view, duration: duration, options: options, completion: {
            _ in
            appDelegate?.window??.rootViewController = to
            if( completion != nil ){ completion!() }
        })
    }

    //MARK: - Instance View Controllers Thru Storyboard
    public func instanceViewController(_ storyBoardName:String = "Intro", withIdentifier: String = "mainIntro" ) -> UIViewController {
        return UIStoryboard(name: storyBoardName, bundle: nil).instantiateViewController(withIdentifier: withIdentifier)
    }
    
    public func returnBetweenDate(startDate: Date, endDate: Date, years:Bool = false, months:Bool = false,  days:Bool = false) -> Int {

        let calendar = NSCalendar.current

        var components: DateComponents!

        if years {
            components = calendar.dateComponents( [.year], from: startDate, to: endDate)
            return components.year!
        }else if months {
            components = calendar.dateComponents( [.month], from: startDate, to: endDate)
            return components.month!
        }else{
            components = calendar.dateComponents( [.day], from: startDate, to: endDate)
            return components.day!
        }
    }

    public func printLog(section:String, description:String){
        print("\n\n[\(section)] \(description)")
    }
    
    public static func printInfo(title: String, msg: String){
        print("💭 INFO: \(title): \(msg)")
    }
    public static func printWarn(title: String, msg: String){
        print("⚠️ WARN: \(title): \(msg)")
    }
    public static func printError(title: String, msg: String){
        print("🚫 ERROR: \(title): \(msg)")
    }
}


// MARK: - Extensions

extension UITableViewCell {
    public func prepareDisclosureIndicator() {
        for case let button as UIButton in subviews {
            let image = button.backgroundImage(for: .normal)?.withRenderingMode(.
                alwaysTemplate)
            button.setBackgroundImage(image, for: .normal)
        }
    }
}
