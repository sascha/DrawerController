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
import DrawerController

enum CenterViewControllerSection: Int {
    case leftViewState
    case leftDrawerAnimation
    case rightViewState
    case rightDrawerAnimation
}

class ExampleCenterTableViewController: ExampleViewController, UITableViewDataSource, UITableViewDelegate {
    var tableView: UITableView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.restorationIdentifier = "ExampleCenterControllerRestorationKey"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.restorationIdentifier = "ExampleCenterControllerRestorationKey"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView = UITableView(frame: self.view.bounds, style: .grouped)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        self.tableView.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(doubleTap)
        
        let twoFingerDoubleTap = UITapGestureRecognizer(target: self, action: #selector(twoFingerDoubleTap(_:)))
        twoFingerDoubleTap.numberOfTapsRequired = 2
        twoFingerDoubleTap.numberOfTouchesRequired = 2
        self.view.addGestureRecognizer(twoFingerDoubleTap)
        
        self.setupLeftMenuButton()
        self.setupRightMenuButton()
        
        let barColor = UIColor(red: 247/255, green: 249/255, blue: 250/255, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor = barColor
        
        self.navigationController?.view.layer.cornerRadius = 10.0
        
        let backView = UIView()
        backView.backgroundColor = UIColor(red: 208/255, green: 208/255, blue: 208/255, alpha: 1.0)
        self.tableView.backgroundView = backView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Center will appear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Center did appear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("Center will disappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("Center did disappear")
    }
    
    func setupLeftMenuButton() {
        let leftDrawerButton = DrawerBarButtonItem(target: self, action: #selector(leftDrawerButtonPress(_:)))
        self.navigationItem.setLeftBarButton(leftDrawerButton, animated: true)
    }
    
    func setupRightMenuButton() {
        let rightDrawerButton = DrawerBarButtonItem(target: self, action: #selector(rightDrawerButtonPress(_:)))
        self.navigationItem.setRightBarButton(rightDrawerButton, animated: true)
    }
    
    override func contentSizeDidChange(_ size: String) {
        self.tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case CenterViewControllerSection.leftDrawerAnimation.rawValue, CenterViewControllerSection.rightDrawerAnimation.rawValue:
            return 6
        case CenterViewControllerSection.leftViewState.rawValue, CenterViewControllerSection.rightViewState.rawValue:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CellIdentifier = "Cell"
        
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as UITableViewCell?
        
        if cell == nil {
            cell = CenterTableViewCell(style: .default, reuseIdentifier: CellIdentifier)
            cell.selectionStyle = .gray
        }
        
        let selectedColor = UIColor(red: 1 / 255, green: 15 / 255, blue: 25 / 255, alpha: 1.0)
        let unselectedColor = UIColor(red: 79 / 255, green: 93 / 255, blue: 102 / 255, alpha: 1.0)
        
        switch (indexPath as NSIndexPath).section {
        case CenterViewControllerSection.leftDrawerAnimation.rawValue, CenterViewControllerSection.rightDrawerAnimation.rawValue:
            var animationTypeForSection: DrawerAnimationType
            
            if (indexPath as NSIndexPath).section == CenterViewControllerSection.leftDrawerAnimation.rawValue {
                animationTypeForSection = ExampleDrawerVisualStateManager.sharedManager.leftDrawerAnimationType
            } else {
                animationTypeForSection = ExampleDrawerVisualStateManager.sharedManager.rightDrawerAnimationType
            }
            
            if animationTypeForSection.rawValue == (indexPath as NSIndexPath).row {
                cell.accessoryType = .checkmark
                cell.textLabel?.textColor = selectedColor
            } else {
                cell.accessoryType = .none
                cell.textLabel?.textColor = unselectedColor
            }
            
            switch (indexPath as NSIndexPath).row {
            case DrawerAnimationType.none.rawValue:
                cell.textLabel?.text = "None"
            case DrawerAnimationType.slide.rawValue:
                cell.textLabel?.text = "Slide"
            case DrawerAnimationType.slideAndScale.rawValue:
                cell.textLabel?.text = "Slide and Scale"
            case DrawerAnimationType.swingingDoor.rawValue:
                cell.textLabel?.text = "Swinging Door"
            case DrawerAnimationType.parallax.rawValue:
                cell.textLabel?.text = "Parallax"
            case DrawerAnimationType.animatedBarButton.rawValue:
                cell.textLabel?.text = "Animated Menu Button"
            default:
                break
            }
        case CenterViewControllerSection.leftViewState.rawValue:
            cell.textLabel?.text = "Enabled"
            
            if self.evo_drawerController?.leftDrawerViewController != nil {
                cell.accessoryType = .checkmark
                cell.textLabel?.textColor = selectedColor
            } else {
                cell.accessoryType = .none
                cell.textLabel?.textColor = unselectedColor
            }
        case CenterViewControllerSection.rightViewState.rawValue:
            cell.textLabel?.text = "Enabled"
            
            if self.evo_drawerController?.rightDrawerViewController != nil {
                cell.accessoryType = .checkmark
                cell.textLabel?.textColor = selectedColor
            } else {
                cell.accessoryType = .none
                cell.textLabel?.textColor = unselectedColor
            }
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case CenterViewControllerSection.leftDrawerAnimation.rawValue:
            return "Left Drawer Animation";
        case CenterViewControllerSection.rightDrawerAnimation.rawValue:
            return "Right Drawer Animation";
        case CenterViewControllerSection.leftViewState.rawValue:
            return "Left Drawer";
        case CenterViewControllerSection.rightViewState.rawValue:
            return "Right Drawer";
        default:
            return nil
        }
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath as NSIndexPath).section {
        case CenterViewControllerSection.leftDrawerAnimation.rawValue, CenterViewControllerSection.rightDrawerAnimation.rawValue:
            if (indexPath as NSIndexPath).section == CenterViewControllerSection.leftDrawerAnimation.rawValue {
                ExampleDrawerVisualStateManager.sharedManager.leftDrawerAnimationType = DrawerAnimationType(rawValue: (indexPath as NSIndexPath).row)!
            } else {
                ExampleDrawerVisualStateManager.sharedManager.rightDrawerAnimationType = DrawerAnimationType(rawValue: (indexPath as NSIndexPath).row)!
            }
            
            tableView.reloadSections(IndexSet(integer: (indexPath as NSIndexPath).section), with: .none)
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            tableView.deselectRow(at: indexPath, animated: true)
        case CenterViewControllerSection.leftViewState.rawValue, CenterViewControllerSection.rightViewState.rawValue:
            var sideDrawerViewController: UIViewController?
            var drawerSide = DrawerSide.none
            
            if (indexPath as NSIndexPath).section == CenterViewControllerSection.leftViewState.rawValue {
                sideDrawerViewController = self.evo_drawerController?.leftDrawerViewController
                drawerSide = .left
            } else if (indexPath as NSIndexPath).section == CenterViewControllerSection.rightViewState.rawValue {
                sideDrawerViewController = self.evo_drawerController?.rightDrawerViewController
                drawerSide = .right
            }
            
            if sideDrawerViewController != nil {
                self.evo_drawerController?.closeDrawer(animated: true, completion: { (finished) -> Void in
                    if drawerSide == DrawerSide.left {
                        self.evo_drawerController?.leftDrawerViewController = nil
                        self.navigationItem.setLeftBarButtonItems(nil, animated: true)
                    } else if drawerSide == .right {
                        self.evo_drawerController?.rightDrawerViewController = nil
                        self.navigationItem.setRightBarButtonItems(nil, animated: true)
                    }
                    
                    tableView.reloadRows(at: [indexPath], with: .none)
                    tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                    tableView.deselectRow(at: indexPath, animated: true)
                })
            } else {
                if drawerSide == .left {
                    let vc = ExampleLeftSideDrawerViewController()
                    let navC = UINavigationController(rootViewController: vc)
                    self.evo_drawerController?.leftDrawerViewController = navC
                    self.setupLeftMenuButton()
                } else if drawerSide == .right {
                    let vc = ExampleRightSideDrawerViewController()
                    let navC = UINavigationController(rootViewController: vc)
                    self.evo_drawerController?.rightDrawerViewController = navC
                    self.setupRightMenuButton()
                }
                
                tableView.reloadRows(at: [indexPath], with: .none)
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                tableView.deselectRow(at: indexPath, animated: true)
            }
        default:
            break
        }
    }
    
    // MARK: - Button Handlers
    
    func leftDrawerButtonPress(_ sender: AnyObject?) {
        self.evo_drawerController?.toggleDrawerSide(.left, animated: true, completion: nil)
    }
    
    func rightDrawerButtonPress(_ sender: AnyObject?) {
        self.evo_drawerController?.toggleDrawerSide(.right, animated: true, completion: nil)
    }
    
    func doubleTap(_ gesture: UITapGestureRecognizer) {
        self.evo_drawerController?.bouncePreview(for: .left, completion: nil)
    }
    
    func twoFingerDoubleTap(_ gesture: UITapGestureRecognizer) {
        self.evo_drawerController?.bouncePreview(for: .right, completion: nil)
    }
}
