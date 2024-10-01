//  
// Copyright (c) 2019 Loverde Co.
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

#if canImport(SwiftUI)
import Network

// An enum to handle the network status
public enum NetworkStatus: String {
    case connected
    case disconnected
}

// @StateObject var monitor = Monitor()
// Text(monitor.status.rawValue)
/// LCEMonitorManager is a simple class to monitor your connection for some tasks that you need
///
/// Usage example:
///
///```swift
///@StateObject var monitor = LCEMonitorManager()
///Text(monitor.status.rawValue)
///```
/// >important: Remember to instance ``LCEMonitorManager`` and then, verify whenever you need to know if there is connection
///
public final class LCEMonitorManager: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "LCEMonitorManager")

    @Published public var status: NetworkStatus = .connected

    public init(showLog: Bool = false) {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }

            // Monitor runs on a background thread so we need to publish
            // on the main thread
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    self.status = .connected

                } else {
                    print("No connection.")
                    self.status = .disconnected
                }
                if showLog {
                    printInfo(title: "LCEMonitorManager", msg: path.status)
                }
            }
        }
        monitor.start(queue: queue)
    }
}

#elseif os(iOS) || os(macOS)
//
// ORIGINAL SOURCE: https://medium.com/@sauvik_dolui/network-reachability-status-monitoring-on-ios-part-2-80421fc44fa
import Foundation

/// Protocol for listenig network status change
public protocol NetworkStatusListener : AnyObject {
    func networkStatusDidChange(status: Reachability.Connection)
}

/// Ate the end of this class we put some examples
public class ReachabilityManager: NSObject {
    
    public static let shared = ReachabilityManager()
    
    // 3. Boolean to track network reachability
    public var isNetworkAvailable : Bool {
        return reachabilityStatus != .unavailable
    }
    
    // 4. Tracks current NetworkStatus
    var reachabilityStatus: Reachability.Connection = .unavailable
    
    // 5. Reachibility instance for Network status monitoring
    let reachability: Reachability? = nil
    
    // 6. Array of delegates which are interested to listen to network status change
    var listeners = [NetworkStatusListener]()
    
    /// Called whenever there is a change in NetworkReachibility Status
    ///
    /// — parameter notification: Notification with the Reachability instance
    @objc public func reachabilityChanged(notification: Notification) {
        let reachability = notification.object as! Reachability
        switch reachability.connection {
        case .unavailable:
            debugPrint("Network became unreachable")
        case .wifi:
            debugPrint("Network reachable through WiFi")
        default:
            debugPrint("Network reachable through Cellular Data")
        }
        
        // Sending message to each of the delegates
        for listener in listeners {
            listener.networkStatusDidChange(status: reachability.connection)
        }
    }
    
    
    /// Starts monitoring the network availability status
    public func startMonitoring() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.reachabilityChanged),
                                               name: Notification.Name.reachabilityChanged,
                                               object: reachability)
        do{
            try reachability?.startNotifier()
        }catch{
            debugPrint("Could not start reachability notifier")
        }
    }
    
    /// Stops monitoring the network availability status
    public func stopMonitoring(){
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: Notification.Name.reachabilityChanged,
                                                  object: reachability)
    }
    
    /// Adds a new listener to the listeners array
    ///
    /// - parameter delegate: a new listener
    public func addListener(listener: NetworkStatusListener){
        listeners.append(listener)
    }
    
    /// Removes a listener from listeners array
    ///
    /// - parameter delegate: the listener which is to be removed
    public func removeListener(listener: NetworkStatusListener){
        listeners = listeners.filter{ $0 !== listener}
    }
}


///
//MARK: - Example of usage on AppDelegate
//    func applicationDidBecomeActive(_ application: UIApplication) {
//        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//
//        // Starts monitoring network reachability status changes
//        ReachabilityManager.shared.startMonitoring()
//    }

//func applicationWillEnterForeground(_ application: UIApplication) {
//    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//
//    // Stops monitoring network reachability status changes
//    ReachabilityManager.shared.stopMonitoring()
//}

//MARK: - Example of usage on MyViewController
//override func viewWillAppear(_ animated: Bool) {
//    super.viewWillAppear(animated)
//    ReachabilityManager.shared.addListener(listener: self)
//}

//override func viewDidDisappear(_ animated: Bool) {
//    super.viewDidDisappear(animated)
//    ReachabilityManager.shared.removeListener(listener: self)
//}

//extension ViewController: NetworkStatusListener {
//
//    func networkStatusDidChange(status: Reachability.Connection) {
//
//        switch status {
//        case .none:
//          debugPrint("Network became unreachable")
//        case .wifi:
//          debugPrint("Network reachable through WiFi")
//        default:
//          debugPrint("Network reachable through Cellular Data")
//        }
//
//        // Update object Enable/Disable status
//        someObject.isEnabled = !(status == .none)
//    }
//}
#endif
