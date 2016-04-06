//
//  CircleRateView.swift
//  cxd4iphone
//
//  Created by hexy on 12/16/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit

class CircleProgressView: UIButton {

    var progress: Double = 0 {
        
        didSet {
            
//            xanimation()
            self.setNeedsDisplay()
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func drawRect(rect: CGRect) {
        
//        xx_print(rect)
        let s = rect.size
        let center = CGPointMake(s.width * 0.5, s.height * 0.5)
        
        var r = (s.height > s.width) ? s.width * 0.5 : s.height * 0.5
        r -= 1
        
        let startAng = CGFloat(-M_PI_2)
        var endAng = CGFloat(2 * M_PI) + startAng
        
        let path = UIBezierPath(arcCenter: center, radius: r, startAngle: startAng, endAngle: endAng, clockwise: true)
        
        path.lineWidth = 2
        path.lineCapStyle = .Round
        
        xx_colorWithHex(hexValue: 0xf0f0f0).setStroke()
        
        path.stroke()
        
        endAng = CGFloat(progress * 2 * M_PI) + startAng
        
        let path2 = UIBezierPath(arcCenter: center, radius: r, startAngle: startAng, endAngle: endAng, clockwise: true)
        
        path2.lineWidth = 2
        path2.lineCapStyle = .Round
        
        Define.redColor.setStroke()
        
        path2.stroke()
    }
    
    var timer: CADisplayLink?
    
    func xanimation() {
        timer = CADisplayLink(target: self, selector: "Animation");
        timer!.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    static var count = 0
   @objc private func Animation() {
        
        let count = CircleProgressView.count++
        
        self.numLabel.text = "\(count/6)%"
        self.progress += Double(0.01)
    
//        xx_print(count)
        if CircleProgressView.count >= 120 {
            timer!.invalidate()
            timer = nil
            self.enabled = false
        }
        
    }
    
    func makeUI() {
        
        self.userInteractionEnabled = false
        self.setTitle("马上赚钱", forState: .Normal)
        self.setTitle("已售罄", forState: .Disabled)
        self.titleLabel?.font = xx_fontOfSize(size: 11)
        self.setTitleColor(Define.redColor, forState: .Normal)
        self.setTitleColor(Define.lightFontColor, forState: .Disabled)
        
        self.addSubview(numLabel)
        numLabel.snp_makeConstraints { (make) -> Void in
            
            make.centerX.equalTo(self)
            
            make.bottom.equalTo(self).offset(-4)
        }
        
        
    }
    
    lazy var numLabel = UILabel(title: "50%", fontColor: Define.redColor, bgColor: nil, fontSize: 10, maxWrapWidth: 0)
}
