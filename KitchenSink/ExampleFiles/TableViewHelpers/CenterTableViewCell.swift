//
//  CenterTableViewCell.swift
//  DrawerControllerKitchenSink
//
//  Created by Sascha Schwabbauer on 14.09.14.
//  Copyright (c) 2014 evolved.io. All rights reserved.
//

import UIKit

class CenterTableViewCell: TableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryCheckmarkColor = UIColor(red: 13 / 255, green: 88 / 255, blue: 161 / 255, alpha: 1.0)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.accessoryCheckmarkColor = UIColor(red: 13 / 255, green: 88 / 255, blue: 161 / 255, alpha: 1.0)
    }
    
    override func updateContentForNewContentSize() {
        self.textLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    }
}
