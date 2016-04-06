//
//  BidFooterView.swift
//  cxd4iphone
//
//  Created by hexy on 12/2/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit

private struct kConstraints {
    
    static let lightColor: UIColor = xx_colorWithHex(hexValue: 0x999999)
    static let darkColor: UIColor = xx_colorWithHex(hexValue: 0x333333)
    static let redColor: UIColor = xx_colorWithHex(hexValue: 0xf64243)
    static let bidTextFieldBorderCorlor: CGColor = xx_colorWithHex(hexValue: 0xf8f8f8).CGColor
    static let bidTextFieldBgCorlor: UIColor = xx_colorWithHex(hexValue: 0xf8f8f8)
    
    static let wrapEdges: UIEdgeInsets = UIEdgeInsetsMake(0, 15, 0, -15)
    
    static let topViewHeight: CGFloat = xx_height(30)
    
    static let middleViewHeight: CGFloat = xx_height(90)
    
    static let middleTopViewHeight: CGFloat = xx_height(25)
    static let middleCenterViewHeight: CGFloat = xx_height(60)
    
    static let middleBottomViewHeight: CGFloat = xx_height(20)
    
    static let middleBottomViewMarginTopNormal: CGFloat = xx_height(5)
    static let middleBottomViewMarginTopError: CGFloat = xx_height(15)
    
    static let bidTextFieldHeight: CGFloat = xx_height(40)
    
    static let fontSize14: CGFloat = 14
    static let fontSize10: CGFloat = 10
    static let fontSize13: CGFloat = 13
    static let fontSize16: CGFloat = 16
    static let fontSize18: CGFloat = 18
    static let fontSize11: CGFloat = 11
    
    static let tipLabelMarginTop: CGFloat = xx_height(3)
    static let tipLabelMarginLeft: CGFloat = xx_height(10)
    
    static let depositBtnWidth: CGFloat = xx_width(40)
    static let depositBtnHeight: CGFloat = xx_height(22)
}

class BidFooterView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeUI() {
        
        backgroundColor = UIColor.whiteColor()
        
        let wrap = UIView()
        
        addSubview(wrap)
        wrap.snp_makeConstraints { (make) -> Void in
            
            make.edges.equalTo(kConstraints.wrapEdges)
        }
        
        let topView = UIView()
        wrap.addSubview(topView)
        topView.snp_makeConstraints { (make) -> Void in
            
            make.top.left.right.equalTo(wrap)
            make.height.equalTo(kConstraints.topViewHeight)
        }
        
        let accountBalanceLabel = UILabel(title: "账户余额 (元) ", fontColor: kConstraints.lightColor, bgColor: nil, fontSize: kConstraints.fontSize14, maxWrapWidth: 0)
        
        topView.addSubview(accountBalanceLabel)
        accountBalanceLabel.snp_makeConstraints { (make) -> Void in
            
            make.centerY.equalTo(topView)
            make.left.equalTo(topView)
        }
        
        topView.addSubview(accountBalanceNumLabel)
        
        accountBalanceNumLabel.snp_makeConstraints { (make) -> Void in
            
            make.left.equalTo(accountBalanceLabel.snp_right)
            make.centerY.equalTo(topView)
        }
        
        topView.addSubview(depositBtn)
        depositBtn.snp_makeConstraints { (make) -> Void in
            
            make.right.equalTo(topView)
            make.centerY.equalTo(topView)
            make.height.equalTo(kConstraints.depositBtnHeight)
            make.width.equalTo(kConstraints.depositBtnWidth)
        }
        
        let middleView = UIView()
        
        wrap.addSubview(middleView)
        middleView.snp_makeConstraints { (make) -> Void in
            
            make.top.equalTo(topView.snp_bottom)
            make.left.right.equalTo(wrap)
            make.height.equalTo(kConstraints.middleViewHeight)
        }
        
        let middleTopView = UIView()
        
        middleView.addSubview(middleTopView)
        middleTopView.snp_makeConstraints { (make) -> Void in
            
            make.top.left.right.equalTo(middleView)
            make.height.equalTo(kConstraints.middleTopViewHeight)
        }
        
        let mLeftLabel = UILabel(title: "最小投资金额 (元) 100", fontColor: kConstraints.lightColor, bgColor: nil, fontSize: kConstraints.fontSize10, maxWrapWidth: 0)
        
        middleTopView.addSubview(mLeftLabel)
        mLeftLabel.snp_makeConstraints { (make) -> Void in
            
            make.left.equalTo(middleTopView)
            make.centerY.equalTo(middleTopView)
        }
        
