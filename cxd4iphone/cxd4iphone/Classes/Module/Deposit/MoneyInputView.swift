//
//  MoneyInputView.swift
//  cxd4iphone
//
//  Created by hexy on 12/21/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit

class MoneyInputView: UIView {

    private var _balance: String = "0.00"
    private var _isDeposit: Bool = true
    
    init(balance: String, isDeposit: Bool) {
        
        super.init(frame: CGRectMake(0, 0, xx_screenWidth(), xx_height(115)))
        
        _balance = balance
        _isDeposit = isDeposit
        makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeUI() {
        
//        let wrap = UIView(bgColor: xx_randomColor())
        let wrap = UIView()
        
        addSubview(wrap)
        wrap.snp_makeConstraints { (make) -> Void in
            
            make.edges.equalTo(UIEdgeInsetsMake(xx_height(20), 15, xx_height(-20), -15))
        }
        
        let title = UILabel(title: "诚信贷账户可用余额（元）", fontColor: Define.moreLightFontColor, bgColor: nil, fontSize: 14, maxWrapWidth: 0)
        
        wrap.addSubview(title)
        title.snp_makeConstraints { (make) -> Void in
            
            make.top.left.equalTo(wrap)
        }
        
        let balance = UILabel(title: _balance, fontColor: Define.redColor, bgColor: nil, fontSize: 18, maxWrapWidth: 0)
        
        wrap.addSubview(balance)
        balance.snp_makeConstraints { (make) -> Void in
            
            make.right.equalTo(wrap)
            make.centerY.equalTo(title)
        }
        
        wrap.addSubview(textField)
        let placeholder = _isDeposit ? "请输入充值金额（元）" : "请输入提现金额（元）"
        textField.placeholder = placeholder
       
        textField.snp_makeConstraints { (make) -> Void in
            
            make.top.equalTo(title.snp_bottom).offset(xx_height(10))
            make.left.right.equalTo(wrap)
            make.height.equalTo(xx_height(40))
        }
    }
    
    lazy var textField = UITextField(placeholder: nil, textAlignment: .Left, keyboardType: .NumbersAndPunctuation)

    
}
