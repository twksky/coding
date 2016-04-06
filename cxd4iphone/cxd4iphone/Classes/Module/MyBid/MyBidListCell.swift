//
//  MyBidListCell.swift
//  cxd4iphone
//
//  Created by hexy on 12/15/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit

class MyBidListCell: BaseTableViewCell {

    
    override func updateUI(viewModel: BaseCellViewModel) {
        
        makeRateView()
        makeLastTimeView()
    }
    override func makeUI() {
        self.accessoryType = .None
        
        self.backgroundColor = Define.backgroundColor
        
        let wrap = UIView(bgColor: UIColor.whiteColor())
        
        contentView.addSubview(wrap)
        wrap.snp_makeConstraints { (make) -> Void in
            
            make.edges.equalTo(UIEdgeInsetsMake(xx_height(10), 0, 0, 0))
        }
        
        let hLine = UIView(bgColor: Define.separatorColor)
        
        wrap.addSubview(hLine)
        hLine.snp_makeConstraints { (make) -> Void in
            
            make.left.right.equalTo(wrap)
            make.height.equalTo(0.5)
            make.bottom.equalTo(wrap.snp_bottom).offset(xx_height(-50))
        }
        
        wrap.addSubview(stateIV)
        stateIV.snp_makeConstraints { (make) -> Void in
            
            make.top.equalTo(wrap)
            make.right.equalTo(wrap).offset(-15)
        }
        
        let bottomView = UIView()
        
        wrap.addSubview(bottomView)
        bottomView.snp_makeConstraints { (make) -> Void in
            
            make.top.equalTo(hLine.snp_bottom)
            make.left.bottom.right.equalTo(wrap)
        }
        
        bottomView.addSubview(repayScheduleBtn)
        repayScheduleBtn.snp_makeConstraints { (make) -> Void in
            
            make.center.equalTo(bottomView)
            make.height.equalTo(xx_height(32))
            make.width.equalTo(xx_width(100))
        }
        
        bottomView.addSubview(loanPactBtn)
        loanPactBtn.snp_makeConstraints { (make) -> Void in
            
            make.left.equalTo(repayScheduleBtn.snp_right).offset(5)
            make.centerY.equalTo(repayScheduleBtn)
        }
        
        
//        let topView = UIView(bgColor: xx_randomColor())
        let topView = UIView()
        
        wrap.addSubview(topView)
        topView.snp_makeConstraints { (make) -> Void in
            
            make.top.equalTo(wrap).offset(10)
            make.left.equalTo(wrap).offset(15)
            make.bottom.equalTo(hLine).offset(-15)
            make.right.equalTo(wrap).offset(-15)
        }
        
        topView.addSubview(titleLabel)
        titleLabel.snp_makeConstraints { (make) -> Void in
            
            make.top.left.equalTo(topView)
        }
        
//        let topLeftView = UIView(bgColor: xx_randomColor())
        let topLeftView = UIView()
        
        topView.addSubview(topLeftView)
        topLeftView.snp_makeConstraints { (make) -> Void in
            
            make.top.equalTo(titleLabel.snp_bottom).offset(xx_height(5))
            make.left.bottom.equalTo(topView)
            make.width.equalTo(xx_width(95))
        }
        
        
        let labels = [repayLabel, profitLabel, investLabel, repayTimeLabel, investTimeLabel]
        var lastLb: UILabel?
        
        for label in labels {
            
            topLeftView.addSubview(label)
            label.snp_makeConstraints(closure: { (make) -> Void in
                
                make.left.equalTo(topLeftView)
                
                if let last = lastLb {
                    
                    make.top.equalTo(last.snp_bottom).offset(xx_height(2))
                    
                } else {
                    
                    make.top.equalTo(topLeftView)
                    
                }
                lastLb = label
            })
        }
        
//        let topRightView = UIView(bgColor: xx_randomColor())
                let topRightView = UIView()
        
        wrap.addSubview(topRightView)
        topRightView.snp_makeConstraints { (make) -> Void in
            
            make.top.bottom.equalTo(topLeftView)
            make.left.equalTo(topLeftView.snp_right)
            make.width.equalTo(xx_width(100))
        }
        
        let numLabels = [repayNumLabel, profitNumLabel, investNumLabel, repayTimeNumLabel, investTimeNumLabel]
        var numLastLb: UILabel?
        
        for label in numLabels {
            
            topRightView.addSubview(label)
            label.snp_makeConstraints(closure: { (make) -> Void in
                
                make.left.equalTo(topRightView)
                
                if let last = numLastLb {
                    
                    make.top.equalTo(last.snp_bottom)//.offset(xx_height(1))
                    
                } else {
                    
                    make.top.equalTo(topRightView)
                    
                }
                numLastLb = label
            })
        }
        
        topView.addSubview(ralWrap)
        ralWrap.snp_makeConstraints { (make) -> Void in
            
            make.right.equalTo(topView)
            make.bottom.equalTo(topView).offset(xx_height(3))
            make.height.equalTo(xx_height(25))
            make.width.equalTo(xx_width(65))
        }
    }
    
    
    func makeRateView() {
        
        let rv = RateView(num: "20", numFontSize: 25, symbolFontSize: 10, isTipLabel: false)
        ralWrap.addSubview(rv)
        rv.snp_makeConstraints { (make) -> Void in
            
            make.left.equalTo(ralWrap)
            make.centerY.equalTo(ralWrap)
        }
    }
    
