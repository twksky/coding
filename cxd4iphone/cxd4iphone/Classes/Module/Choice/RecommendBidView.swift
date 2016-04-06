//
//  ChoiceFooterView.swift
//  cxd4iphone
//
//  Created by hexy on 11/28/15.
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

class ChoiceFooterView: UIView {

    var recommendBidViewModel: RecommendBidViewModel? {
        
        didSet {
            
            let vm = recommendBidViewModel!
            xx_removeAllChildViews(self.bottomWrap)
            makeRateView(vm.bidModel.rate!)
            makeProgressView(0.3)
            makeBottomView(vm.minInvestMoney, lastTime: vm.lastTime , lastUnit: vm.bidModel.unit!)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeUI() {
        
        backgroundColor = UIColor.whiteColor()
        
        addSubview(wrap)
        wrap.snp_makeConstraints { (make) -> Void in
            
            make.edges.equalTo(kConstraints.wrapEdges)
        }
        
        wrap.addSubview(topBtn)
        topBtn.snp_makeConstraints { (make) -> Void in
            
            make.centerX.equalTo(wrap)
            make.top.equalTo(wrap).offset(-7)
        }
        
        wrap.addSubview(bottomWrap)
        bottomWrap.snp_makeConstraints { (make) -> Void in
            
            make.left.bottom.right.equalTo(wrap)
            make.height.equalTo(xx_height(60))
        }
        
        wrap.addSubview(progressWrap)
        progressWrap.snp_makeConstraints { (make) -> Void in
            
            make.left.right.equalTo(wrap)
            make.bottom.equalTo(bottomWrap.snp_top)
            make.height.equalTo(xx_height(45))
        }
        
        wrap.addSubview(rateWrap)
        rateWrap.snp_makeConstraints { (make) -> Void in
            
            make.top.equalTo(topBtn.snp_bottom).offset(xx_height(15))
            make.bottom.equalTo(progressWrap.snp_top)
            make.left.right.equalTo(wrap)
        }

    }
    
    lazy var profitBtn: UIButton = {
        
        let btn = UIButton(title: "马上赚钱", titleColor: UIColor.whiteColor(), titleSize: 20, bgColor: UIColor.clearColor())
        btn.layer.cornerRadius = 8
        btn.clipsToBounds = true
        return btn
    }()
    
    lazy var topBtn: UIButton = {
        
        let topBtn = UIButton(title: "热门推荐", titleColor: UIColor.whiteColor(), titleSize: 12, bgColor: UIColor.clearColor())
        topBtn.setBackgroundImage(UIImage(named: "choice_topImage"), forState: .Normal)
        topBtn.sizeToFit()
        return topBtn
    }()

    lazy var wrap: UIView = {
        
        let wrap = UIView()
        wrap.backgroundColor = UIColor.whiteColor()
        wrap.layer.cornerRadius = kConstraints.cornerRadius
        wrap.layer.shadowColor = UIColor.blackColor().CGColor
        wrap.layer.shadowOffset = CGSizeMake(0.0, 0.0)
        wrap.layer.shadowOpacity = 0.2
        wrap.layer.shadowRadius = 6
        return wrap
    }()
    
    lazy var rateWrap: UIView = {
        
        let rateWrap = UIView()
//        rateWrap.backgroundColor = xx_randomColor()
        return rateWrap
    }()
    
    lazy var progressWrap: UIView = {
        
        let progressWrap = UIView()
//        progressWrap.backgroundColor = xx_randomColor()
        
        return progressWrap
    }()

    lazy var bottomWrap: UIView = {
        
        let bottomWrap = UIView()
        bottomWrap.layer.cornerRadius = kConstraints.cornerRadius
        return bottomWrap
    }()
    
    
    
}

extension ChoiceFooterView {
    
    func makeRateView(rate: String) {
        
        var rateViewMarginTop: CGFloat = 0
        
        if xx_iPhone4() {
            
            rateViewMarginTop = -40
            
        } else if xx_iPhone5() {
            
            rateViewMarginTop = -40
         
            
        } else if xx_iPhone6() {
            
            rateViewMarginTop = -55
            
        } else {
            
            rateViewMarginTop = -55
        }

        let rateView = RateView(num: rate, numFontSize: 130, symbolFontSize: 50, isTipLabel: true)
        rateWrap.addSubview(rateView)
        rateView.snp_makeConstraints { (make) -> Void in
            
            make.centerX.equalTo(rateWrap)
            make.top.equalTo(rateWrap).offset(rateViewMarginTop)
        }
        
    }
    
    func makeProgressView(progress: Float) {
        
        
        let progressOffset: CGFloat = xx_iPhone4() ? 6 : -5
        


        let contentView = UIView(bgColor: UIColor.whiteColor())
        
        progressWrap.addSubview(contentView)
        
        contentView.snp_makeConstraints { (make) -> Void in
            
            make.edges.equalTo(UIEdgeInsetsMake(0, 35, 0, -35))
        }
        
        let progressView = ProgressView(height: xx_height(12))
        
        contentView.addSubview(progressView)
        progressView.snp_makeConstraints { (make) -> Void in
            
                make.left.right.equalTo(contentView)
                make.centerY.equalTo(contentView).offset(progressOffset)
                make.height.equalTo(kConstraints.progressHeight)
        }
        progressView.progress = progress
    }
    
    func makeBottomView(beginInvest: String, lastTime: String, lastUnit: String) {
        
        
        bottomWrap.backgroundColor = kConstraints.xBlueColor
        
        let topView = UIView(bgColor: UIColor.whiteColor())
        bottomWrap.addSubview(topView)
        topView.snp_makeConstraints { (make) -> Void in
            
            make.top.left.right.equalTo(bottomWrap)
            make.height.equalTo(xx_height(20))
        }
        
        let beginNumLabel = UILabel(title: beginInvest, fontColor: kConstraints.darkFontColor, bgColor: nil, fontSize: 14, maxWrapWidth: 0)
        
        topView.addSubview(beginNumLabel)
        beginNumLabel.snp_makeConstraints { (make) -> Void in
            
            make.left.equalTo(topView).offset(25)
            make.centerY.equalTo(topView)
            make.width.greaterThanOrEqualTo(1)
        }
        
        let tipLabel = UILabel(title: "元起投", fontColor: kConstraints.darkFontColor, bgColor: nil, fontSize: 11, maxWrapWidth: 0)
        topView.addSubview(tipLabel)
        tipLabel.snp_makeConstraints { (make) -> Void in
            
            make.centerY.equalTo(topView)
            make.left.equalTo(beginNumLabel.snp_right)
        }
        
        let lastUnitLabel = UILabel(title: lastUnit, fontColor: kConstraints.darkFontColor, bgColor: nil, fontSize: 11, maxWrapWidth: 0)
        
        topView.addSubview(lastUnitLabel)
        lastUnitLabel.snp_makeConstraints { (make) -> Void in
            
            make.centerY.equalTo(topView)
            make.right.equalTo(topView).offset(-25)
        }
        
        let lastNumLabel = UILabel(title: lastTime, fontColor: kConstraints.xRedColor, bgColor: nil, fontSize: 20, maxWrapWidth: 0)
        
        topView.addSubview(lastNumLabel)
        lastNumLabel.snp_makeConstraints { (make) -> Void in
            
            if xx_iPhone4() == true {
            
                make.centerY.equalTo(topView).offset(-1.5)
                make.right.equalTo(lastUnitLabel.snp_left)
            } else {
                
                make.centerY.equalTo(topView).offset(-1.5)
                make.right.equalTo(lastUnitLabel.snp_left)
            }
        }
        bottomWrap.addSubview(profitBtn)
        profitBtn.snp_makeConstraints { (make) -> Void in
            
            make.left.bottom.right.equalTo(bottomWrap)
            make.height.equalTo(xx_height(40))
        }
    }
    
}
