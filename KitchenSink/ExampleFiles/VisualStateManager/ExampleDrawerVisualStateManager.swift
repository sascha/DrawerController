//
//  ExampleDrawerVisualStateManager.swift
//  DrawerControllerKitchenSink
//
//  Created by Sascha Schwabbauer on 13.09.14.
//  Copyright (c) 2014 evolved.io. All rights reserved.
//

import UIKit

enum DrawerAnimationType: Int {
    case None
    case Slide
    case SlideAndScale
    case SwingingDoor
    case Parallax
}

class ExampleDrawerVisualStateManager: NSObject {
    var leftDrawerAnimationType: DrawerAnimationType = .Parallax
    var rightDrawerAnimationType: DrawerAnimationType = .Parallax
    
    class var sharedManager: ExampleDrawerVisualStateManager {
    struct Static {
        static let instance: ExampleDrawerVisualStateManager = ExampleDrawerVisualStateManager()
        }
        
        return Static.instance
    }
    
    func drawerVisualStateBlockForDrawerSide(drawerSide: DrawerSide) -> DrawerControllerDrawerVisualStateBlock? {
        var animationType: DrawerAnimationType
        
        if drawerSide == DrawerSide.Left {
            animationType = self.leftDrawerAnimationType
        } else {
            animationType = self.rightDrawerAnimationType
        }
        
        var visualStateBlock: DrawerControllerDrawerVisualStateBlock?
        
        switch animationType {
        case .Slide:
            visualStateBlock = DrawerVisualState.slideVisualStateBlock
        case .SlideAndScale:
            visualStateBlock = DrawerVisualState.slideAndScaleVisualStateBlock
        case .Parallax:
            visualStateBlock = DrawerVisualState.parallaxVisualStateBlock(2.0)
        case .SwingingDoor:
            visualStateBlock = DrawerVisualState.swingingDoorVisualStateBlock
        default:
            visualStateBlock = { drawerController, drawerSide, percentVisible in
                var sideDrawerViewController: UIViewController?
                var transform = CATransform3DIdentity
                var maxDrawerWidth: CGFloat = 0.0
                
                if drawerSide == .Left {
                    sideDrawerViewController = drawerController.leftDrawerViewController
                    maxDrawerWidth = drawerController.maximumLeftDrawerWidth
                } else if drawerSide == .Right {
                    sideDrawerViewController = drawerController.rightDrawerViewController
                    maxDrawerWidth = drawerController.maximumRightDrawerWidth
                }
                
                if percentVisible > 1.0 {
                    transform = CATransform3DMakeScale(percentVisible, 1.0, 1.0)
                    
                    if drawerSide == .Left {
                        transform = CATransform3DTranslate(transform, maxDrawerWidth * (percentVisible - 1.0) / 2, 0.0, 0.0)
                    } else if drawerSide == .Right {
                        transform = CATransform3DTranslate(transform, -maxDrawerWidth * (percentVisible - 1.0) / 2, 0.0, 0.0)
                    }
                }
                
                sideDrawerViewController?.view.layer.transform = transform
            }
        }
        
        return visualStateBlock
    }
}
