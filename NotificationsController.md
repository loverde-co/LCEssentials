
![](loverde_company_logo_full.png)  
Custom Notifications for Loverde Co. Essentials Swift Scripts
----
> Writen in Swift 5.0 - XCode 15.3
> 
> iOS 15.+
> 
----

This is a repository of my custom Notifications! This plugin is simple and ready to go!

## Features
- [x] Can change color of almost everything
- [x] Animation Bottom and Top for Notifications
- [x] Animation Top only Runtime Notification
- [x] Create a XCode Proj example ([see here all examples](https://github.com/loverde-co/LCEssentials))


Installation
----
#### CocoaPods
You can use [CocoaPods](http://cocoapods.org/) to install `LCENotifications` by adding it to your `Podfile`:

```ruby
platform :ios, '15.0'
use_frameworks!
pod 'LCEssentials/Notifications'
```

Import `LCEssentials` wherever you import UIKit.  
To get the full benefits of `LCEssentials` see bellow  

``` swift
import LCEssentials
```

## Usage example


* LCENotificationRunTime  

```swift
class MyCustomViewController: UIViewController, LCENotifiactionRunTimeDelegate {
	
    override func viewDidLoad(){
        super.viewDidLoad()
		
    	//Use this custom instantiate
    }
	
    func openNotificationRuntime(){
        let notif = LCENotificationRunTime.instantiate()
        notif.delegate = self
        notif.anyData = nil //If you need grab any data to handler on Delegate
        notif.setDesc = "Description on received message"
        notif.setTitle = "Title on received message"
        notif.setHeight = LCEssentials.X_DEVICES ? 130 : 100 //Trick for X Devices height from bottom
        notif.show()
    }
	
    // You can use multiple instance of it!
    // So, on delegate methods, check the instance
    // and work with it
	
    //MARK: - Notification Runtime Delegate
    func messages(didTapOnMessage: LCENotificationRunTime, withData: Any?) {
        printInfo(title: "TAPPED ON NOTIFICATION RUNTIME", msg: "")
    }
    func messages(didSwipeOnMessage: LCENotificationRunTime, withData: Any?) {
        printInfo(title: "SWIPPED NOTIFICATION RUNTIME", msg: "")
    }
}
```


* LCEMessages  

```swift
class MyCustomViewController: UIViewController, LCEMessagesDelegate {
	
    override func viewDidLoad(){
        super.viewDidLoad()
		
    	//Use this custom instantiate
    }
	
    func openMessageAlert(){
        let message = LCEMessages.instantiate()
        message.viewWillAppear(true)
        message.delegate = self
        message.addObserverForKeyboard()
        message.setDirection = .bottom
        message.setDuration = .fiveSecs
        message.tapToDismiss = true
        message.setBackgroundColor = .darkGray
        message.show(message: "Testing message bottom with loading", withImage: nil, showLoading: true)
    }
	
    // You can use multiple instance of it!
    // So, on delegate methods, check the instance
    // and work with it
	
    //MARK: - Messages Delegate
    func messages(didTapOnMessage: LCEMessages) {
        //Do some stuffs
    }
}
```

Author of v0.8.0
----

Any question or doubts, please send thru email

Daniel Arantes Loverde - <daniel@loverde.com.br>

[![Alt text](https://loverde.com.br/_signature/loverde_github_mail.gif "My Resume")](https://github.com/loverde-co/resume/)
[![Alt text](https://loverde.com.br/_signature/loverde_bitbucket_mail.gif "Loverde Co. Bitbucket")](https://bitbucket.org/loverde_co)
[![Alt text](https://loverde.com.br/_signature/loverde_github_mail.gif "Loverde Co. Github")](https://github.com/loverde-co)
[![Alt text](https://loverde.com.br/_signature/loverde_twitter_mail.gif "Personal Twitter")](http://twitter.com/jack_loverde)
[![Alt text](https://loverde.com.br/_signature/loverde_instagram_mail.gif "Personal Instagram")](https://instagram.com/loverde)
