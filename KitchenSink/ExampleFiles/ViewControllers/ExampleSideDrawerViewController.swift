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
    case ViewSelection
    case DrawerWidth
    case ShadowToggle
    case OpenDrawerGestures
    case CloseDrawerGestures
    case CenterHiddenInteraction
    case StretchDrawer
}

class ExampleSideDrawerViewController: ExampleViewController, UITableViewDataSource, UITableViewDelegate {
    var tableView: UITableView!
    let drawerWidths: [CGFloat] = [160, 200, 240, 280, 320]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView = UITableView(frame: self.view.bounds, style: .Grouped)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        self.tableView.autoresizingMask = [ .FlexibleWidth, .FlexibleHeight ]
        
        self.tableView.backgroundColor = UIColor(red: 110 / 255, green: 113 / 255, blue: 115 / 255, alpha: 1.0)
        self.tableView.separatorStyle = .None
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 161 / 255, green: 164 / 255, blue: 166 / 255, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 55 / 255, green: 70 / 255, blue: 77 / 255, alpha: 1.0)]
        
        self.view.backgroundColor = UIColor.clearColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // See https://github.com/sascha/DrawerController/issues/12
        self.navigationController?.view.setNeedsLayout()
        
        self.tableView.reloadSections(NSIndexSet(indexesInRange: NSRange(location: 0, length: self.tableView.numberOfSections - 1)), withRowAnimation: .None)
    }
    
    override func contentSizeDidChange(size: String) {
        self.tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case DrawerSection.ViewSelection.rawValue:
            return 2
        case DrawerSection.DrawerWidth.rawValue:
            return self.drawerWidths.count
        case DrawerSection.ShadowToggle.rawValue:
            return 1
        case DrawerSection.OpenDrawerGestures.rawValue:
            return 3
        case DrawerSection.CloseDrawerGestures.rawValue:
            return 6
        case DrawerSection.CenterHiddenInteraction.rawValue:
            return 3
        case DrawerSection.StretchDrawer.rawValue:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let CellIdentifier = "Cell"
        
        var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as UITableViewCell?
        
        if cell == nil {
            cell = SideDrawerTableViewCell(style: .Default, reuseIdentifier: CellIdentifier)
            cell.selectionStyle = .Blue
        }
        
        switch indexPath.section {
        case DrawerSection.ViewSelection.rawValue:
            if indexPath.row == 0 {
                cell.textLabel?.text = "Quick View Change"
            } else {
                cell.textLabel?.text = "Full View Change"
            }
            
            cell.accessoryType = .DisclosureIndicator
        case DrawerSection.DrawerWidth.rawValue:
            // Implement in Subclass
            break
        case DrawerSection.ShadowToggle.rawValue:
            cell.textLabel?.text = "Show Shadow"
            
            if self.evo_drawerController != nil && self.evo_drawerController!.showsShadows {
                cell.accessoryType = .Checkmark
            } else {
                cell.accessoryType = .None
            }
        case DrawerSection.OpenDrawerGestures.rawValue:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Pan Nav Bar"
                
                if self.evo_drawerController != nil && self.evo_drawerController!.openDrawerGestureModeMask.contains(.PanningNavigationBar) {
                    cell.accessoryType = .Checkmark
                } else {
                    cell.accessoryType = .None
                }
            case 1:
                cell.textLabel?.text = "Pan Center View"
                
                if self.evo_drawerController != nil && self.evo_drawerController!.openDrawerGestureModeMask.contains(.PanningCenterView) {
                    cell.accessoryType = .Checkmark
                } else {
                    cell.accessoryType = .None
                }
            case 2:
                cell.textLabel?.text = "Bezel Pan Center View"
                
                if self.evo_drawerController != nil && self.evo_drawerController!.openDrawerGestureModeMask.contains(.BezelPanningCenterView) {
                    cell.accessoryType = .Checkmark
                } else {
                    cell.accessoryType = .None
                }
            default:
                break
            }
        case DrawerSection.CloseDrawerGestures.rawValue:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Pan Nav Bar"
                
                if self.evo_drawerController != nil && self.evo_drawerController!.closeDrawerGestureModeMask.contains(.PanningNavigationBar) {
                    cell.accessoryType = .Checkmark
                } else {
                    cell.accessoryType = .None
                }
            case 1:
                cell.textLabel?.text = "Pan Center View"
                
                if self.evo_drawerController != nil && self.evo_drawerController!.closeDrawerGestureModeMask.contains(.PanningCenterView) {
                    cell.accessoryType = .Checkmark
                } else {
                    cell.accessoryType = .None
                }
            case 2:
                cell.textLabel?.text = "Bezel Pan Center View"
                
                if self.evo_drawerController != nil && self.evo_drawerController!.closeDrawerGestureModeMask.contains(.BezelPanningCenterView) {
                    cell.accessoryType = .Checkmark
                } else {
                    cell.accessoryType = .None
                }
            case 3:
                cell.textLabel?.text = "Tap Nav Bar"
                
                if self.evo_drawerController != nil && self.evo_drawerController!.closeDrawerGestureModeMask.contains(.TapNavigationBar) {
                    cell.accessoryType = .Checkmark
                } else {
                    cell.accessoryType = .None
                }
            case 4:
                cell.textLabel?.text = "Tap Center View"
                
                if self.evo_drawerController != nil && self.evo_drawerController!.closeDrawerGestureModeMask.contains(.TapCenterView) {
                    cell.accessoryType = .Checkmark
                } else {
                    cell.accessoryType = .None
                }
            case 5:
                cell.textLabel?.text = "Pan Drawer View"
                
                if self.evo_drawerController != nil && self.evo_drawerController!.closeDrawerGestureModeMask.contains(.PanningDrawerView) {
                    cell.accessoryType = .Checkmark
                } else {
                    cell.accessoryType = .None
                }
            default:
                break
            }
        case DrawerSection.CenterHiddenInteraction.rawValue:
            cell.selectionStyle = .Blue
            
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "None"
                
                if self.evo_drawerController != nil && self.evo_drawerController!.centerHiddenInteractionMode == .None {
                    cell.accessoryType = .Checkmark
                } else {
                    cell.accessoryType = .None
                }
            case 1:
                cell.textLabel?.text = "Full"
                
                if self.evo_drawerController != nil && self.evo_drawerController!.centerHiddenInteractionMode == .Full {
                    cell.accessoryType = .Checkmark
                } else {
                    cell.accessoryType = .None
                }
            case 2:
                cell.textLabel?.text = "Nav Bar Only"
                
                if self.evo_drawerController != nil && self.evo_drawerController!.centerHiddenInteractionMode == .NavigationBarOnly {
                    cell.accessoryType = .Checkmark
                } else {
                    cell.accessoryType = .None
                }
            default:
                break
            }
        case DrawerSection.StretchDrawer.rawValue:
            cell.textLabel?.text = "Stretch Drawer"
            
            if self.evo_drawerController != nil && self.evo_drawerController!.shouldStretchDrawer {
                cell.accessoryType = .Checkmark
            } else {
                cell.accessoryType = .None
            }
        default:
            break
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case DrawerSection.ViewSelection.rawValue:
            return "New Center View"
        case DrawerSection.DrawerWidth.rawValue:
            return "Drawer Width"
        case DrawerSection.ShadowToggle.rawValue:
            return "Shadow"
        case DrawerSection.OpenDrawerGestures.rawValue:
            return "Drawer Open Gestures"
        case DrawerSection.CloseDrawerGestures.rawValue:
            return "Drawer Close Gestures"
        case DrawerSection.CenterHiddenInteraction.rawValue:
            return "Open Center Interaction Mode"
        case DrawerSection.StretchDrawer.rawValue:
            return "Stretch Drawer"
        default:
            return nil
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = SideDrawerSectionHeaderView(frame: CGRect(x: 0, y: 0, width: CGRectGetWidth(tableView.bounds), height: 56.0))
        headerView.autoresizingMask = [ .FlexibleHeight, .FlexibleWidth ]
        headerView.title = tableView.dataSource?.tableView?(tableView, titleForHeaderInSection: section)
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 56
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case DrawerSection.ViewSelection.rawValue:
            let center = ExampleCenterTableViewController()
            let nav = UINavigationController(rootViewController: center)
            
            if indexPath.row % 2 == 0 {
                self.evo_drawerController?.setCenterViewController(nav, withCloseAnimation: true, completion: nil)
            } else {
                self.evo_drawerController?.setCenterViewController(nav, withFullCloseAnimation: true, completion: nil)
            }
        case DrawerSection.DrawerWidth.rawValue:
            // Implement in Subclass
            break
        case DrawerSection.ShadowToggle.rawValue:
            self.evo_drawerController?.showsShadows = !self.evo_drawerController!.showsShadows
            tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .None)
        case DrawerSection.OpenDrawerGestures.rawValue:
            switch indexPath.row {
            case 0:
                self.evo_drawerController?.openDrawerGestureModeMask.exclusiveOrInPlace(.PanningNavigationBar)
            case 1:
                self.evo_drawerController?.openDrawerGestureModeMask.exclusiveOrInPlace(.PanningCenterView)
            case 2:
                self.evo_drawerController?.openDrawerGestureModeMask.exclusiveOrInPlace(.BezelPanningCenterView)
            default:
                break
            }
            
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        case DrawerSection.CloseDrawerGestures.rawValue:
            switch indexPath.row {
            case 0:
                self.evo_drawerController?.closeDrawerGestureModeMask.exclusiveOrInPlace(.PanningNavigationBar)
            case 1:
                self.evo_drawerController?.closeDrawerGestureModeMask.exclusiveOrInPlace(.PanningCenterView)
            case 2:
                self.evo_drawerController?.closeDrawerGestureModeMask.exclusiveOrInPlace(.BezelPanningCenterView)
            case 3:
                self.evo_drawerController?.closeDrawerGestureModeMask.exclusiveOrInPlace(.TapNavigationBar)
            case 4:
                self.evo_drawerController?.closeDrawerGestureModeMask.exclusiveOrInPlace(.TapCenterView)
            case 5:
                self.evo_drawerController?.closeDrawerGestureModeMask.exclusiveOrInPlace(.PanningDrawerView)
            default:
                break
            }
            
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        case DrawerSection.CenterHiddenInteraction.rawValue:
            self.evo_drawerController?.centerHiddenInteractionMode = DrawerOpenCenterInteractionMode(rawValue: (indexPath.row))!
            tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .None)
        case DrawerSection.StretchDrawer.rawValue:
            self.evo_drawerController?.shouldStretchDrawer = !self.evo_drawerController!.shouldStretchDrawer
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        default:
            break
        }
        
        tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