        let mRightLabel = UILabel(title: "递增金额 (元) 100", fontColor: kConstraints.lightColor, bgColor: nil, fontSize: kConstraints.fontSize10, maxWrapWidth: 0)
        
        middleTopView.addSubview(mRightLabel)
        mRightLabel.snp_makeConstraints { (make) -> Void in
            
            make.right.equalTo(middleTopView)
            make.centerY.equalTo(middleTopView)
        }
        
        let middleCenterView = UIView()
        
        middleView.addSubview(middleCenterView)
        middleCenterView.snp_makeConstraints { (make) -> Void in
            
            make.top.equalTo(middleTopView.snp_bottom)//.offset(5)
            make.left.right.equalTo(wrap)
            make.height.equalTo(kConstraints.middleCenterViewHeight)
        }
        
        middleCenterView.addSubview(bidTextField)
        bidTextField.snp_makeConstraints { (make) -> Void in
            
            make.top.left.right.equalTo(middleCenterView)
            make.height.equalTo(kConstraints.bidTextFieldHeight)
        }
        
        let tipLabel = UILabel(title: "*剩余可投金额 (元) 10,000,000,00", fontColor: kConstraints.redColor, bgColor: nil, fontSize: kConstraints.fontSize10, maxWrapWidth: 0)
        
        middleCenterView.addSubview(tipLabel)
        tipLabel.snp_makeConstraints { (make) -> Void in
            
            make.top.equalTo(bidTextField.snp_bottom).offset(kConstraints.tipLabelMarginTop)
            make.left.equalTo(middleCenterView).offset(kConstraints.tipLabelMarginLeft)
        }
        
        
        let middleBottomView = UIView(bgColor: UIColor.whiteColor())
        
        middleView.addSubview(middleBottomView)
        middleBottomView.snp_makeConstraints { (make) -> Void in
            
            make.left.right.equalTo(middleView)
            make.height.equalTo(kConstraints.middleBottomViewHeight)
            make.top.equalTo(bidTextField.snp_bottom).offset(kConstraints.middleBottomViewMarginTopError)
        }
        
        let expectProfitLabel = UILabel(title: "预计收益 (元) ", fontColor: kConstraints.lightColor, bgColor: nil, fontSize: kConstraints.fontSize13, maxWrapWidth: 0)
        
        middleBottomView.addSubview(expectProfitLabel)
        expectProfitLabel.snp_makeConstraints { (make) -> Void in
            
            make.centerY.equalTo(middleBottomView)
            make.left.equalTo(middleBottomView)
        }
        
        middleBottomView.addSubview(expectProfitNumLabel)
        expectProfitNumLabel.snp_makeConstraints { (make) -> Void in
            
            make.centerY.equalTo(middleBottomView)
            make.left.equalTo(expectProfitLabel.snp_right)
        }

        
        let bottomView = UIView()
        wrap.addSubview(bottomView)
        bottomView.snp_makeConstraints { (make) -> Void in
            
            make.top.equalTo(middleView.snp_bottom)
            make.left.bottom.right.equalTo(wrap)
        }
        
        bottomView.addSubview(bidBtn)
        bidBtn.snp_makeConstraints { (make) -> Void in
            
            make.centerY.equalTo(bottomView)
            make.left.right.equalTo(bottomView)
            make.height.equalTo(kConstraints.bidTextFieldHeight)
        }
        
    }
    
    lazy var bidBtn = UIButton(title: "马上赚钱", titleColor: UIColor.whiteColor(), titleSize: kConstraints.fontSize18, bgColor: kConstraints.redColor)
    
    lazy var accountBalanceNumLabel = UILabel(title: "50,000,00", fontColor: kConstraints.darkColor, bgColor: nil, fontSize: kConstraints.fontSize18, maxWrapWidth: 0)
    
    lazy var expectProfitNumLabel = UILabel(title: "1,234.00", fontColor: kConstraints.redColor, bgColor: nil, fontSize: kConstraints.fontSize16, maxWrapWidth: 0)
    
    lazy var bidTextField: UITextField = {
        
        let tf = UITextField()
        tf.placeholder = "剩余可投资金额 (元) 124,000.00"
        tf.borderStyle = .RoundedRect
        tf.layer.borderColor = kConstraints.bidTextFieldBorderCorlor
        tf.textAlignment = .Center
        tf.backgroundColor = kConstraints.bidTextFieldBgCorlor
        tf.keyboardType = .NumberPad
        tf.clearButtonMode = .WhileEditing
        return tf
    }()
    
    lazy var depositBtn = UIButton(title: "充值", titleColor: UIColor.whiteColor(), titleSize: kConstraints.fontSize11, bgColor: kConstraints.redColor)
}


