
![](loverde_company_logo_full.png)
Loverde Co. Essentials Swift Scripts
----
> Writen in Swift 4 - XCode 9.3.1
> 
> iOS 10.+

-
This is a repository of essential scripts written in Swift for Loverde Co. used to save time on re-writing and keeping it on all other projects. So this Cocoapods will evolve with Swift and will improve with every release!

## Features
- [x] Background Thread
- [x] Custom change Root View Controller with animation
- [x] Pop To View Controller with animation
- [x] Stars Rating Designable
- [x] Many others usefull Designables
- [ ] Create a XCode Proj example with all features


Installation
----
#### CocoaPods
You can use [CocoaPods](http://cocoapods.org/) to install `LCEssentials` by adding it to your `Podfile`:

```ruby
platform :ios, '10.0'
use_frameworks!
pod 'LCEssentials'
```

To get the full benefits import `LCEssentials` wherever you import UIKit

``` swift
import LCEssentials
```

## Usage example

* Background Trhead  

```swift
Defaults().backgroundThread(delay: 0.6, background: {
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


Author of v1.0
----

Any question or doubts, please send thru email

Daniel Arantes Loverde - <daniel@loverde.com.br>

[![Alt text](https://loverde.com.br/_signature/loverde_github_mail.gif "My Resume")](https://github.com/loverde-co/resume/)
[![Alt text](https://loverde.com.br/_signature/loverde_bitbucket_mail.gif "Loverde Co. Bitbucket")](https://bitbucket.org/loverde_co)
[![Alt text](https://loverde.com.br/_signature/loverde_github_mail.gif "Loverde Co. Github")](https://github.com/loverde-co)
[![Alt text](https://loverde.com.br/_signature/loverde_twitter_mail.gif "Personal Twitter")](http://twitter.com/jack_loverde)
[![Alt text](https://loverde.com.br/_signature/loverde_instagram_mail.gif "Personal Instagram")](https://instagram.com/loverde)