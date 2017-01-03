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

private class DisclosureIndicator: UIView {
    var color: UIColor = UIColor.white
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor.clear
    }
    
    override func draw(_ rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext() {
            let chevronColor = self.color
            let frame = self.bounds

            let chevronPath = UIBezierPath()
            chevronPath.move(to: CGPoint(x: frame.minX + 0.22000 * frame.width, y: frame.minY + 0.01667 * frame.height))
            chevronPath.addLine(to: CGPoint(x: frame.minX + 0.98000 * frame.width, y: frame.minY + 0.48333 * frame.height))
            chevronPath.addLine(to: CGPoint(x: frame.minX + 0.22000 * frame.width, y: frame.minY + 0.98333 * frame.height))
            chevronPath.addLine(to: CGPoint(x: frame.minX + 0.02000 * frame.width, y: frame.minY + 0.81667 * frame.height))
            chevronPath.addLine(to: CGPoint(x: frame.minX + 0.54000 * frame.width, y: frame.minY + 0.48333 * frame.height))
            chevronPath.addLine(to: CGPoint(x: frame.minX + 0.02000 * frame.width, y: frame.minY + 0.15000 * frame.height))
            chevronPath.addLine(to: CGPoint(x: frame.minX + 0.22000 * frame.width, y: frame.minY + 0.01667 * frame.height))
            chevronPath.close()

            context.saveGState()
            chevronColor.setFill()
            chevronPath.fill()
            context.restoreGState()
        }
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
        
        self.backgroundColor = UIColor.clear
        self.isUserInteractionEnabled = false
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor.clear
        self.isUserInteractionEnabled = false
    }
    
    override func draw(_ rect: CGRect) {
        let checkMarkColor = self.color
        
        let frame = self.bounds
        
        let checkMarkPath = UIBezierPath()
        checkMarkPath.move(to: CGPoint(x: frame.minX + 0.07087 * frame.width, y: frame.minY + 0.48855 * frame.height))
        checkMarkPath.addLine(to: CGPoint(x: frame.minX + 0.12500 * frame.width, y: frame.minY + 0.45284 * frame.height))
        checkMarkPath.addCurve(to: CGPoint(x: frame.minX + 0.21038 * frame.width, y: frame.minY + 0.47898 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.15489 * frame.width, y: frame.minY + 0.43312 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.19312 * frame.width, y: frame.minY + 0.44482 * frame.height))
        checkMarkPath.addLine(to: CGPoint(x: frame.minX + 0.51450 * frame.width, y: frame.minY + 0.79528 * frame.height))
        checkMarkPath.addCurve(to: CGPoint(x: frame.minX + 0.49163 * frame.width, y: frame.minY + 0.89286 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.53176 * frame.width, y: frame.minY + 0.82945 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.52152 * frame.width, y: frame.minY + 0.87313 * frame.height))
        checkMarkPath.addLine(to: CGPoint(x: frame.minX + 0.38337 * frame.width, y: frame.minY + 0.96429 * frame.height))
        checkMarkPath.addCurve(to: CGPoint(x: frame.minX + 0.29800 * frame.width, y: frame.minY + 0.93814 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.35348 * frame.width, y: frame.minY + 0.98401 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.31526 * frame.width, y: frame.minY + 0.97230 * frame.height))
        checkMarkPath.addLine(to: CGPoint(x: frame.minX + 0.04800 * frame.width, y: frame.minY + 0.58613 * frame.height))
        checkMarkPath.addCurve(to: CGPoint(x: frame.minX + 0.07087 * frame.width, y: frame.minY + 0.48855 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.03074 * frame.width, y: frame.minY + 0.55196 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.04098 * frame.width, y: frame.minY + 0.50828 * frame.height))
        checkMarkPath.close()
        checkMarkPath.move(to: CGPoint(x: frame.minX + 0.92048 * frame.width, y: frame.minY + 0.00641 * frame.height))
        checkMarkPath.addLine(to: CGPoint(x: frame.minX + 0.93750 * frame.width, y: frame.minY + 0.02427 * frame.height))
        checkMarkPath.addCurve(to: CGPoint(x: frame.minX + 0.96038 * frame.width, y: frame.minY + 0.12184 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.96739 * frame.width, y: frame.minY + 0.04399 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.97764 * frame.width, y: frame.minY + 0.08768 * frame.height))
        checkMarkPath.addLine(to: CGPoint(x: frame.minX + 0.51450 * frame.width, y: frame.minY + 0.93814 * frame.height))
        checkMarkPath.addCurve(to: CGPoint(x: frame.minX + 0.42913 * frame.width, y: frame.minY + 0.96429 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.49724 * frame.width, y: frame.minY + 0.97230 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.45902 * frame.width, y: frame.minY + 0.98401 * frame.height))
        checkMarkPath.addLine(to: CGPoint(x: frame.minX + 0.32087 * frame.width, y: frame.minY + 0.89286 * frame.height))
        checkMarkPath.addCurve(to: CGPoint(x: frame.minX + 0.29800 * frame.width, y: frame.minY + 0.79528 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.29098 * frame.width, y: frame.minY + 0.87313 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.28074 * frame.width, y: frame.minY + 0.82945 * frame.height))
        checkMarkPath.addLine(to: CGPoint(x: frame.minX + 0.83511 * frame.width, y: frame.minY + 0.03255 * frame.height))
        checkMarkPath.addCurve(to: CGPoint(x: frame.minX + 0.92048 * frame.width, y: frame.minY + 0.00641 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.85237 * frame.width, y: frame.minY + -0.00161 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.89059 * frame.width, y: frame.minY + -0.01331 * frame.height))
        checkMarkPath.close()
        checkMarkPath.move(to: CGPoint(x: frame.minX + 0.37500 * frame.width, y: frame.minY + 0.78572 * frame.height))
        checkMarkPath.addLine(to: CGPoint(x: frame.minX + 0.43750 * frame.width, y: frame.minY + 0.78572 * frame.height))
        checkMarkPath.addCurve(to: CGPoint(x: frame.minX + 0.50000 * frame.width, y: frame.minY + 0.85714 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.47202 * frame.width, y: frame.minY + 0.78572 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.50000 * frame.width, y: frame.minY + 0.81769 * frame.height))
        checkMarkPath.addLine(to: CGPoint(x: frame.minX + 0.50000 * frame.width, y: frame.minY + 0.92857 * frame.height))
        checkMarkPath.addCurve(to: CGPoint(x: frame.minX + 0.43750 * frame.width, y: frame.minY + 1.00000 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.50000 * frame.width, y: frame.minY + 0.96802 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.47202 * frame.width, y: frame.minY + 1.00000 * frame.height))
        checkMarkPath.addLine(to: CGPoint(x: frame.minX + 0.37500 * frame.width, y: frame.minY + 1.00000 * frame.height))
        checkMarkPath.addCurve(to: CGPoint(x: frame.minX + 0.31250 * frame.width, y: frame.minY + 0.92857 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.34048 * frame.width, y: frame.minY + 1.00000 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.31250 * frame.width, y: frame.minY + 0.96802 * frame.height))
        checkMarkPath.addLine(to: CGPoint(x: frame.minX + 0.31250 * frame.width, y: frame.minY + 0.85714 * frame.height))
        checkMarkPath.addCurve(to: CGPoint(x: frame.minX + 0.37500 * frame.width, y: frame.minY + 0.78572 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.31250 * frame.width, y: frame.minY + 0.81769 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.34048 * frame.width, y: frame.minY + 0.78572 * frame.height))
        checkMarkPath.close()
        checkMarkColor?.setFill()
        checkMarkPath.fill()
    }
}

class TableViewCell: UITableViewCell {
    var accessoryCheckmarkColor: UIColor = UIColor.white
    var disclosureIndicatorColor: UIColor = UIColor.white
    override var accessoryType: UITableViewCellAccessoryType {
        didSet {
            if self.accessoryType == .checkmark {
                let customCheckmark = CustomCheckmark(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
                customCheckmark.color = self.accessoryCheckmarkColor
                self.accessoryView = customCheckmark
            } else if self.accessoryType == .disclosureIndicator {
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
