//
//  BidHeaderView.swift
//  cxd4iphone
//
//  Created by hexy on 12/2/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit
//private struct kConstraints {
//    
//    static let cornerRadius: CGFloat = 8
//    static let wrapEdges: UIEdgeInsets = UIEdgeInsetsMake(25, 40, -20, -40)
//    
//    static let progressHeight: CGFloat = xx_height(12)
//}
private struct kConstraints {
    
    static let wrapEdges: UIEdgeInsets = UIEdgeInsetsMake(xx_height(10), 0, -xx_height(10), 0)
    static let ratewrapEdges: UIEdgeInsets = UIEdgeInsetsMake(xx_height(10), 60, rateViewMarginBottom - xx_height(10), -60)
    
    static let lineColor: UIColor = xx_colorWithHex(hexValue: 0xededed)
    static let bgColor: UIColor = xx_colorWithHex(hexValue: 0xf8f8f8)
    static let xRedColor: UIColor = xx_colorWithHex(hexValue: 0xf64242)
    static let xBlueColor: UIColor = xx_colorWithHex(hexValue: 0x3d64b4)
    static let lightFontColor: UIColor = xx_colorWithHex(hexValue: 0x666666)
    static let darkFontColor: UIColor = xx_colorWithHex(hexValue: 0x333333)

    static let bottomViewHeight: CGFloat = xx_height(70)
    static let divideViewHeight: CGFloat = xx_height(10)
    static let timeViewHeight: CGFloat = xx_height(30)
    static let timeViewMarginBottom: CGFloat = -(bottomViewHeight + divideViewHeight)
    static let rateViewMarginBottom: CGFloat = -(bottomViewHeight + divideViewHeight + timeViewHeight + 1)
    
    
}

class BidHeaderView: UIView {

    var rate: Float? {
        
        didSet {
            
//            xx_print("xxx")
            makeTimeView("2015-11-12", lastTime: "2个月")
            makeRateView("20")
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
        
        backgroundColor = Define.backgroundColor
        
        addSubview(wrap)
        wrap.snp_makeConstraints { (make) -> Void in
            
            make.edges.equalTo(kConstraints.wrapEdges)
        }
        
        makeBottomView()
        
        addSubview(rateWrap)
        rateWrap.snp_makeConstraints { (make) -> Void in
            
            make.edges.equalTo(kConstraints.ratewrapEdges)
        }
    }
    
    lazy var pDetaiBtn : UIButton = {
        
        return TBButton(title: "项目详情", image: UIImage(named: "buy_detail")!)
    }()
    
    lazy var pRiskBtn : UIButton = {
        
        return TBButton(title: "项目风控", image: UIImage(named: "buy_risk")!)
    }()
    
    lazy var bidHistoryBtn : UIButton = {
        
        return TBButton(title: "投资记录", image: UIImage(named: "buy_history")!)
    }()
    
    lazy var wrap: UIView = {
        
        let rateWrap = UIView(bgColor: UIColor.whiteColor())
//        rateWrap.backgroundColor = xx_randomColor()
        return rateWrap
    }()
    
    lazy var rateWrap: UIView = {
        
        let rateWrap = UIView()
//                rateWrap.backgroundColor = xx_randomColor()
        return rateWrap
    }()

}


extension BidHeaderView {
    
    func makeRateView(rate: String) {
        
        let progressWrap = UIView(bgColor: UIColor.whiteColor())
        
        rateWrap.addSubview(progressWrap)
        progressWrap.snp_makeConstraints { (make) -> Void in
            
            make.left.bottom.right.equalTo(rateWrap)
            make.height.equalTo(xx_height(20))
        }
        
        let progressView = ProgressView(height: xx_height(8))
        progressWrap.addSubview(progressView)
        progressView.snp_makeConstraints { (make) -> Void in
            
            make.edges.equalTo(progressWrap)
        }
        
        let rateView = RateView(num: rate, numFontSize: 100, symbolFontSize: 40, isTipLabel: true)
        
        rateWrap.addSubview(rateView)
        rateView.snp_makeConstraints { (make) -> Void in
            
            make.centerX.equalTo(rateWrap)
            make.centerY.equalTo(rateWrap).offset(-20)
        }
    }
    
