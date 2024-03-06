
![](loverde_company_logo_full.png)  
Loverde Co. Essentials Swift Scripts
----

This is a repository of essential scripts written in Swift for Loverde Co. used to save time on re-writing and keeping it on all other projects. So this Cocoapods will evolve with Swift and will improve with every release!

## Features
- [x] Many usefull scripts extensions
- [x] Background Thread
- [x] Custom change Root View Controller with animation
- [x] Pop To View Controller with animation
- [x] Stars Rating Designable
- [x] Many others usefull Designables
- [x] Create a XCode Proj example with principal features


Installation
----
#### CocoaPods
You can use [CocoaPods](http://cocoapods.org/) to install `LCEssentials` by adding it to your `Podfile`:

```ruby
platform :ios, '15.0'
use_frameworks!

# Swift 5.0
pod 'LCEssentials'

# Swift 4.2
pod 'LCEssentials', '~> 0.4.6.3'
```

To get the full benefits import `LCEssentials` wherever you import UIKit

``` swift
import LCEssentials
```

#### Swift Package  Manager (SPM)
``` swift
dependencies: [
    .package(url: "https://github.com/loverde-co/LCEssentials.git", .upToNextMajor(from: "0.5.8"))
]
```

You can also add it via XCode SPM editor with URL: 

``` swift
https://github.com/loverde-co/LCEssentials.git
```

## Usage example

* Background Trhead  

```swift
LCEssentials.backgroundThread(delay: 0.6, background: {
            //Do something im background
        }) {
            //When finish, update UI
        }
```
* NavigationController with Completion Handler  

```swift
self.navigationController?.popViewControllerWithHandler(completion: {
            //Do some stuff after pop
        })
        
//or more simple
self.navigationController?.popViewControllerWithHandler {
    //Do some stuff after pop
}
```
## Another components
> **TEMPORARY DISABLED**
> 
> * See the custom [PickerViewController](PickerViewController.md) 
> * See the custom [DatePickerViewController](DatePickerViewController.md)
> * See the custom [NotificationsController](NotificationsController.md) 
 
* See the custom [ImageZoomController](ImageZoomController.md) 
* See the custom [HUDAlert](HUDAlert.md) 

* If you whant **ONLY** LCEssentials without this others controllers above, just add this to your podfile

```ruby
platform :ios, '15.0'
use_frameworks!
pod 'LCEssentials/Classes'
```
And then import `LCEssentials ` wherever you import UIKit

``` swift
import LCEssentials
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
