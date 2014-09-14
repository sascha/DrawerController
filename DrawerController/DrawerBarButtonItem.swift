//
//  DrawerBarButtonItem.swift
//  FragDenProfessor
//
//  Created by Sascha Schwabbauer on 10.09.14.
//  Copyright (c) 2014 smartcircles. All rights reserved.
//

import UIKit

public class DrawerBarButtonItem: UIBarButtonItem {
    class var drawerButtonImage: UIImage {
    struct Static {
        static let image: UIImage = {
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(26, 26), false, 0)
            
            let fillColor = UIColor.whiteColor()
            let frame = CGRectMake(0, 0, 26, 26)
            
            fillColor.setFill()
            
            let bottomBarPath = UIBezierPath(rect: CGRectMake(CGRectGetMinX(frame) + floor((CGRectGetWidth(frame) - 16) * 0.50000 + 0.5), CGRectGetMinY(frame) + floor((CGRectGetHeight(frame) - 1) * 0.72000 + 0.5), 16, 1))
            bottomBarPath.fill()
            
            let middleBarPath = UIBezierPath(rect: CGRectMake(CGRectGetMinX(frame) + floor((CGRectGetWidth(frame) - 16) * 0.50000 + 0.5), CGRectGetMinY(frame) + floor((CGRectGetHeight(frame) - 1) * 0.48000 + 0.5), 16, 1))
            middleBarPath.fill()
            
            let topBarPath = UIBezierPath(rect: CGRectMake(CGRectGetMinX(frame) + floor((CGRectGetWidth(frame) - 16) * 0.50000 + 0.5), CGRectGetMinY(frame) + floor((CGRectGetHeight(frame) - 1) * 0.24000 + 0.5), 16, 1))
            topBarPath.fill()
            
            return UIGraphicsGetImageFromCurrentImageContext()
        }()
        }
        
        return Static.image
    }
    
    // MARK: - Initializers
    
    public override init() {
        super.init()
    }
    
    public init(target: AnyObject?, action: Selector) {
        super.init(image: DrawerBarButtonItem.drawerButtonImage, style: .Plain, target: target, action: action)
    }
    
    public required convenience init(coder aDecoder: NSCoder) {
        let barButtonItem = UIBarButtonItem(coder: aDecoder)
        self.init(target: barButtonItem.target, action: barButtonItem.action)
    }
}
