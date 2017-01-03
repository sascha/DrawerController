// Copyright (c) 2017 evolved.io (http://evolved.io)
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

import UIKit
import DrawerController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var drawerController: DrawerController!
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       
        let tintColor = UIColor(red: 29 / 255, green: 173 / 255, blue: 234 / 255, alpha: 1.0)
        window?.tintColor = tintColor
        drawerController = window?.rootViewController! as! DrawerController
        drawerController.showsShadows = false
        
        drawerController.restorationIdentifier = "Drawer"
        drawerController.maximumRightDrawerWidth = 200.0
        drawerController.openDrawerGestureModeMask = .all
        drawerController.closeDrawerGestureModeMask = .all
        
        drawerController.drawerVisualStateBlock = { (drawerController, drawerSide, percentVisible) in
            let block = ExampleDrawerVisualStateManager.sharedManager.drawerVisualStateBlock(for: drawerSide)
            block?(drawerController, drawerSide, percentVisible)
        }
        
        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, viewControllerWithRestorationIdentifierPath identifierComponents: [Any], coder: NSCoder) -> UIViewController? {
        if let key = identifierComponents.last as? String {
            if key == "Drawer" {
                return window?.rootViewController
            } else if key == "ExampleCenterNavigationControllerRestorationKey" {
                return (window?.rootViewController as! DrawerController).centerViewController
            } else if key == "ExampleRightNavigationControllerRestorationKey" {
                return (window?.rootViewController as! DrawerController).rightDrawerViewController
            } else if key == "ExampleLeftNavigationControllerRestorationKey" {
                return (window?.rootViewController as! DrawerController).leftDrawerViewController
            } else if key == "ExampleLeftSideDrawerController" {
                if let leftVC = (window?.rootViewController as? DrawerController)?.leftDrawerViewController {
                    if leftVC.isKind(of: UINavigationController.self) {
                        return (leftVC as! UINavigationController).topViewController
                    } else {
                        return leftVC
                    }
                }
            } else if key == "ExampleRightSideDrawerController" {
                if let rightVC = (window?.rootViewController as? DrawerController)?.rightDrawerViewController {
                    if rightVC.isKind(of: UINavigationController.self) {
                        return (rightVC as! UINavigationController).topViewController
                    } else {
                        return rightVC
                    }
                }
            }
        }
        
        return nil
    }

}

