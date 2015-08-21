//
//  ExampleDrawerController.swift
//
//  Created by Charlie Woloszynski on 8/20/15.
//
//

import UIKit
import DrawerController

/**
This segue class is used to support Storyboard use of the ExampleDrawerController class.  In IB, a custom segue can be used to connect the centerViewController, leftDrawerViewController, and rightDrawerViewController
with this class.  To do this, the developer needs to name the segues with the identifiers 'centerViewController', 'leftDrawerViewController', and 'rightDrawerViewController'.

In viewDidLoad, DrawerController will attempt to perform each of these segues.  This allows the developer in IB to set the view controllers graphically.

**/

enum EmbedWithinDrawerControllerSegue : String {
    case centerViewController = "centerViewController"
    case leftDrawerViewController = "leftDrawerViewController"
    case rightDrawerViewController = "rightDrawerViewController"
}

class EmbedWithinDrawerController : UIStoryboardSegue {
    override func perform() {
        // This segue does nothing during its actual execution
    }
}

class ExampleDrawerController: DrawerController {
    
    var stateRestored = false


    override func viewDidLoad() {
        super.viewDidLoad()

        performSegueWithIdentifier(EmbedWithinDrawerControllerSegue.centerViewController.rawValue, sender: self)
        performSegueWithIdentifier(EmbedWithinDrawerControllerSegue.rightDrawerViewController.rawValue, sender: self)
        
        maximumRightDrawerWidth = 160.0
        showsShadows = false
        closeDrawerGestureModeMask = .All
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.isKindOfClass(EmbedWithinDrawerController) {
            switch segue.identifier! {
            case EmbedWithinDrawerControllerSegue.centerViewController.rawValue:
                self.centerViewController = segue.destinationViewController as? UIViewController
            case EmbedWithinDrawerControllerSegue.rightDrawerViewController.rawValue:
                self.rightDrawerViewController = segue.destinationViewController as? UIViewController
            case EmbedWithinDrawerControllerSegue.leftDrawerViewController.rawValue:
                self.leftDrawerViewController = segue.destinationViewController as? UIViewController
            default:
                println("Unexpected segue identifier of class \(segue.dynamicType)")
            }
            return
        }
    }
}
