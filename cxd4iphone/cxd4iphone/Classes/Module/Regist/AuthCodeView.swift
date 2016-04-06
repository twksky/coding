//
//  RegistStepOneView.swift
//  cxd4iphone
//
//  Created by hexy on 12/8/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit

class AuthCodeView: UIView {

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeUI() {
        
//        let wrap = UIView(bgColor: UIColor.orangeColor())
        let wrap = UIView()
        
        addSubview(wrap)
        wrap.snp_makeConstraints { (make) -> Void in
            
            make.edges.equalTo(UIEdgeInsetsMake(15, 20, -15, -20))
        }
        
        wrap.addSubview(telePhoneTextField)
        telePhoneTextField.snp_makeConstraints { (make) -> Void in
            
            make.top.left.right.equalTo(wrap)
            make.height.equalTo(xx_height(40))
        }
        
        wrap.addSubview(checkBtn)
        checkBtn.snp_makeConstraints { (make) -> Void in
            
            make.top.equalTo(telePhoneTextField.snp_bottom).offset(xx_height(15))
            make.right.equalTo(wrap)
            make.height.equalTo(xx_height(40))
            make.width.equalTo(xx_width(90))
        }
        
        wrap.addSubview(checkCodeTextField)
        checkCodeTextField.snp_makeConstraints { (make) -> Void in
            
            make.left.equalTo(wrap)
            make.top.height.equalTo(checkBtn)
            make.right.equalTo(checkBtn.snp_left).offset(xx_width(-10))
        }

        wrap.addSubview(nextStepBtn)
        nextStepBtn.snp_makeConstraints { (make) -> Void in
            
            make.top.equalTo(checkCodeTextField.snp_bottom).offset(xx_height(20))
            make.left.right.equalTo(wrap)
            make.height.equalTo(xx_height(40))
        }
        
    }
    
    lazy var telePhoneTextField: UITextField = {
        
        let teleTF = UITextField(placeholder: "请您输入手机号码", leftImage: UIImage(named: "auth_tele")!, keyboardType:.NumberPad)
        
        teleTF.rac_textSignal().subscribeNext({ (telePhoneNo) -> Void in
            
            self.checkBtn.enabled = false
            teleTF.layer.borderColor = Define.textFieldColor
            
            let telePhoneNoStr = telePhoneNo as! String
            let telePhoneNoLen = telePhoneNoStr.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
            
           
            if telePhoneNoLen >= 1 {
                
                if (telePhoneNo as! NSString).substringToIndex(1) != "1" {
                    
                    teleTF.layer.borderColor = UIColor.redColor().CGColor
                }
            }
            
            if telePhoneNoLen > 10 {
                
                if self.isValidPhoneNo(telePhoneNoStr) {
                    
                    self.checkBtn.enabled = true
                    
                } else {
                    
                    teleTF.layer.borderColor = UIColor.redColor().CGColor
                }
            }
            
        })
    
        return teleTF
    }()
    
    lazy var checkCodeTextField: UITextField = {
        
        let tf = UITextField(placeholder: "请输入手机验证码", leftImage: UIImage(named: "auth_check")!, keyboardType:.NumberPad)
        
        NSNotificationCenter.defaultCenter().rac_addObserverForName(UITextFieldTextDidEndEditingNotification, object: tf).takeUntil(self.rac_willDeallocSignal()).subscribeNext({ (note) -> Void in
            
            xx_print(note)
        })
        
        return tf
    }()
    
    lazy var checkBtn: UIButton = {
        let btn = UIButton(title: "获取验证码", titleColor: UIColor.whiteColor(), titleSize: 14, bgColor:Define.blueColor)
        btn.setBackgroundImage(UIImage.createImgaeWithColor(Define.grayColor), forState: .Disabled)
        btn.enabled = false
        return btn
    }()
   
    lazy var nextStepBtn: UIButton = {
        let btn = UIButton(title: "下一步", titleColor: UIColor.whiteColor(), titleSize: 14, bgColor:Define.blueColor)
        btn.setBackgroundImage(UIImage.createImgaeWithColor(Define.grayColor), forState: .Disabled)
        btn.enabled = false
        return btn
    }()
}

extension AuthCodeView {
    
    func isValidPhoneNo(phoneNo: String) -> Bool {
        
        let phonePattern = "^1[3|4|5|7|8][0-9]\\d{8}$"
        
        let matcher = RegexHelper(phonePattern)
        let maybePhone = phoneNo
        
        return matcher.match(maybePhone)
    }
}
