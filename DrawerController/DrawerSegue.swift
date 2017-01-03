// Copyright (c) 2017 evolved.io (http://evolved.io)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
// Created by Wang,Shun on 31/12/2016.
//

import UIKit

public class DrawerSegue: UIStoryboardSegue {
    override public func perform() {
        assert(source is DrawerController, "DrawerSegue can only be used to define left/center/right controllers for a DrawerController")
    }
}

fileprivate extension UIViewController {
    
    // check if a view controller can perform segue
    func canPerformSegue(withIdentifier identifier: String) -> Bool {
        let templates: NSArray = value(forKey: "storyboardSegueTemplates") as! NSArray
        let predicate: NSPredicate = NSPredicate(format: "identifier=%@", identifier)
        let filteredtemplates = templates.filtered(using: predicate)
        return filteredtemplates.count > 0
    }
}

extension DrawerController {

    private enum Keys: String {
        case center = "center"
        case left = "left"
        case right = "right"
    }

    open override func awakeFromNib() {
        guard storyboard != nil else {
            return
        }
        
        // Required segue "center". Uncaught exception if undefined in storyboard.
        performSegue(withIdentifier: Keys.center.rawValue, sender: self)
        
        // Optional segue "left".
        if canPerformSegue(withIdentifier: Keys.left.rawValue) {
            performSegue(withIdentifier: Keys.left.rawValue, sender: self)
        }
        
        // Optional segue "right".
        if canPerformSegue(withIdentifier: Keys.right.rawValue) {
            performSegue(withIdentifier: Keys.right.rawValue, sender: self)
        }
    }
    
    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue is DrawerSegue {
            switch segue.identifier {
            case let x where x == Keys.center.rawValue:
                centerViewController = segue.destination
            case let x where x == Keys.left.rawValue:
                leftDrawerViewController = segue.destination
            case let x where x == Keys.right.rawValue:
                rightDrawerViewController = segue.destination
            default:
                break
            }
            
            return
        }

        super.prepare(for: segue, sender: sender)
    }
    
}
