// Copyright (c) 2014 evolved.io (http://evolved.io)
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

import UIKit

class ExampleLeftSideDrawerViewController: ExampleSideDrawerViewController {    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.restorationIdentifier = "ExampleLeftSideDrawerController"
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.restorationIdentifier = "ExampleLeftSideDrawerController"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("Left will appear")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("Left did appear")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        print("Left will disappear")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        print("Left did disappear")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Left Drawer"
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == DrawerSection.DrawerWidth.rawValue {
            return "Left Drawer Width"
        } else {
            return super.tableView(tableView, titleForHeaderInSection: section)
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        
        if indexPath.section == DrawerSection.DrawerWidth.rawValue {
            let width = self.drawerWidths[indexPath.row]
            let drawerWidth = self.evo_drawerController?.maximumLeftDrawerWidth
            
            if drawerWidth == width {
                cell.accessoryType = .Checkmark
            } else {
                cell.accessoryType = .None
            }
            
            cell.textLabel?.text = "Width \(self.drawerWidths[indexPath.row])"
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == DrawerSection.DrawerWidth.rawValue {
            self.evo_drawerController?.setMaximumLeftDrawerWidth(self.drawerWidths[indexPath.row], animated: true, completion: { (finished) -> Void in
                tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .None)
                tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            })
        } else {
            super.tableView(tableView, didSelectRowAtIndexPath: indexPath)
        }
    }
}
