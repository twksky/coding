//
//  ProgressView.swift
//  cxd4iphone
//
//  Created by hexy on 12/14/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit

private struct kConstraints {
    
    static let cornerRadius: CGFloat = 8
    static let wrapEdges: UIEdgeInsets = UIEdgeInsetsMake(25, 40, -20, -40)
    static let xRedColor: UIColor = xx_colorWithHex(hexValue: 0xf64242)
    static let xBlueColor: UIColor = xx_colorWithHex(hexValue: 0x3d64b4)
    static let lightFontColor: UIColor = xx_colorWithHex(hexValue: 0x666666)
    static let darkFontColor: UIColor = xx_colorWithHex(hexValue: 0x333333)
    static let progressHeight: CGFloat = xx_height(12)
}

class ProgressView: UIView {
    
    var progress: Float? {
        
        didSet {
            
            
            self.progressView.layoutIfNeeded()
            self.indicateBtn.layoutIfNeeded()
//            marginLeft = 161 * CGFloat(progress!)
            let some = self.progressView.frame.width * CGFloat(progress!) - 10
//            xx_print(some)
            self.indicateBtn.snp_updateConstraints(closure: { (make) -> Void in
                
                make.left.equalTo(self.progressView).offset(some)
            })

//            self.indicateBtn.setTitle("30.0%", forState: .Normal)
            animation()
            UIView.animateWithDuration(5.0) { () -> Void in
                
                self.progressView.setProgress(self.progress!, animated: true)
                
                self.indicateBtn.layoutIfNeeded()
//                self.indicateBtn.transform = CGAffineTransformTranslate(self.indicateBtn.transform, some, 0)
            }
            

        }
    }
    
    var timer: CADisplayLink?
    
    func animation() {
        timer = CADisplayLink(target: self, selector: "intervalAnimation");
        timer!.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    static var count = 0
   @objc private func intervalAnimation() {
        
        let count = ProgressView.count++
//        xx_print(count)

        self.indicateBtn.setTitle("\(count/6)%", forState: .Normal)
        if ProgressView.count == 300 {
            timer!.invalidate()
        }
       
    }
    
//    var height: CGFloat? {
//        
//        didSet {
//            
//            xx_print("xxx")
//            self.progressView.layoutIfNeeded()
//            self.indicateBtn.layoutIfNeeded()
//            self.progressView.layer.cornerRadius = height! / 2
//            self.progressView.snp_updateConstraints { (make) -> Void in
//                
//                make.height.equalTo(height!)
//            }
//            self.indicateBtn.snp_updateConstraints { (make) -> Void in
//                
//                make.bottom.equalTo(progressView.snp_top).offset(-2)
//            }
//        }
//    }


//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//    }
    private var xHeight: CGFloat = 0
    init(height: CGFloat) {
        super.init(frame: CGRectZero)
        xHeight = height
        makeUI()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        marginLeft = self.frame.width - 9
//        xx_print(marginLeft)
    }
    
    func makeUI() {
        
        progressView.layer.cornerRadius = xHeight * CGFloat(0.5)
        self.addSubview(progressView)
        progressView.snp_makeConstraints { (make) -> Void in
            
            make.left.right.equalTo(self)
            make.centerY.equalTo(self)
            make.height.equalTo(xHeight)
        }
        
        self.addSubview(indicateBtn)
        indicateBtn.snp_makeConstraints { (make) -> Void in
            
            make.bottom.equalTo(progressView.snp_top).offset(-2)
            make.left.equalTo(progressView).offset(marginLeft)
        }
    }
    private lazy var marginLeft: CGFloat = -9
    
    lazy var progressView: UIProgressView = {
        
        let progressView = UIProgressView()
        
        progressView.trackTintColor = xx_colorWithHex(hexValue: 0xefefef)
        progressView.progressTintColor = kConstraints.xBlueColor
        progressView.layer.cornerRadius = kConstraints.progressHeight / 2
        progressView.clipsToBounds = true

        return progressView
    }()
    
    lazy var indicateBtn: UIButton = {
        
        let indicateBtn = UIButton(title: "0.0%", titleColor: kConstraints.xRedColor, titleSize: 6, bgColor: UIColor.clearColor())
        indicateBtn.layer.cornerRadius = 0
        indicateBtn.setBackgroundImage(UIImage(named: "choice_pop"), forState: .Normal)
        indicateBtn.titleEdgeInsets = UIEdgeInsetsMake(-4, 0, 0, 0)
        indicateBtn.userInteractionEnabled = false
        indicateBtn.sizeToFit()
        return indicateBtn
    }()
}

//extension