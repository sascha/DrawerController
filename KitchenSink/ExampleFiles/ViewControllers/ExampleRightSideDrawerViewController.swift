//
//  ExampleRightSideDrawerViewController.swift
//  DrawerControllerKitchenSink
//
//  Created by Sascha Schwabbauer on 14.09.14.
//  Copyright (c) 2014 evolved.io. All rights reserved.
//

import UIKit

class ExampleRightSideDrawerViewController: ExampleSideDrawerViewController {
    override init() {
        super.init()
        self.restorationIdentifier = "ExampleRightSideDrawerController"
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.restorationIdentifier = "ExampleRightSideDrawerController"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        println("Right will appear")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        println("Right did appear")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        println("Right will disappear")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        println("Right did disappear")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Right Drawer"
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == DrawerSection.DrawerWidth.toRaw() {
            return "Right Drawer Width"
        } else {
            return super.tableView(tableView, titleForHeaderInSection: section)
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        
        if indexPath.section == DrawerSection.DrawerWidth.toRaw() {
            let width = self.drawerWidths[indexPath.row]
            let drawerWidth = self.evo_drawerController?.maximumRightDrawerWidth
            
            if drawerWidth == width {
                cell.accessoryType = .Checkmark
            } else {
                cell.accessoryType = .None
            }
            
            cell.textLabel?.text = "Width \(self.drawerWidths[indexPath.row])"
        } else if indexPath.section == DrawerSection.AlwaysShowDrawerInRegularHorizontalSizeClass.toRaw() {
            cell.textLabel?.text = "Always Show Right Drawer"
            
            if self.evo_drawerController != nil && self.evo_drawerController!.shouldAlwaysShowRightDrawerInRegularHorizontalSizeClass {
                cell.accessoryType = .Checkmark
            } else {
                cell.accessoryType = .None
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == DrawerSection.DrawerWidth.toRaw() {
            self.evo_drawerController?.setMaximumRightDrawerWidth(self.drawerWidths[indexPath.row], animated: true, completion: { (finished) -> Void in
                tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .None)
                tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            })
        } else if indexPath.section == DrawerSection.AlwaysShowDrawerInRegularHorizontalSizeClass.toRaw() {
            self.evo_drawerController?.shouldAlwaysShowRightDrawerInRegularHorizontalSizeClass = !self.evo_drawerController!.shouldAlwaysShowRightDrawerInRegularHorizontalSizeClass
            tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .None)
        } else {
            super.tableView(tableView, didSelectRowAtIndexPath: indexPath)
        }
    }
}
