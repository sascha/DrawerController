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
import DrawerController

enum DrawerSection: Int {
    case viewSelection
    case drawerWidth
    case shadowToggle
    case openDrawerGestures
    case closeDrawerGestures
    case centerHiddenInteraction
    case stretchDrawer
}

class ExampleSideDrawerViewController: ExampleViewController, UITableViewDataSource, UITableViewDelegate {
    var tableView: UITableView!
    let drawerWidths: [CGFloat] = [160, 200, 240, 280, 320]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView = UITableView(frame: self.view.bounds, style: .grouped)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        self.tableView.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
        
        self.tableView.backgroundColor = UIColor(red: 110 / 255, green: 113 / 255, blue: 115 / 255, alpha: 1.0)
        self.tableView.separatorStyle = .none
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 161 / 255, green: 164 / 255, blue: 166 / 255, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 55 / 255, green: 70 / 255, blue: 77 / 255, alpha: 1.0)]
        
        self.view.backgroundColor = UIColor.clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // See https://github.com/sascha/DrawerController/issues/12
        self.navigationController?.view.setNeedsLayout()
        
        self.tableView.reloadSections(IndexSet(integersIn: NSRange(location: 0, length: self.tableView.numberOfSections - 1).toRange() ?? 0..<0), with: .none)
    }
    
    override func contentSizeDidChange(_ size: String) {
        self.tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case DrawerSection.viewSelection.rawValue:
            return 2
        case DrawerSection.drawerWidth.rawValue:
            return self.drawerWidths.count
        case DrawerSection.shadowToggle.rawValue:
            return 1
        case DrawerSection.openDrawerGestures.rawValue:
            return 3
        case DrawerSection.closeDrawerGestures.rawValue:
            return 6
        case DrawerSection.centerHiddenInteraction.rawValue:
            return 3
        case DrawerSection.stretchDrawer.rawValue:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CellIdentifier = "Cell"
        
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as UITableViewCell?
        
        if cell == nil {
            cell = SideDrawerTableViewCell(style: .default, reuseIdentifier: CellIdentifier)
            cell.selectionStyle = .blue
        }
        
        switch (indexPath as NSIndexPath).section {
        case DrawerSection.viewSelection.rawValue:
            if (indexPath as NSIndexPath).row == 0 {
                cell.textLabel?.text = "Quick View Change"
            } else {
                cell.textLabel?.text = "Full View Change"
            }
            
            cell.accessoryType = .disclosureIndicator
        case DrawerSection.drawerWidth.rawValue:
            // Implement in Subclass
            break
        case DrawerSection.shadowToggle.rawValue:
            cell.textLabel?.text = "Show Shadow"
            
            if self.evo_drawerController != nil && self.evo_drawerController!.showsShadows {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        case DrawerSection.openDrawerGestures.rawValue:
            switch (indexPath as NSIndexPath).row {
            case 0:
                cell.textLabel?.text = "Pan Nav Bar"
                
                if self.evo_drawerController != nil && self.evo_drawerController!.openDrawerGestureModeMask.contains(.PanningNavigationBar) {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
            case 1:
                cell.textLabel?.text = "Pan Center View"
                
                if self.evo_drawerController != nil && self.evo_drawerController!.openDrawerGestureModeMask.contains(.PanningCenterView) {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
            case 2:
                cell.textLabel?.text = "Bezel Pan Center View"
                
                if self.evo_drawerController != nil && self.evo_drawerController!.openDrawerGestureModeMask.contains(.BezelPanningCenterView) {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
            default:
                break
            }
        case DrawerSection.closeDrawerGestures.rawValue:
            switch (indexPath as NSIndexPath).row {
            case 0:
                cell.textLabel?.text = "Pan Nav Bar"
                
                if self.evo_drawerController != nil && self.evo_drawerController!.closeDrawerGestureModeMask.contains(.PanningNavigationBar) {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
            case 1:
                cell.textLabel?.text = "Pan Center View"
                
                if self.evo_drawerController != nil && self.evo_drawerController!.closeDrawerGestureModeMask.contains(.PanningCenterView) {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
            case 2:
                cell.textLabel?.text = "Bezel Pan Center View"
                
                if self.evo_drawerController != nil && self.evo_drawerController!.closeDrawerGestureModeMask.contains(.BezelPanningCenterView) {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
            case 3:
                cell.textLabel?.text = "Tap Nav Bar"
                
                if self.evo_drawerController != nil && self.evo_drawerController!.closeDrawerGestureModeMask.contains(.TapNavigationBar) {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
            case 4:
                cell.textLabel?.text = "Tap Center View"
                
                if self.evo_drawerController != nil && self.evo_drawerController!.closeDrawerGestureModeMask.contains(.TapCenterView) {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
            case 5:
                cell.textLabel?.text = "Pan Drawer View"
                
                if self.evo_drawerController != nil && self.evo_drawerController!.closeDrawerGestureModeMask.contains(.PanningDrawerView) {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
            default:
                break
            }
        case DrawerSection.centerHiddenInteraction.rawValue:
            cell.selectionStyle = .blue
            
            switch (indexPath as NSIndexPath).row {
            case 0:
                cell.textLabel?.text = "None"
                
                if self.evo_drawerController != nil && self.evo_drawerController!.centerHiddenInteractionMode == .none {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
            case 1:
                cell.textLabel?.text = "Full"
                
                if self.evo_drawerController != nil && self.evo_drawerController!.centerHiddenInteractionMode == .full {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
            case 2:
                cell.textLabel?.text = "Nav Bar Only"
                
                if self.evo_drawerController != nil && self.evo_drawerController!.centerHiddenInteractionMode == .navigationBarOnly {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
            default:
                break
            }
        case DrawerSection.stretchDrawer.rawValue:
            cell.textLabel?.text = "Stretch Drawer"
            
            if self.evo_drawerController != nil && self.evo_drawerController!.shouldStretchDrawer {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case DrawerSection.viewSelection.rawValue:
            return "New Center View"
        case DrawerSection.drawerWidth.rawValue:
            return "Drawer Width"
        case DrawerSection.shadowToggle.rawValue:
            return "Shadow"
        case DrawerSection.openDrawerGestures.rawValue:
            return "Drawer Open Gestures"
        case DrawerSection.closeDrawerGestures.rawValue:
            return "Drawer Close Gestures"
        case DrawerSection.centerHiddenInteraction.rawValue:
            return "Open Center Interaction Mode"
        case DrawerSection.stretchDrawer.rawValue:
            return "Stretch Drawer"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = SideDrawerSectionHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 56.0))
        headerView.autoresizingMask = [ .flexibleHeight, .flexibleWidth ]
        headerView.title = tableView.dataSource?.tableView?(tableView, titleForHeaderInSection: section)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath as NSIndexPath).section {
        case DrawerSection.viewSelection.rawValue:
            let center = ExampleCenterTableViewController()
            let nav = UINavigationController(rootViewController: center)
            
            if (indexPath as NSIndexPath).row % 2 == 0 {
                self.evo_drawerController?.setCenterViewController(nav, withCloseAnimation: true, completion: nil)
            } else {
                self.evo_drawerController?.setCenterViewController(nav, withFullCloseAnimation: true, completion: nil)
            }
        case DrawerSection.drawerWidth.rawValue:
            // Implement in Subclass
            break
        case DrawerSection.shadowToggle.rawValue:
            self.evo_drawerController?.showsShadows = !self.evo_drawerController!.showsShadows
            tableView.reloadSections(IndexSet(integer: (indexPath as NSIndexPath).section), with: .none)
        case DrawerSection.openDrawerGestures.rawValue:
            switch (indexPath as NSIndexPath).row {
            case 0:
                self.evo_drawerController?.openDrawerGestureModeMask.formSymmetricDifference(.PanningNavigationBar)
            case 1:
                self.evo_drawerController?.openDrawerGestureModeMask.formSymmetricDifference(.PanningCenterView)
            case 2:
                self.evo_drawerController?.openDrawerGestureModeMask.formSymmetricDifference(.BezelPanningCenterView)
            default:
                break
            }
            
            tableView.reloadRows(at: [indexPath], with: .none)
        case DrawerSection.closeDrawerGestures.rawValue:
            switch (indexPath as NSIndexPath).row {
            case 0:
                self.evo_drawerController?.closeDrawerGestureModeMask.formSymmetricDifference(.PanningNavigationBar)
            case 1:
                self.evo_drawerController?.closeDrawerGestureModeMask.formSymmetricDifference(.PanningCenterView)
            case 2:
                self.evo_drawerController?.closeDrawerGestureModeMask.formSymmetricDifference(.BezelPanningCenterView)
            case 3:
                self.evo_drawerController?.closeDrawerGestureModeMask.formSymmetricDifference(.TapNavigationBar)
            case 4:
                self.evo_drawerController?.closeDrawerGestureModeMask.formSymmetricDifference(.TapCenterView)
            case 5:
                self.evo_drawerController?.closeDrawerGestureModeMask.formSymmetricDifference(.PanningDrawerView)
            default:
                break
            }
            
            tableView.reloadRows(at: [indexPath], with: .none)
        case DrawerSection.centerHiddenInteraction.rawValue:
            self.evo_drawerController?.centerHiddenInteractionMode = DrawerOpenCenterInteractionMode(rawValue: (indexPath.row))!
            tableView.reloadSections(IndexSet(integer: (indexPath as NSIndexPath).section), with: .none)
        case DrawerSection.stretchDrawer.rawValue:
            self.evo_drawerController?.shouldStretchDrawer = !self.evo_drawerController!.shouldStretchDrawer
            tableView.reloadRows(at: [indexPath], with: .none)
        default:
            break
        }
        
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
