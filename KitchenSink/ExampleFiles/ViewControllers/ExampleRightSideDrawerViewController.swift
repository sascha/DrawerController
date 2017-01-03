
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

import UIKit

class ExampleRightSideDrawerViewController: ExampleSideDrawerViewController {   
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.restorationIdentifier = "ExampleRightSideDrawerController"
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.restorationIdentifier = "ExampleRightSideDrawerController"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Right will appear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Right did appear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("Right will disappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("Right did disappear")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Right Drawer"
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == DrawerSection.drawerWidth.rawValue {
            return "Right Drawer Width"
        } else {
            return super.tableView(tableView, titleForHeaderInSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if (indexPath as NSIndexPath).section == DrawerSection.drawerWidth.rawValue {
            let width = self.drawerWidths[(indexPath as NSIndexPath).row]
            let drawerWidth = self.evo_drawerController?.maximumRightDrawerWidth
            
            if drawerWidth == width {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            
            cell.textLabel?.text = "Width \(self.drawerWidths[(indexPath as NSIndexPath).row])"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).section == DrawerSection.drawerWidth.rawValue {
            self.evo_drawerController?.setMaximumRightDrawerWidth(self.drawerWidths[(indexPath as NSIndexPath).row], animated: true, completion: { (finished) -> Void in
                tableView.reloadSections(IndexSet(integer: (indexPath as NSIndexPath).section), with: .none)
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                tableView.deselectRow(at: indexPath, animated: true)
            })
        } else {
            super.tableView(tableView, didSelectRowAt: indexPath)
        }
    }
}
