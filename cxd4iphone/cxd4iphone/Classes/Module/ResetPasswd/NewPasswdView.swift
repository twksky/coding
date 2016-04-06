//
//  NewPasswdView.swift
//  cxd4iphone
//
//  Created by hexy on 12/9/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit

class NewPasswdView: UIView {

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
        
        wrap.addSubview(newPasswdTextField)
        newPasswdTextField.snp_makeConstraints { (make) -> Void in
            
            make.top.left.right.equalTo(wrap)
            make.height.equalTo(xx_height(40))
        }
        
        wrap.addSubview(sureBtn)
        sureBtn.snp_makeConstraints { (make) -> Void in
            
            make.top.equalTo(newPasswdTextField.snp_bottom).offset(xx_height(20))
            make.left.right.equalTo(wrap)
            make.height.equalTo(xx_height(40))
        }
    }
    lazy var newPasswdTextField = UITextField(placeholder: "请输入新密码", leftImage: UIImage(named: "auth_check")!, keyboardType:.Default)
    lazy var sureBtn = UIButton(title: "确  定", titleColor: UIColor.whiteColor(), titleSize: 18, bgColor: xx_colorWithHex(hexValue: 0x3d64b4))
    
}
