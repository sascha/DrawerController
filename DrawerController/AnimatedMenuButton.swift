//
//  MenuButton.swift
//  kikkuk
//
//  Created by Malte Baumann on 08.09.14.
//  Copyright (c) 2014 codingdivision. All rights reserved.
//

import Foundation
import QuartzCore
import UIKit

public class AnimatedMenuButton : UIButton {
    
    var top: CAShapeLayer! = CAShapeLayer()
    var middle: CAShapeLayer! = CAShapeLayer()
    var bottom: CAShapeLayer! = CAShapeLayer()
    
    // MARK: - Constants
    
    let animationDuration: CFTimeInterval = 8.0
    
    let shortStroke: CGPath = {
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, 2, 2)
        CGPathAddLineToPoint(path, nil, 30 - 2 * 2, 2)
        return path
        }()
    
    // MARK: - Initializers
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        self.top.path = shortStroke;
        self.middle.path = shortStroke;
        self.bottom.path = shortStroke;
        
        for layer in [ self.top, self.middle, self.bottom ] {
            layer.fillColor = nil
            layer.strokeColor = UIColor.grayColor().CGColor
            layer.lineWidth = 4
            layer.miterLimit = 2
            layer.lineCap = kCALineCapRound
            layer.masksToBounds = true
            
            let strokingPath = CGPathCreateCopyByStrokingPath(layer.path, nil, 4, kCGLineCapRound, kCGLineJoinMiter, 4)
            
            layer.bounds = CGPathGetPathBoundingBox(strokingPath)
            
            layer.actions = [
                "opacity": NSNull(),
                "transform": NSNull()
            ]
            
            self.layer.addSublayer(layer)
        }
        
        self.top.anchorPoint = CGPointMake(1, 0.5)
        self.top.position = CGPointMake(30 - 1, 5)
        self.middle.position = CGPointMake(15, 15)
        
        self.bottom.anchorPoint = CGPointMake(1, 0.5)
        self.bottom.position = CGPointMake(30-1, 25)
    }
    
    // MARK: - Animations
    
    public func animateWithPercentVisible(percentVisible:CGFloat, drawerSide: DrawerSide) {
        
        if (drawerSide == DrawerSide.Left) {
            self.top.anchorPoint = CGPointMake(1, 0.5)
            self.top.position = CGPointMake(30 - 1, 5)
            self.middle.position = CGPointMake(15, 15)
            
            self.bottom.anchorPoint = CGPointMake(1, 0.5)
            self.bottom.position = CGPointMake(30-1, 25)
        } else if (drawerSide == DrawerSide.Right) {
            self.top.anchorPoint = CGPointMake(0, 0.5)
            self.top.position = CGPointMake(1, 5)
            self.middle.position = CGPointMake(15, 15)
            
            self.bottom.anchorPoint = CGPointMake(0, 0.5)
            self.bottom.position = CGPointMake(1, 25)
        }
        
        let middleTransform = CABasicAnimation(keyPath: "opacity")
        middleTransform.duration = animationDuration
        
        let topTransform = CABasicAnimation(keyPath: "transform")
        topTransform.timingFunction = CAMediaTimingFunction(controlPoints: 0.5, -0.8, 0.5, 1.85)
        topTransform.duration = animationDuration
        topTransform.fillMode = kCAFillModeBackwards
        
        let bottomTransform = topTransform.copy() as CABasicAnimation
        
        middleTransform.toValue = 1 - percentVisible
        
        let translation = CATransform3DMakeTranslation(-4 * percentVisible, 0, 0)
        
        let sideInverter: CGFloat = drawerSide == DrawerSide.Left ? -1 : 1
        topTransform.toValue = NSValue(CATransform3D: CATransform3DRotate(translation, 1.0 * sideInverter * ((CGFloat)(45.0 * M_PI / 180.0) * percentVisible), 0, 0, 1))
        bottomTransform.toValue = NSValue(CATransform3D: CATransform3DRotate(translation, (-1.0 * sideInverter * (CGFloat)(45.0 * M_PI / 180.0) * percentVisible), 0, 0, 1))

        topTransform.beginTime = CACurrentMediaTime()
        bottomTransform.beginTime = CACurrentMediaTime()
        
        self.top.addAnimation(topTransform, forKey: topTransform.keyPath)
        self.middle.addAnimation(middleTransform, forKey: middleTransform.keyPath)
        self.bottom.addAnimation(bottomTransform, forKey: bottomTransform.keyPath)
        
        self.top.setValue(topTransform.toValue, forKey: topTransform.keyPath)
        self.middle.setValue(middleTransform.toValue, forKey: middleTransform.keyPath)
        self.bottom.setValue(bottomTransform.toValue, forKey: bottomTransform.keyPath)
    }
}