    func makeLastTimeView() {
        
        let num = UILabel(title: "8", fontSize: 16)
        let unit = UILabel(title: "天", fontSize: 12)
        
        
        ralWrap.addSubview(unit)
        unit.snp_makeConstraints { (make) -> Void in
            
            make.right.bottom.equalTo(ralWrap)
        }
        
        ralWrap.addSubview(num)
        num.snp_makeConstraints { (make) -> Void in
            
            make.right.equalTo(unit.snp_left)
            make.centerY.equalTo(unit).offset(xx_folat(-1))
        }
    }
    lazy var titleLabel = UILabel(title: "房屋抵押2015-11-13", fontSize: 14)
    lazy var stateIV = UIImageView(image: UIImage(named: "me_repaying"))
    
    lazy var repayLabel = UILabel(title: "下期还款额(元) :", fontSize: 12)
    lazy var repayNumLabel = UILabel(title: "0.00", fontSize: 13)
    
    lazy var profitLabel = UILabel(title: "待收本息(元) :", fontSize: 12)
    lazy var profitNumLabel = UILabel(title: "0.00", fontSize: 13)
    
    lazy var investLabel = UILabel(title: "投资金额(元) :", fontSize: 12)
    lazy var investNumLabel = UILabel(title: "0.00", fontSize: 13)
    
    lazy var repayTimeLabel = UILabel(title: "下期还款日 :", fontSize: 12)
    lazy var repayTimeNumLabel = UILabel(title: "2015-11-12", fontSize: 13)
    
    lazy var investTimeLabel = UILabel(title: "投资时间 :", fontSize: 12)
    lazy var investTimeNumLabel = UILabel(title: "2015-11-13", fontSize: 13)
    
    lazy var repayScheduleBtn = UIButton(title: "还款计划", titleColor: UIColor.whiteColor(), titleSize: 16, bgColor: Define.blueColor)
    lazy var loanPactBtn = UIButton(title: "《借款合同》", titleColor: Define.blueColor, titleSize: 12, bgColor: UIColor.whiteColor())
    
//    lazy var ralWrap = UIView(bgColor: xx_randomColor())
    lazy var ralWrap = UIView()
}




//        topLeftView.addSubview(repayLabel)
//        repayLabel.snp_makeConstraints { (make) -> Void in
//
//            make.top.left.equalTo(topLeftView)
//        }
//
//        topLeftView.addSubview(profitLabel)
//        profitLabel.snp_makeConstraints { (make) -> Void in
//
//            make.top.equalTo(repayLabel.snp_bottom).offset(xx_height(2))
//            make.left.equalTo(topLeftView)
//        }
//
//        topLeftView.addSubview(investLabel)
//        investLabel.snp_makeConstraints { (make) -> Void in
//
//            make.top.equalTo(profitLabel.snp_bottom).offset(xx_height(2))
//            make.left.equalTo(topLeftView)
//        }
//
//        topLeftView.addSubview(repayTimeLabel)
//        repayTimeLabel.snp_makeConstraints { (make) -> Void in
//
//            make.top.equalTo(investLabel.snp_bottom).offset(xx_height(2))
//            make.left.equalTo(topLeftView)
//        }
//
//        topLeftView.addSubview(investTimeLabel)
//        investTimeLabel.snp_makeConstraints { (make) -> Void in
//
//            make.top.equalTo(repayTimeLabel.snp_bottom).offset(xx_height(2))
//            make.left.equalTo(topLeftView)
//        }
