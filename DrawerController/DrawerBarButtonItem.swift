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
import Foundation

open class DrawerBarButtonItem: UIBarButtonItem {
  
  var menuButton: AnimatedMenuButton
  
  // MARK: - Initializers
  
  public override init() {
    self.menuButton = AnimatedMenuButton(frame: CGRect(x: 0, y: 0, width: 26, height: 26))
    super.init()
    self.customView = self.menuButton
  }
  
  public convenience init(target: AnyObject?, action: Selector) {
    self.init(target: target, action: action, menuIconColor: UIColor.gray)
  }
  
  public convenience init(target: AnyObject?, action: Selector, menuIconColor: UIColor) {
    self.init(target: target, action: action, menuIconColor: menuIconColor, animatable: true)
  }
  
  public convenience init(target: AnyObject?, action: Selector, menuIconColor: UIColor, animatable: Bool) {
    let menuButton = AnimatedMenuButton(frame: CGRect(x: 0, y: 0, width: 26, height: 26), strokeColor: menuIconColor)
    menuButton.animatable = animatable
    menuButton.addTarget(target, action: action, for: UIControl.Event.touchUpInside)
    self.init(customView: menuButton)
    
    self.menuButton = menuButton
  }
  
  public required init?(coder aDecoder: NSCoder) {
    self.menuButton = AnimatedMenuButton(frame: CGRect(x: 0, y: 0, width: 26, height: 26))
    super.init(coder: aDecoder)
    self.customView = self.menuButton
  }
  
  // MARK: - Animations
  
  open func animate(withFractionVisible fractionVisible: CGFloat, drawerSide: DrawerSide) {
    if let btn = self.customView as? AnimatedMenuButton {
      btn.animate(withFractionVisible: fractionVisible, drawerSide: drawerSide)
    }
  }
}
