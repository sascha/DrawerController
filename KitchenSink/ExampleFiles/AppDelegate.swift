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
        let leftSideDrawerViewController = ExampleLeftSideDrawerViewController()
        let centerViewController = ExampleCenterTableViewController()
        let rightSideDrawerViewController = ExampleRightSideDrawerViewController()
        
        let navigationController = UINavigationController(rootViewController: centerViewController)
        navigationController.restorationIdentifier = "ExampleCenterNavigationControllerRestorationKey"
        
        let rightSideNavController = UINavigationController(rootViewController: rightSideDrawerViewController)
        rightSideNavController.restorationIdentifier = "ExampleRightNavigationControllerRestorationKey"
        
        let leftSideNavController = UINavigationController(rootViewController: leftSideDrawerViewController)
        leftSideNavController.restorationIdentifier = "ExampleLeftNavigationControllerRestorationKey"
        
        self.drawerController = DrawerController(centerViewController: navigationController, leftDrawerViewController: leftSideNavController, rightDrawerViewController: rightSideNavController)
        self.drawerController.showsShadows = false
        
        self.drawerController.restorationIdentifier = "Drawer"
        self.drawerController.maximumRightDrawerWidth = 200.0
        self.drawerController.openDrawerGestureModeMask = .all
        self.drawerController.closeDrawerGestureModeMask = .all
        
        self.drawerController.drawerVisualStateBlock = { (drawerController, drawerSide, percentVisible) in
            let block = ExampleDrawerVisualStateManager.sharedManager.drawerVisualStateBlock(for: drawerSide)
            block?(drawerController, drawerSide, percentVisible)
        }
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let tintColor = UIColor(red: 29 / 255, green: 173 / 255, blue: 234 / 255, alpha: 1.0)
        self.window?.tintColor = tintColor
        
        self.window?.rootViewController = self.drawerController
        
        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window?.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()
        
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
                return self.window?.rootViewController
            } else if key == "ExampleCenterNavigationControllerRestorationKey" {
                return (self.window?.rootViewController as! DrawerController).centerViewController
            } else if key == "ExampleRightNavigationControllerRestorationKey" {
                return (self.window?.rootViewController as! DrawerController).rightDrawerViewController
            } else if key == "ExampleLeftNavigationControllerRestorationKey" {
                return (self.window?.rootViewController as! DrawerController).leftDrawerViewController
            } else if key == "ExampleLeftSideDrawerController" {
                if let leftVC = (self.window?.rootViewController as? DrawerController)?.leftDrawerViewController {
                    if leftVC.isKind(of: UINavigationController.self) {
                        return (leftVC as! UINavigationController).topViewController
                    } else {
                        return leftVC
                    }
                }
            } else if key == "ExampleRightSideDrawerController" {
                if let rightVC = (self.window?.rootViewController as? DrawerController)?.rightDrawerViewController {
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

