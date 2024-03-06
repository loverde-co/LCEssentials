
![](loverde_company_logo_full.png)  
Custom HUD and Alert Controller for Loverde Co. Essentials Swift Scripts
----
> Writen in Swift 5.* - XCode 15.*
> 
> iOS 15.*
> 
----

This is a repository of my custom HUD Alert! This plugin is simple and ready to go!

## Features
- [x] Custom HUD and Alert Controller
- [x] XCode Proj example ([see here all examples](https://github.com/loverde-co/LCEssentials))


Installation
----
#### CocoaPods
You can use [CocoaPods](http://cocoapods.org/) to install `LCImageZoom` by adding it to your `Podfile`:

```ruby
platform :ios, '15.0'
use_frameworks!
pod 'LCEssentials/HUDAlert'
```

Import `LCEssentials` wherever you import UIKit.  
To get the full benefits of `LCEssentials` see the bellow

``` swift
import LCEssentials
```

## Usage example


* ImageZoom  

```swift
class MyCustomViewController: UIViewController, HUDAlertControllerDelegate {
	
       let controller: HUDAlertController = HUDAlertController()
       
    override func viewDidLoad(){
        super.viewDidLoad()
    	//Use this custom instantiate
    }
	
    func showAlert(){
        controller.delegate = self
        controller.isLoadingAlert = false
            let actionContinue = HUDAlertAction("Normal Style", .normal) {
                print("Normal Style")
            }
            let actionGrey = HUDAlertAction("Discrete Style", .discrete) {
                print("Discrete Style")
            }
            let actionCancel = HUDAlertAction("Cancel Style", .cancel) {
                print("Cancel Style")
            }
            let actionDestructive = HUDAlertAction("Destrctive Style", .destructive) {
                print("Destrctive Style")
            }
            let actionGreen = HUDAlertAction("Green Style", .green) {
                print("Green Style")
            }
            controller.setAlert(with: "This is a complete alert", titleColor: .red, description: "With all type of buttons", options: [actionContinue, actionGrey, actionDestructive, actionGreen, actionCancel])
            controller.showAlert()
    }
	
    // You can use multiple instance of it!
    // So, on delegate optional methods, check the instance
    // and work with it
	
    //MARK: - HUDAlert Delegate
    func alert(didOpen alert: HUDAlertController) {
        if alert == self.controller {
        	  //Do some stuffs
        }
    }
        
    func alert(didClose alert: HUDAlertController) {
        if controller == self.controller {
        	  //Do some stuffs
        }
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
