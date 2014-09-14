//
//  ExampleViewController.swift
//  DrawerControllerKitchenSink
//
//  Created by Sascha Schwabbauer on 14.09.14.
//  Copyright (c) 2014 evolved.io. All rights reserved.
//

import UIKit

class ExampleViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "contentSizeDidChangeNotification:", name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
    
    private func contentSizeDidChangeNotification(notification: NSNotification) {
        if let userInfo: NSDictionary = notification.userInfo {
            self.contentSizeDidChange(userInfo[UIContentSizeCategoryNewValueKey] as String)
        }
    }
    
    func contentSizeDidChange(size: String) {
        // Implement in subclass
    }
}
