//
//  NavigationController.swift
//  DrawerControllerKitchenSink
//
//  Created by Sascha Schwabbauer on 14.09.14.
//  Copyright (c) 2014 evolved.io. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        if let drawerController = self.evo_drawerController {
            if drawerController.showsStatusBarBackgroundView {
                return .LightContent
            }
        }
        
        return .Default
    }
}
