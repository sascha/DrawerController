//
//  DrawerBarButtonItem.swift
//  FragDenProfessor
//
//  Created by Sascha Schwabbauer on 10.09.14.
//  Copyright (c) 2014 smartcircles. All rights reserved.
//

import UIKit
import Foundation

public class DrawerBarButtonItem: UIBarButtonItem {
    
    public var menuButton: AnimatedMenuButton?
    
    // MARK: - Initializers
    
    public override init() {
        super.init()
    }
    
    public init(target: AnyObject?, action: Selector) {
        self.menuButton = AnimatedMenuButton(frame: CGRectMake(0, 0, 30, 30))
        self.menuButton?.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        
        super.init(customView: self.menuButton!)
    }
    
    public required convenience init(coder aDecoder: NSCoder) {
        let barButtonItem = UIBarButtonItem(coder: aDecoder)
        self.init(target: barButtonItem.target, action: barButtonItem.action)
    }
    
    // MARK: - Animations
    
    public func animateWithPercentVisible(percentVisible: CGFloat, drawerSide: DrawerSide) {
        if let btn = self.customView as? AnimatedMenuButton {
            btn.animateWithPercentVisible(percentVisible, drawerSide: drawerSide)
        }
    }
}
