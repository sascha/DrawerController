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

private class DisclosureIndicator: UIView {
    var color: UIColor = UIColor.whiteColor()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clearColor()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor.clearColor()
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        let chevronColor = self.color
        let frame = self.bounds
        
        let chevronPath = UIBezierPath()
        chevronPath.moveToPoint(CGPoint(x: CGRectGetMinX(frame) + 0.22000 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 0.01667 * CGRectGetHeight(frame)))
        chevronPath.addLineToPoint(CGPoint(x: CGRectGetMinX(frame) + 0.98000 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 0.48333 * CGRectGetHeight(frame)))
        chevronPath.addLineToPoint(CGPoint(x: CGRectGetMinX(frame) + 0.22000 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 0.98333 * CGRectGetHeight(frame)))
        chevronPath.addLineToPoint(CGPoint(x: CGRectGetMinX(frame) + 0.02000 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 0.81667 * CGRectGetHeight(frame)))
        chevronPath.addLineToPoint(CGPoint(x: CGRectGetMinX(frame) + 0.54000 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 0.48333 * CGRectGetHeight(frame)))
        chevronPath.addLineToPoint(CGPoint(x: CGRectGetMinX(frame) + 0.02000 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 0.15000 * CGRectGetHeight(frame)))
        chevronPath.addLineToPoint(CGPoint(x: CGRectGetMinX(frame) + 0.22000 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 0.01667 * CGRectGetHeight(frame)))
        chevronPath.closePath()
        
        CGContextSaveGState(context)
        chevronColor.setFill()
        chevronPath.fill()
        CGContextRestoreGState(context)
    }
}

