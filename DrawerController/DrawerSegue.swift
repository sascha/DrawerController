//
//  DrawerControllerSegue.swift
//  DrawerController
//
//  Created by Wang,Shun on 31/12/2016.
//  Copyright © 2016 evolved.io. All rights reserved.
//

import Foundation

fileprivate let center  = "center"
fileprivate let left    = "left"
fileprivate let right   = "right"

class DrawerSegue: UIStoryboardSegue {
    override func perform() {
        assert(self.source is DrawerController, "DrawerSegue only to be used to define left/center/right controllers for a DrawerController!")
    }
}

extension UIViewController {
    
    // check if a viewController can perform segue
    func canPerformSegue(identifier: String) -> Bool {
        let templates: NSArray = self.value(forKey: "storyboardSegueTemplates") as! NSArray
        let predicate: NSPredicate = NSPredicate(format: "identifier=%@", identifier)
        let filteredtemplates = templates.filtered(using: predicate)
        return (filteredtemplates.count > 0)
    }
}

extension DrawerController {
    open override func awakeFromNib() {
        
        guard self.storyboard != nil else { return }
        
        // Required segue "center".  Uncaught exception if undefined in storyboard.
        self.performSegue(withIdentifier: center, sender: self)
        
        // Optional segue "left".
        if self.canPerformSegue(identifier: left) {
            self.performSegue(withIdentifier: left, sender: self)
        }
        
        // Optional segue "right".
        if self.canPerformSegue(identifier: right) {
            self.performSegue(withIdentifier: right, sender: self)
        }
    }
    
    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        assert(segue is DrawerSegue, "Only DrawerSegue could be used in DrawerController")
        
        switch segue.identifier {
            
        case let x where x == center:
            self.centerViewController = segue.destination
            
        case let x where x == left:
            self.leftDrawerViewController = segue.destination
            
        case let x where x == right:
            self.rightDrawerViewController = segue.destination
            
        default: break
            
        }
        
    }
    
}
