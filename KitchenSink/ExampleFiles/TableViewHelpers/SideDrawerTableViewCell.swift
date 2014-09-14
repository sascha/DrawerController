//
//  SideDrawerTableViewCell.swift
//  DrawerControllerKitchenSink
//
//  Created by Sascha Schwabbauer on 14.09.14.
//  Copyright (c) 2014 evolved.io. All rights reserved.
//

import UIKit

class SideDrawerTableViewCell: TableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.commonSetup()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonSetup()
    }
    
    func commonSetup() {
        self.accessoryCheckmarkColor = UIColor.whiteColor()
        let backgroundView = UIView(frame: self.bounds)
        backgroundView.autoresizingMask = .FlexibleHeight | .FlexibleWidth
        let backgroundColor = UIColor(red: 122 / 255, green: 126 / 255, blue: 128 / 255, alpha: 1.0)
        backgroundView.backgroundColor = backgroundColor
        
        self.backgroundView = backgroundView
        
        self.textLabel?.backgroundColor = UIColor.clearColor()
        self.textLabel?.textColor = UIColor(red: 230 / 255, green: 236 / 255, blue: 242 / 255, alpha: 1.0)
    }
    
    override func updateContentForNewContentSize() {
        self.textLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    }
}
