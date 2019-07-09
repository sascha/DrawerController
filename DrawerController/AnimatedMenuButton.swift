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

import Foundation
import QuartzCore
import UIKit

open class AnimatedMenuButton : UIButton {
  
  lazy var top: CAShapeLayer = CAShapeLayer()
  lazy var middle: CAShapeLayer = CAShapeLayer()
  lazy var bottom: CAShapeLayer = CAShapeLayer()
  
  let strokeColor: UIColor
  
  // MARK: - Constants
  
  let animationDuration: CFTimeInterval = 8.0
  
  let shortStroke: CGPath = {
    let path = CGMutablePath()
    path.move(to: CGPoint(x: 3.5, y: 6))
    path.addLine(to: CGPoint(x: 22.5, y: 6))
    return path
  }()
  
  var animatable = true
  
  // MARK: - Initializers
  
  required public init?(coder aDecoder: NSCoder) {
    self.strokeColor = UIColor.gray
    super.init(coder: aDecoder)
  }
  
  override convenience init(frame: CGRect) {
    self.init(frame: frame, strokeColor: UIColor.gray)
  }
  
  init(frame: CGRect, strokeColor: UIColor) {
    self.strokeColor = strokeColor
    super.init(frame: frame)
    if !self.animatable {
      return
    }
    self.top.path = shortStroke;
    self.middle.path = shortStroke;
    self.bottom.path = shortStroke;
    
    for layer in [ self.top, self.middle, self.bottom ] {
      layer.fillColor = nil
      layer.strokeColor = self.strokeColor.cgColor
      layer.lineWidth = 1
      layer.miterLimit = 2
      layer.lineCap = CAShapeLayerLineCap.square
      layer.masksToBounds = true
      
      if let path = layer.path, let strokingPath = CGPath(__byStroking: path, transform: nil, lineWidth: 1, lineCap: .square, lineJoin: .miter, miterLimit: 4) {
        layer.bounds = strokingPath.boundingBoxOfPath
      }
      
      layer.actions = [
        "opacity": NSNull(),
        "transform": NSNull()
      ]
      
      self.layer.addSublayer(layer)
    }
    
    self.top.anchorPoint = CGPoint(x: 1, y: 0.5)
    self.top.position = CGPoint(x: 23, y: 7)
    self.middle.position = CGPoint(x: 13, y: 13)
    
    self.bottom.anchorPoint = CGPoint(x: 1, y: 0.5)
    self.bottom.position = CGPoint(x: 23, y: 19)
  }
  
  open override func draw(_ rect: CGRect) {
    if self.animatable {
      return
    }
    
    self.strokeColor.setStroke()
    
    let context = UIGraphicsGetCurrentContext()
    context?.setShouldAntialias(false)
    
    let top = UIBezierPath()
    top.move(to: CGPoint(x:3,y:6.5))
    top.addLine(to: CGPoint(x:23,y:6.5))
    top.stroke()
    
    let middle = UIBezierPath()
    middle.move(to: CGPoint(x:3,y:12.5))
    middle.addLine(to: CGPoint(x:23,y:12.5))
    middle.stroke()
    
    let bottom = UIBezierPath()
    bottom.move(to: CGPoint(x:3,y:18.5))
    bottom.addLine(to: CGPoint(x:23,y:18.5))
    bottom.stroke()
  }
  
  // MARK: - Animations
  
  open func animate(withFractionVisible fractionVisible: CGFloat, drawerSide: DrawerSide) {
    if !self.animatable {
      return
    }
    
    if drawerSide == DrawerSide.left {
      self.top.anchorPoint = CGPoint(x: 1, y: 0.5)
      self.top.position = CGPoint(x: 23, y: 7)
      self.middle.position = CGPoint(x: 13, y: 13)
      
      self.bottom.anchorPoint = CGPoint(x: 1, y: 0.5)
      self.bottom.position = CGPoint(x: 23, y: 19)
    } else if drawerSide == DrawerSide.right {
      self.top.anchorPoint = CGPoint(x: 0, y: 0.5)
      self.top.position = CGPoint(x: 3, y: 7)
      self.middle.position = CGPoint(x: 13, y: 13)
      
      self.bottom.anchorPoint = CGPoint(x: 0, y: 0.5)
      self.bottom.position = CGPoint(x: 3, y: 19)
    }
    
    let middleTransform = CABasicAnimation(keyPath: "opacity")
    middleTransform.duration = animationDuration
    
    let topTransform = CABasicAnimation(keyPath: "transform")
    topTransform.timingFunction = CAMediaTimingFunction(controlPoints: 0.5, -0.8, 0.5, 1.85)
    topTransform.duration = animationDuration
    topTransform.fillMode = CAMediaTimingFillMode.backwards
    
    let bottomTransform = topTransform.copy() as! CABasicAnimation
    
    middleTransform.toValue = 1 - fractionVisible
    
    let translation = CATransform3DMakeTranslation(-4 * fractionVisible, 0, 0)
    
    let tanOfTransformAngle = 6.0/19.0
    let transformAngle = atan(tanOfTransformAngle)
    
    let sideInverter: CGFloat = drawerSide == DrawerSide.left ? -1 : 1
    topTransform.toValue = NSValue(caTransform3D: CATransform3DRotate(translation, 1.0 * sideInverter * (CGFloat(transformAngle) * fractionVisible), 0, 0, 1))
    bottomTransform.toValue = NSValue(caTransform3D: CATransform3DRotate(translation, (-1.0 * sideInverter * CGFloat(transformAngle) * fractionVisible), 0, 0, 1))
    
    topTransform.beginTime = CACurrentMediaTime()
    bottomTransform.beginTime = CACurrentMediaTime()
    
    self.top.add(topTransform, forKey: topTransform.keyPath)
    self.middle.add(middleTransform, forKey: middleTransform.keyPath)
    self.bottom.add(bottomTransform, forKey: bottomTransform.keyPath)
    
    self.top.setValue(topTransform.toValue, forKey: topTransform.keyPath!)
    self.middle.setValue(middleTransform.toValue, forKey: middleTransform.keyPath!)
    self.bottom.setValue(bottomTransform.toValue, forKey: bottomTransform.keyPath!)
  }
}
