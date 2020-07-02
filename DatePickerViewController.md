
![](loverde_company_logo_full.png)  
Custom DatePicker for Loverde Co. Essentials Swift Scripts
----
> Writen in Swift 4.2 - XCode 11.3
> 
> iOS 11.+
> 
----

This is a repository of my custom PickerView! This plugin is simple and ready to go!

## Features
- [x] Custom DatePicker View
- [x] Can change color of almost everything
- [x] Animation Bottom to Top only :(
- [x] Create a XCode Proj example


Installation
----
#### CocoaPods
You can use [CocoaPods](http://cocoapods.org/) to install `LCEssentials` by adding it to your `Podfile`:

```ruby
platform :ios, '10.0'
use_frameworks!
pod 'LCEssentials/PickerViews'
```

Import `LCEssentials` wherever you import UIKit.  
To get the full benefits of `LCEssentials` see the [README](README.md)

``` swift
import LCEssentials
```

## Usage example


* DatePickerViewController  

```swift
class MyCustomViewController: UIViewController, DatePickerViewControllerDelegate {

   //Use this custom instantiate
   let datePickerController: DatePickerViewController = DatePickerViewController.instantiate()
	
    override func viewDidLoad(){
       super.viewDidLoad()
       datePickerController.delegate = self
       //For hour
       datePickerController.setDatePickerMode = .time
       datePickerController.setFormat = "HH:mm"
       //If you whant a date format, you can pre-select a date
       //datePickerController.setSelectedDate = "30/06/2020"
    }
	
    func showPicker(){
       if datePickerController.isHidden {
           datePickerController.show()
       }
    }
	
	
    // You can use multiple instance of it!
    // So, on delegate methods, check the instance
    // and work with it
	
    //MARK: - DatePickerController Delegate
    func datePickerViewController(didConfirm picker: DatePickerViewController, withValue: String) {
        if picker == self.datePickerController {
            //Do something with the date value in String or
            //grab picker.date for Date object
        }
    }
    
    func datePickerViewController(didCancel picker: DatePickerViewController) {
        //Do something when canceled
    }
    
    func datePickerViewController(didEndScrollPicker picker: DatePickerViewController, withValue: String) {
        //Grab date value in String or picker.date Date object on every scroll ended
    }
}
```


Author of v1.0
----

Any question or doubts, please send thru email

Daniel Arantes Loverde - <daniel@loverde.com.br>

[![Alt text](https://loverde.com.br/_signature/loverde_github_mail.gif "My Resume")](https://github.com/loverde-co/resume/)
[![Alt text](https://loverde.com.br/_signature/loverde_bitbucket_mail.gif "Loverde Co. Bitbucket")](https://bitbucket.org/loverde_co)
[![Alt text](https://loverde.com.br/_signature/loverde_github_mail.gif "Loverde Co. Github")](https://github.com/loverde-co)
[![Alt text](https://loverde.com.br/_signature/loverde_twitter_mail.gif "Personal Twitter")](http://twitter.com/jack_loverde)
[![Alt text](https://loverde.com.br/_signature/loverde_instagram_mail.gif "Personal Instagram")](https://instagram.com/loverde)
