//
//  SideDrawerSectionHeaderView.swift
//  DrawerControllerKitchenSink
//
//  Created by Sascha Schwabbauer on 14.09.14.
//  Copyright (c) 2014 evolved.io. All rights reserved.
//

import UIKit

class SideDrawerSectionHeaderView: UIView {
    var title: String? {
        didSet {
            self.label?.text = self.title?.uppercaseString
        }
    }
    private var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonSetup()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonSetup()
    }
    
    func commonSetup() {
        self.backgroundColor = UIColor(red: 110 / 255, green: 113 / 255, blue: 115 / 255, alpha: 1.0)
        self.label = UILabel(frame: CGRect(x: 15, y: CGRectGetMaxY(self.bounds) - 28, width: CGRectGetWidth(self.bounds) - 30, height: 22))
        self.label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        self.label.backgroundColor = UIColor.clearColor()
        self.label.textColor = UIColor(red: 203 / 255, green: 206 / 255, blue: 209 / 255, alpha: 1.0)
        self.label.autoresizingMask = .FlexibleWidth | .FlexibleTopMargin
        self.addSubview(self.label)
        self.clipsToBounds = false
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let lineColor = UIColor(red: 94 / 255, green: 97 / 255, blue: 99 / 255, alpha: 1.0)
        CGContextSetStrokeColorWithColor(context, lineColor.CGColor)
        CGContextSetLineWidth(context, 1.0)
        CGContextMoveToPoint(context, CGRectGetMinX(self.bounds), CGRectGetMaxY(self.bounds) - 0.5)
        CGContextAddLineToPoint(context, CGRectGetMaxX(self.bounds), CGRectGetMaxY(self.bounds) - 0.5)
        CGContextStrokePath(context)
    }
}
