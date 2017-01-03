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

class SideDrawerSectionHeaderView: UIView {
    var title: String? {
        didSet {
            self.label?.text = self.title?.uppercased()
        }
    }
    fileprivate var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonSetup()
    }
    
    func commonSetup() {
        self.backgroundColor = UIColor(red: 110 / 255, green: 113 / 255, blue: 115 / 255, alpha: 1.0)
        self.label = UILabel(frame: CGRect(x: 15, y: self.bounds.maxY - 28, width: self.bounds.width - 30, height: 22))
        self.label.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption1)
        self.label.backgroundColor = UIColor.clear
        self.label.textColor = UIColor(red: 203 / 255, green: 206 / 255, blue: 209 / 255, alpha: 1.0)
        self.label.autoresizingMask = [ .flexibleWidth ,.flexibleTopMargin ]
        self.addSubview(self.label)
        self.clipsToBounds = false
    }
    
    override func draw(_ rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext() {
            let lineColor = UIColor(red: 94 / 255, green: 97 / 255, blue: 99 / 255, alpha: 1.0)
            context.setStrokeColor(lineColor.cgColor)
            context.setLineWidth(1.0)
            context.move(to: CGPoint(x: self.bounds.minX, y: self.bounds.maxY - 0.5))
            context.addLine(to: CGPoint(x: self.bounds.maxX, y: self.bounds.maxY - 0.5))
            context.strokePath()
        }
    }
}
