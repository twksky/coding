//
//  MeFooterView.swift
//  cxd4iphone
//
//  Created by hexy on 11/26/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit

private struct kConstraints {

    static let depositBtnHeight: CGFloat   = xx_height(40)
    static let depositBtnBgColor: UIColor  = xx_colorWithHex(hexValue: 0xf95151)
    static let depositBtnMargin: CGFloat   = 25
    static let withdrawBtnBgColor: UIColor = xx_colorWithHex(hexValue: 0x3d64b4)
    static let titleSize: CGFloat          = 18
    static let titleColor: UIColor         = UIColor.whiteColor()
}

class UserIncomeBottomView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var userIncomeViewModel: UserIncomeViewModel? {
        
        didSet {
            
            let vm = userIncomeViewModel!
            availableNumLabel.text = vm.userIncomeModel.balanceAvaliable!
            freezeNumLabel.text = vm.userIncomeModel.freezeAmount
            stayNumLabel.text = vm.userIncomeModel.collectCorpusAndInterest!
        }
    }

    private func makeUI() {
        
        let topWrap = UIView(bgColor: xx_colorWithHex(hexValue: 0xededed))
        
        addSubview(topWrap)
        topWrap.snp_makeConstraints { (make) -> Void in
            
            make.top.left.right.equalTo(self)
            make.height.equalTo(xx_height(150))
        }

        let row1 = UIView()
        topWrap.addSubview(row1)

        let row2 = UIView()
        topWrap.addSubview(row2)

        row1.snp_makeConstraints { (make) -> Void in

            make.top.left.right.equalTo(topWrap)
        }

        row2.snp_makeConstraints { (make) -> Void in

            make.top.equalTo(row1.snp_bottom).offset(1)
            make.left.right.height.equalTo(row1)
            make.bottom.equalTo(topWrap).offset(-1)
        }

        row1.addSubview(myBidBtn)
        row1.addSubview(myAccountBtn)
        row1.addSubview(myBillBtn)

        myBidBtn.snp_makeConstraints { (make) -> Void in

            make.top.left.bottom.equalTo(row1)
        }

        myBillBtn.snp_makeConstraints { (make) -> Void in


            make.top.bottom.equalTo(myBidBtn)
            make.left.equalTo(myBidBtn.snp_right).offset(1)
            make.width.equalTo(myBidBtn)
        }

        myAccountBtn.snp_makeConstraints { (make) -> Void in

            make.top.bottom.equalTo(myBidBtn)
            make.left.equalTo(myBillBtn.snp_right).offset(1)
            make.right.equalTo(topWrap)
            make.width.equalTo(myBidBtn)
        }


        let availableView = makeCustomView("可用余额")
        let freezeView = makeCustomView("冻结资金")
        let stayView = makeCustomView("待收金额")

        row2.addSubview(availableView)
        row2.addSubview(freezeView)
        row2.addSubview(stayView)

        availableView.snp_makeConstraints { (make) -> Void in

            make.top.left.bottom.equalTo(row2)
        }

        freezeView.snp_makeConstraints { (make) -> Void in

            make.top.bottom.equalTo(row2)
            make.left.equalTo(availableView.snp_right).offset(1)
            make.width.equalTo(availableView)
        }

        stayView.snp_makeConstraints { (make) -> Void in

            make.top.bottom.equalTo(row2)
            make.left.equalTo(freezeView.snp_right).offset(1)
            make.right.equalTo(row2)
            make.width.equalTo(availableView)
        }

        availableView.addSubview(availableNumLabel)
        availableNumLabel.snp_makeConstraints { (make) -> Void in

            make.centerX.equalTo(availableView)
            make.bottom.equalTo(availableView).offset(xx_height(-15))
        }
        
        freezeView.addSubview(freezeNumLabel)
        freezeNumLabel.snp_makeConstraints { (make) -> Void in
            
            make.centerX.equalTo(freezeView)
            make.bottom.equalTo(freezeView).offset(xx_height(-15))
        }
        
        stayView.addSubview(stayNumLabel)
        stayNumLabel.snp_makeConstraints { (make) -> Void in
            
            make.centerX.equalTo(stayView)
            make.bottom.equalTo(stayView).offset(xx_height(-15))
        }

        
        let bottomWrap = UIView(bgColor: UIColor.whiteColor())
        addSubview(bottomWrap)
        bottomWrap.snp_makeConstraints { (make) -> Void in
            
            make.top.equalTo(topWrap.snp_bottom)
            make.left.bottom.right.equalTo(self)
        }
        
        bottomWrap.addSubview(depositBtn)
        bottomWrap.addSubview(withdrawBtn)
        
        depositBtn.snp_makeConstraints { (make) -> Void in
            
            make.centerY.equalTo(bottomWrap)
            make.left.equalTo(bottomWrap).offset(kConstraints.depositBtnMargin)
            make.height.equalTo(kConstraints.depositBtnHeight)
        }
        
        withdrawBtn.snp_makeConstraints { (make) -> Void in
            
            make.left.equalTo(depositBtn.snp_right).offset(kConstraints.depositBtnMargin)
            make.right.equalTo(bottomWrap).offset(-kConstraints.depositBtnMargin)
            make.top.bottom.width.equalTo(depositBtn)
        }
        
    }
    
    private func makeCustomView(title: String) -> UIView {
        
        let contentView = UIView(bgColor: UIColor.whiteColor())
        
        let wrap = UIView(bgColor: UIColor.orangeColor())
        
        contentView.addSubview(wrap)
        wrap.snp_makeConstraints { (make) -> Void in
            
            make.top.equalTo(contentView).offset(xx_height(20))
            make.centerX.equalTo(contentView)
        }
        
        let textLabel = UILabel(title: title, fontColor: xx_colorWithHex(hexValue: 0x333333), bgColor: nil, fontSize: 14, maxWrapWidth: 0)
        let unitLabel = UILabel(title: "(元)", fontColor: xx_colorWithHex(hexValue: 0x333333), bgColor: nil, fontSize: 10, maxWrapWidth: 0)
        
        wrap.addSubview(textLabel)
        
        textLabel.snp_makeConstraints { (make) -> Void in
            
            make.top.left.equalTo(wrap)
        }
        
        wrap.addSubview(unitLabel)
        unitLabel.snp_makeConstraints { (make) -> Void in
            
            make.left.equalTo(textLabel.snp_right)
            make.bottom.equalTo(textLabel).offset(-2)
            make.right.equalTo(wrap)
        }
        return contentView
    }
    
    
    lazy var availableNumLabel = UILabel(title: "0.00", fontColor: xx_colorWithHex(hexValue: 0x333333), bgColor: nil, fontSize: 14, maxWrapWidth: 0)
    lazy var freezeNumLabel = UILabel(title: "0.00", fontColor: xx_colorWithHex(hexValue: 0x333333), bgColor: nil, fontSize: 14, maxWrapWidth: 0)
    lazy var stayNumLabel = UILabel(title: "0.00", fontColor: xx_colorWithHex(hexValue: 0x333333), bgColor: nil, fontSize: 14, maxWrapWidth: 0)
    
    lazy var myBidBtn: UIButton = {
        
        return CustomButton(title: "我的投资", image: UIImage(named: "me_invest")!)
    }()
    
    lazy var myBillBtn: UIButton = {
        
        return CustomButton(title: "我的账单", image: UIImage(named: "me_bill")!)
    }()
    
    lazy var myAccountBtn: UIButton = {
        
        return CustomButton(title: "我的账户", image: UIImage(named: "me_account")!)
    }()

    internal lazy var depositBtn = UIButton(title: "充值",
                                       titleColor: kConstraints.titleColor,
                                        titleSize: kConstraints.titleSize,
                                          bgColor: kConstraints.depositBtnBgColor)
    
    internal lazy var withdrawBtn = UIButton(title: "提现",
                                        titleColor: kConstraints.titleColor,
                                         titleSize: kConstraints.titleSize,
                                           bgColor: kConstraints.withdrawBtnBgColor)
}


private class CustomButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView?.contentMode = .Center
        titleLabel?.textAlignment = .Center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
        
        let titleX: CGFloat = 0.0
        let titleY: CGFloat = contentRect.size.height * 0.35
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

extension CustomButton {
    
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