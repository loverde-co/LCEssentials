
![](loverde_company_logo_full.png)  
Custom PickerView for Loverde Co. Essentials Swift Scripts
----
> Writen in Swift 4.2 - XCode 11.3
> 
> iOS 11.+
> 
----

This is a repository of my custom PickerView! This plugin is simple and ready to go!

## Features
- [x] Custom Picker View
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


* PickerViewController  

```swift
class MyCustomViewController: UIViewController, PickerViewControllerDelegate {
	
    let pickerController: PickerViewController = PickerViewControllerinstantiate()
    lazy var pickerParams: [[String: Any]] = [["title": "First Choice", "row": 0], ["title": "Sec Choice", "row": 1], ["title": "Third Choice", "row": 2]]
	
    override func viewDidLoad(){
        super.viewDidLoad()
		
    	//Use this custom instantiate
        pickerController.setSelectedRowIndex = 0
        pickerController.delegate = self
        pickerController.setWidth = self.view.bounds.width
        pickerController.setDistanceFromBottom = 50
        pickerController.setFontSize = 20
        pickerController.setFontColor = .black
    }
	
    func showPicker(){
       if pickerController.isHidden {
          pickerController.show()
       }
    }
	
    // You can use multiple instance of it!
    // So, on delegate methods, check the instance
    // and work with it
	
    //MARK: - PickerController Delegate
    func pickerViewController(_ picker: PickerViewController, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    func pickerViewController(didDone picker: PickerViewController, didSelectRow row: Int, inComponent component: Int) {
        printInfo(title: "PICKER", msg: pickerParams[row]["title"] as! String)
    }
    
    func pickerViewController(didCancel picker: PickerViewController) {
        
    }
    
    func pickerViewController(numberOfComponents inPicker: PickerViewController) -> Int {
        return 1
    }
    
    func pickerViewController(_ picker: PickerViewController, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    func pickerViewController(_ picker: PickerViewController, numberOfRowsInComponent component: Int) -> Int {
        return pickerParams.count
    }
    
    func pickerViewController(_ picker: PickerViewController, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerParams[row]["title"] as? String
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
