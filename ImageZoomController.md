
![](loverde_company_logo_full.png)  
Custom Image Zoom Controller for Loverde Co. Essentials Swift Scripts
----
> Writen in Swift 5.0 - XCode 15.3
> 
> iOS 15.+
> 
----

This is a repository of my custom Image Zoom! This plugin is simple and ready to go!

## Features
- [x] Custom Image Zoom
- [x] XCode Proj example ([see here all examples](https://github.com/loverde-co/LCEssentials))


Installation
----
#### CocoaPods
You can use [CocoaPods](http://cocoapods.org/) to install `LCImageZoom` by adding it to your `Podfile`:

```ruby
platform :ios, '15.0'
use_frameworks!
pod 'LCEssentials/ImageZoom'
```

Import `LCEssentials` wherever you import UIKit.  
To get the full benefits of `LCEssentials` see the bellow

``` swift
import LCEssentials
```

## Usage example


* ImageZoom  

```swift
class MyCustomViewController: UIViewController, ImageZoomControllerDelegate {
	
       let imageZoomController: ImageZoomController = ImageZoomController()
       
    override func viewDidLoad(){
        super.viewDidLoad()
    	//Use this custom instantiate
    }
	
    func showImage(){
        guard let image = UIImage(named: "some_image") else { return }
        let imageZoomController: ImageZoomController = ImageZoomController(image)
        imageZoomController.delegate = self
        imageZoomController.present()
    }
	
    // You can use multiple instance of it!
    // So, on delegate methods, check the instance
    // and work with it
	
    //MARK: - Image Zoom Delegate
    func imageZoomController(controller: ImageZoomController, didZoom image: UIImage?) {
        if controller == self.imageZoomController {
        	  //Do some stuffs
        }
    }
        
    func imageZoomController(controller: ImageZoomController, didClose image: UIImage?) {
        if controller == self.imageZoomController {
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