private class CustomCheckmark: UIControl {
    var color: UIColor?
    // TODO: Find out how to solve this in Swift
//    override var selected: Bool {
//        didSet {
//            self.setNeedsDisplay()
//        }
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clearColor()
        self.userInteractionEnabled = false
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor.clearColor()
        self.userInteractionEnabled = false
    }
    
    override func drawRect(rect: CGRect) {
        let checkMarkColor = self.color
        
        let frame = self.bounds
        
        let checkMarkPath = UIBezierPath()
        checkMarkPath.moveToPoint(CGPoint(x: CGRectGetMinX(frame) + 0.07087 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 0.48855 * CGRectGetHeight(frame)))
        checkMarkPath.addLineToPoint(CGPoint(x: CGRectGetMinX(frame) + 0.12500 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 0.45284 * CGRectGetHeight(frame)))
        checkMarkPath.addCurveToPoint(CGPoint(x: CGRectGetMinX(frame) + 0.21038 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 0.47898 * CGRectGetHeight(frame)), controlPoint1: CGPoint(x: CGRectGetMinX(frame) + 0.15489 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 0.43312 * CGRectGetHeight(frame)), controlPoint2: CGPoint(x: CGRectGetMinX(frame) + 0.19312 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 0.44482 * CGRectGetHeight(frame)))
        checkMarkPath.addLineToPoint(CGPoint(x: CGRectGetMinX(frame) + 0.51450 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 0.79528 * CGRectGetHeight(frame)))
        checkMarkPath.addCurveToPoint(CGPoint(x: CGRectGetMinX(frame) + 0.49163 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 0.89286 * CGRectGetHeight(frame)), controlPoint1: CGPoint(x: CGRectGetMinX(frame) + 0.53176 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 0.82945 * CGRectGetHeight(frame)), controlPoint2: CGPoint(x: CGRectGetMinX(frame) + 0.52152 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 0.87313 * CGRectGetHeight(frame)))
        checkMarkPath.addLineToPoint(CGPoint(x: CGRectGetMinX(frame) + 0.38337 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 0.96429 * CGRectGetHeight(frame)))
        checkMarkPath.addCurveToPoint(CGPoint(x: CGRectGetMinX(frame) + 0.29800 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 0.93814 * CGRectGetHeight(frame)), controlPoint1: CGPoint(x: CGRectGetMinX(frame) + 0.35348 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 0.98401 * CGRectGetHeight(frame)), controlPoint2: CGPoint(x: CGRectGetMinX(frame) + 0.31526 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 0.97230 * CGRectGetHeight(frame)))
        checkMarkPath.addLineToPoint(CGPoint(x: CGRectGetMinX(frame) + 0.04800 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 0.58613 * CGRectGetHeight(frame)))
        checkMarkPath.addCurveToPoint(CGPoint(x: CGRectGetMinX(frame) + 0.07087 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 0.48855 * CGRectGetHeight(frame)), controlPoint1: CGPoint(x: CGRectGetMinX(frame) + 0.03074 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 0.55196 * CGRectGetHeight(frame)), controlPoint2: CGPoint(x: CGRectGetMinX(frame) + 0.04098 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 0.50828 * CGRectGetHeight(frame)))
        checkMarkPath.closePath()
        checkMarkPath.moveToPoint(CGPoint(x: CGRectGetMinX(frame) + 0.92048 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 0.00641 * CGRectGetHeight(frame)))
        checkMarkPath.addLineToPoint(CGPoint(x: CGRectGetMinX(frame) + 0.93750 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 0.02427 * CGRectGetHeight(frame)))
        checkMarkPath.addCurveToPoint(CGPoint(x: CGRectGetMinX(frame) + 0.96038 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 0.12184 * CGRectGetHeight(frame)), controlPoint1: CGPoint(x: CGRectGetMinX(frame) + 0.96739 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 0.04399 * CGRectGetHeight(frame)), controlPoint2: CGPoint(x: CGRectGetMinX(frame) + 0.97764 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 0.08768 * CGRectGetHeight(frame)))
        checkMarkPath.addLineToPoint(CGPoint(x: CGRectGetMinX(frame) + 0.51450 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 0.93814 * CGRectGetHeight(frame)))
        checkMarkPath.addCurveToPoint(CGPoint(x: CGRectGetMinX(frame) + 0.42913 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 0.96429 * CGRectGetHeight(frame)), controlPoint1: CGPoint(x: CGRectGetMinX(frame) + 0.49724 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 0.97230 * CGRectGetHeight(frame)), controlPoint2: CGPoint(x: CGRectGetMinX(frame) + 0.45902 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 0.98401 * CGRectGetHeight(frame)))
        checkMarkPath.addLineToPoint(CGPoint(x: CGRectGetMinX(frame) + 0.32087 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 0.89286 * CGRectGetHeight(frame)))
        checkMarkPath.addCurveToPoint(CGPoint(x: CGRectGetMinX(frame) + 0.29800 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 0.79528 * CGRectGetHeight(frame)), controlPoint1: CGPoint(x: CGRectGetMinX(frame) + 0.29098 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 0.87313 * CGRectGetHeight(frame)), controlPoint2: CGPoint(x: CGRectGetMinX(frame) + 0.28074 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 0.82945 * CGRectGetHeight(frame)))
        checkMarkPath.addLineToPoint(CGPoint(x: CGRectGetMinX(frame) + 0.83511 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 0.03255 * CGRectGetHeight(frame)))
        checkMarkPath.addCurveToPoint(CGPoint(x: CGRectGetMinX(frame) + 0.92048 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 0.00641 * CGRectGetHeight(frame)), controlPoint1: CGPoint(x: CGRectGetMinX(frame) + 0.85237 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + -0.00161 * CGRectGetHeight(frame)), controlPoint2: CGPoint(x: CGRectGetMinX(frame) + 0.89059 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + -0.01331 * CGRectGetHeight(frame)))
        checkMarkPath.closePath()
        checkMarkPath.moveToPoint(CGPoint(x: CGRectGetMinX(frame) + 0.37500 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 0.78572 * CGRectGetHeight(frame)))
        checkMarkPath.addLineToPoint(CGPoint(x: CGRectGetMinX(frame) + 0.43750 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 0.78572 * CGRectGetHeight(frame)))
        checkMarkPath.addCurveToPoint(CGPoint(x: CGRectGetMinX(frame) + 0.50000 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 0.85714 * CGRectGetHeight(frame)), controlPoint1: CGPoint(x: CGRectGetMinX(frame) + 0.47202 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 0.78572 * CGRectGetHeight(frame)), controlPoint2: CGPoint(x: CGRectGetMinX(frame) + 0.50000 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 0.81769 * CGRectGetHeight(frame)))
        checkMarkPath.addLineToPoint(CGPoint(x: CGRectGetMinX(frame) + 0.50000 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 0.92857 * CGRectGetHeight(frame)))
        checkMarkPath.addCurveToPoint(CGPoint(x: CGRectGetMinX(frame) + 0.43750 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 1.00000 * CGRectGetHeight(frame)), controlPoint1: CGPoint(x: CGRectGetMinX(frame) + 0.50000 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 0.96802 * CGRectGetHeight(frame)), controlPoint2: CGPoint(x: CGRectGetMinX(frame) + 0.47202 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 1.00000 * CGRectGetHeight(frame)))
        checkMarkPath.addLineToPoint(CGPoint(x: CGRectGetMinX(frame) + 0.37500 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 1.00000 * CGRectGetHeight(frame)))
        checkMarkPath.addCurveToPoint(CGPoint(x: CGRectGetMinX(frame) + 0.31250 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 0.92857 * CGRectGetHeight(frame)), controlPoint1: CGPoint(x: CGRectGetMinX(frame) + 0.34048 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 1.00000 * CGRectGetHeight(frame)), controlPoint2: CGPoint(x: CGRectGetMinX(frame) + 0.31250 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 0.96802 * CGRectGetHeight(frame)))
        checkMarkPath.addLineToPoint(CGPoint(x: CGRectGetMinX(frame) + 0.31250 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 0.85714 * CGRectGetHeight(frame)))
        checkMarkPath.addCurveToPoint(CGPoint(x: CGRectGetMinX(frame) + 0.37500 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 0.78572 * CGRectGetHeight(frame)), controlPoint1: CGPoint(x: CGRectGetMinX(frame) + 0.31250 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 0.81769 * CGRectGetHeight(frame)), controlPoint2: CGPoint(x: CGRectGetMinX(frame) + 0.34048 * CGRectGetWidth(frame), y: CGRectGetMinY(frame) + 0.78572 * CGRectGetHeight(frame)))
        checkMarkPath.closePath()
        checkMarkColor?.setFill()
        checkMarkPath.fill()
    }
}

class TableViewCell: UITableViewCell {
    var accessoryCheckmarkColor: UIColor = UIColor.whiteColor()
    var disclosureIndicatorColor: UIColor = UIColor.whiteColor()
    override var accessoryType: UITableViewCellAccessoryType {
        didSet {
            if self.accessoryType == .Checkmark {
                let customCheckmark = CustomCheckmark(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
                customCheckmark.color = self.accessoryCheckmarkColor
                self.accessoryView = customCheckmark
            } else if self.accessoryType == .DisclosureIndicator {
                let di = DisclosureIndicator(frame: CGRect(x: 0, y: 0, width: 10, height: 14))
                di.color = self.disclosureIndicatorColor
                self.accessoryView = di
            } else {
                self.accessoryView = nil
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.updateContentForNewContentSize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.updateContentForNewContentSize()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.updateContentForNewContentSize()
    }
    
    func updateContentForNewContentSize() {
        
    }
}
