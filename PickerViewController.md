
![](loverde_company_logo_full.png)  
Custom PickerView for Loverde Co. Essentials Swift Scripts
----
> Writen in Swift 4 - XCode 9.3.1
> 
> iOS 10.+
> 
----

This is a repository of my custom PickerView! This plugin is simple and ready to go!

## Features
- [x] Custom Picker View
- [x] Can change color of almost everything
- [x] Animation Bottom to Top only :(
- [ ] Create a XCode Proj example


Installation
----
#### CocoaPods
You can use [CocoaPods](http://cocoapods.org/) to install `LCEssentials` by adding it to your `Podfile`:

```ruby
platform :ios, '10.0'
use_frameworks!
pod 'LCEssentials'
```

Import `LCEssentials` wherever you import UIKit.  
To get the full benefits of `LCEssentials` see the [README](README.md)

``` swift
import LCEssentials
```

## Usage example


* PickerViewController  

```swift
MyCustomViewController: UIViewController, PickerViewControllerDelegate {
	
	var pickerViewController: PickerViewController!
	
	override func viewDidLoad(){
		super.viewDidLoad()
		//Use this custom instantiate
        self.pickerViewController = PickerViewController.instantiate()
        self.pickerViewController.arrayParams = [["title":"Title Of Picker 01", "row": 0],
                                                   ["title":"Title Of Picker 02", "row": 1],
                                                   ["title":"Title Of Picker 03", "row": 2]]
        self.pickerViewController.setWidth = self.view.frame.size.width
        self.pickerViewController.delegate = self
	}
	
	func showPicker(){
	    self.pickerViewController.show()
	}
	
	// You can use multiple instance of it!
	// So, on delegate methods, check the instance
	// and work with it
	
	//MARK: - PickerController Delegate
    func pickerViewController(_ picker: PickerViewController, didConfirm selectedString: String, selectedValue: Int) {
        if picker == self.pickerViewController {
            //Grab Selected String an Value Int
        }
    }
    
    func pickerViewController(didCancel picker: PickerViewController) {
    	if picker == self.pickerViewController {
            //Do something when canceled
        }
    }
    
    func pickerViewController(_ picker: PickerViewController, didEndScrollPicker SelectedString: String, SelectedValue: Int) {
    	if picker == self.pickerViewController {
            //Grab String an Value Int on every scroll ended
        }
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