    func makeTimeView(beginTime: String, lastTime: String) {
        


        let middleView = UIView()

        wrap.addSubview(middleView)
        middleView.snp_makeConstraints { (make) -> Void in

            make.bottom.equalTo(wrap).offset(kConstraints.timeViewMarginBottom)
            make.left.equalTo(wrap).offset(15)
            make.right.equalTo(wrap).offset(-15)
            make.height.equalTo(xx_height(30))
        }

        let hLine = UIView(bgColor: kConstraints.lineColor)

        middleView.addSubview(hLine)
        hLine.snp_makeConstraints { (make) -> Void in

            make.top.left.right.equalTo(middleView)
            make.height.equalTo(1)
        }

        let vLine = UIView(bgColor: kConstraints.lineColor)

        middleView.addSubview(vLine)
        vLine.snp_makeConstraints { (make) -> Void in

            make.center.equalTo(middleView)
            make.height.equalTo(xx_height(15))
            make.width.equalTo(1)
        }

        let lastBtn = UIButton(title: " \(lastTime)封闭期", titleColor: xx_colorWithHex(hexValue: 0x999999), titleSize: 12, bgColor: UIColor.whiteColor(), normalImage: UIImage(named: "buy_last"))

        middleView.addSubview(lastBtn)
        lastBtn.snp_makeConstraints { (make) -> Void in

            make.left.bottom.equalTo(middleView)
            make.right.equalTo(vLine.snp_left)
            make.top.equalTo(hLine.snp_bottom)
        }

        let beginBtn = UIButton(title: " 发布时间:\(beginTime)", titleColor: xx_colorWithHex(hexValue: 0x999999), titleSize: 12, bgColor: UIColor.whiteColor(), normalImage: UIImage(named: "buy_begin"))
        
        middleView.addSubview(beginBtn)
        beginBtn.snp_makeConstraints { (make) -> Void in
            
            make.right.bottom.right.equalTo(middleView)
            make.left.equalTo(vLine.snp_right)
            make.top.equalTo(hLine.snp_bottom)
        }

        
    }
    
    func makeBottomView() {
        
        let bottomView = UIView()
        bottomView.backgroundColor = xx_randomColor()
        wrap.addSubview(bottomView)
        bottomView.snp_makeConstraints { (make) -> Void in
            
            make.left.bottom.right.equalTo(wrap)
            make.height.equalTo(kConstraints.bottomViewHeight)
        }
        
        let divideView = UIView(bgColor: kConstraints.bgColor)
        
        wrap.addSubview(divideView)
        divideView.snp_makeConstraints { (make) -> Void in
            
            make.left.right.equalTo(wrap)
            make.bottom.equalTo(bottomView.snp_top)
            make.height.equalTo(kConstraints.divideViewHeight)
        }
        
        
        bottomView.addSubview(pDetaiBtn)
        pDetaiBtn.snp_makeConstraints { (make) -> Void in
            
            make.top.left.bottom.equalTo(bottomView)
        }
        
        bottomView.addSubview(pRiskBtn)
        pRiskBtn.snp_makeConstraints { (make) -> Void in
            
            make.left.equalTo(pDetaiBtn.snp_right)
            make.top.bottom.equalTo(bottomView)
            make.width.equalTo(pDetaiBtn)
        }
        
        bottomView.addSubview(bidHistoryBtn)
        bidHistoryBtn.snp_makeConstraints { (make) -> Void in
            
            make.left.equalTo(pRiskBtn.snp_right)
            make.width.equalTo(pDetaiBtn)
            make.top.bottom.right.equalTo(bottomView)
        }
        
        let vLine1 = UIView(bgColor: kConstraints.lineColor)
        
        bottomView.addSubview(vLine1)
        vLine1.snp_makeConstraints { (make) -> Void in
            
            make.left.equalTo(pDetaiBtn.snp_right)
            make.centerY.equalTo(bottomView)
            make.height.equalTo(xx_height(35))
            make.width.equalTo(1)
        }
        
        let vLine2 = UIView(bgColor: kConstraints.lineColor)
        
        bottomView.addSubview(vLine2)
        vLine2.snp_makeConstraints { (make) -> Void in
            
            make.left.equalTo(pRiskBtn.snp_right)
            make.centerY.equalTo(bottomView)
            make.height.equalTo(xx_height(35))
            make.width.equalTo(1)
        }

    }
}



extension TBButton {
    
    convenience init(title: String, image: UIImage) {
        self.init()
        
        titleLabel?.textAlignment = .Center
        titleLabel?.font = xx_fontOfSize(size: 12)
        titleLabel?.sizeToFit()
        backgroundColor = UIColor.whiteColor()
        
        setTitle(title, forState: .Normal)
        setTitleColor(xx_colorWithHex(hexValue: 0x333333), forState: .Normal)
        setImage(image, forState: .Normal)
    }
}

private class TBButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView?.contentMode = .Center
        titleLabel?.textAlignment = .Center
        //        titleLabel?.font = xx_fontOfSize(size: xx_folat(12))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
        
        let titleX: CGFloat = 0.0
        let titleY: CGFloat = contentRect.size.height * 0.5
        let titleWidth: CGFloat = contentRect.size.width
        let titleHeight: CGFloat = contentRect.size.height * 0.6
        
        return CGRectMake(titleX, titleY, titleWidth, titleHeight)
    }
    
    private override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
        
        let imageX: CGFloat = 0.0
        let imageY: CGFloat = 0.0
        let imageWidth: CGFloat = contentRect.size.width
        let iamgeHeight: CGFloat = contentRect.size.height * 0.7
        return CGRectMake(imageX, imageY, imageWidth, iamgeHeight)
    }
}