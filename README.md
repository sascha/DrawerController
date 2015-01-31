# Drawer Controller

`DrawerController` is a swift version of the popular `MMDrawerController` by [Mutual Mobile](https://github.com/mutualmobile/MMDrawerController).

Some minor changes in this version include the removal of all < iOS 7.0 related code and the use of spring animations instead of ease-in-ease-out animations. We've also added an animated `BarButtonItem` and plan to enable additional features for regular horizontal size classes (i.e. iPad and iPhone 6 Plus in landscape).

This is currently a work in progress and has not been thoroughly tested. Use at your own risk.

### Installation with CocoaPods
[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C and Swift, which automates and simplifies the process of using 3rd-party libraries like DrawerController in your projects. At this time Swift is only supported in the latest [pre-release](http://blog.cocoapods.org/Pod-Authors-Guide-to-CocoaPods-Frameworks/).

#### Podfile

```ruby
platform :ios, '8.0'
pod 'DrawerController', '~> 1.0'
```

---
## Credit

Originally designed and developed by the fine folks at [Mutual Mobile](http://mutualmobile.com).

Swift version by

* [Sascha Schwabbauer](http://twitter.com/_saschas)
* [Malte Baumann](http://twitter.com/codingdivision)

---
##License

`DrawerController` is available under the MIT license. See the LICENSE file for more info.