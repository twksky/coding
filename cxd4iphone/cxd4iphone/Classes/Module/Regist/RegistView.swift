//
//  RegistStepTwoView.swift
//  cxd4iphone
//
//  Created by hexy on 12/8/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit

class RegistView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeUI() {
        
        let wrap = UIView()
        
        addSubview(wrap)
        wrap.snp_makeConstraints { (make) -> Void in
            
            make.edges.equalTo(UIEdgeInsetsMake(15, 20, -15, -20))
        }
        
        wrap.addSubview(userNameTextField)
        userNameTextField.snp_makeConstraints { (make) -> Void in
            
            make.top.left.right.equalTo(wrap)
            make.height.equalTo(xx_height(40))
        }
        
        wrap.addSubview(passwdTextField)
        passwdTextField.snp_makeConstraints { (make) -> Void in
            
            make.left.right.height.equalTo(userNameTextField)
            make.top.equalTo(userNameTextField.snp_bottom).offset(15)
        }
        
        wrap.addSubview(refferPhoneTextField)
        refferPhoneTextField.snp_makeConstraints { (make) -> Void in
            
            make.left.right.height.equalTo(passwdTextField)
            make.top.equalTo(passwdTextField.snp_bottom).offset(15)
        }

        wrap.addSubview(registBtn)
        registBtn.snp_makeConstraints { (make) -> Void in
            
            make.top.equalTo(refferPhoneTextField.snp_bottom).offset(xx_height(20))
            make.left.right.equalTo(wrap)
            make.height.equalTo(xx_height(40))
        }
    }
    
    lazy var userNameTextField = UITextField(placeholder: "输入用户名", leftImage: UIImage(named: "auth_username")!, keyboardType:.Default)
    lazy var passwdTextField = UITextField(placeholder: "请您输入8-20位的登录密码", leftImage: UIImage(named: "auth_check")!, keyboardType:.Default)
    lazy var refferPhoneTextField = UITextField(placeholder: "邀请人手机号码(可选)", leftImage: UIImage(named: "auth_tele")!, keyboardType:.NumberPad)
    lazy var registBtn = UIButton(title: "注 册", titleColor: UIColor.whiteColor(), titleSize: 18, bgColor: xx_colorWithHex(hexValue: 0x3d64b4))
    
}
