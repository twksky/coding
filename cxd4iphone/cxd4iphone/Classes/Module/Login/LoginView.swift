//
//  LoginView.swift
//  cxd4iphone
//
//  Created by hexy on 12/9/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit
import ReactiveCocoa

class LoginView: UIView {

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
        
        wrap.addSubview(loginNameTextField)
        loginNameTextField.snp_makeConstraints { (make) -> Void in
            
            make.top.left.right.equalTo(wrap)
            make.height.equalTo(xx_height(40))
        }
        
        wrap.addSubview(loginPasswdTextField)
        loginPasswdTextField.snp_makeConstraints { (make) -> Void in
            
            make.left.right.height.equalTo(loginNameTextField)
            make.top.equalTo(loginNameTextField.snp_bottom).offset(15)
        }
        

        wrap.addSubview(loginBtn)
       
        loginBtn.snp_makeConstraints { (make) -> Void in
            
            make.top.equalTo(loginPasswdTextField.snp_bottom).offset(xx_height(20))
            make.left.right.equalTo(wrap)
            make.height.equalTo(xx_height(40))
        }
        
        wrap.addSubview(forgotPasswdBtn)
        forgotPasswdBtn.snp_makeConstraints { (make) -> Void in
            
            make.top.equalTo(loginBtn.snp_bottom).offset(xx_height(-1))
            make.right.equalTo(loginBtn)
        }
        
    }
    
    lazy var loginNameTextField = UITextField(placeholder: "请输入您的用户名或手机号", leftImage: UIImage(named: "auth_username")!, keyboardType:.Default)
    lazy var loginPasswdTextField: UITextField = {
        
        let tf = UITextField(placeholder: "请输入密码", leftImage: UIImage(named: "auth_check")!, keyboardType:.Default)
        
        let eyeableBtn = UIButton(frame: CGRectMake(0, 0, 30, 38))
        
        eyeableBtn.setImage(UIImage(named: "auth_uneyeable"), forState: .Normal)
        eyeableBtn.setImage(UIImage(named: "auth_eyeable"), forState: .Selected)
        eyeableBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (sender) -> Void in
            
            (sender as! UIButton).selected = !(sender as! UIButton).selected
            tf.secureTextEntry = !(sender as! UIButton).selected
        })
        
        tf.rightViewMode = .UnlessEditing
        tf.rightView = eyeableBtn
        tf.secureTextEntry = true
        return tf
    }()
    lazy var loginBtn: UIButton = {
        
        let btn = UIButton(title: "登 录", titleColor: UIColor.whiteColor(), titleSize: 18, bgColor: Define.blueColor)
        btn.setBackgroundImage(UIImage.createImgaeWithColor(Define.grayColor), forState: .Disabled)
        
        RACSignal.combineLatest([self.loginNameTextField.rac_textSignal(), self.loginPasswdTextField.rac_textSignal()]).map { (tuple) -> AnyObject! in
            
                let tuple = tuple as! RACTuple
                return Bool((tuple.first as! NSString).length > 0) && Bool((tuple.second as! NSString).length)
            
            }.subscribeNext { (enable) -> Void in
                
                btn.enabled =  (enable as! Bool)
        }

        return btn
    }()
    lazy var forgotPasswdBtn = UIButton(title: "忘记密码?", titleColor: Define.moreLightFontColor, titleSize: 12, bgColor: UIColor.clearColor())
    
}


//        let mailPattern = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
//
//        let matcher = RegexHelper(mailPattern)
//        let maybeMailAddress = "onev@onevcat.cn"
//
//        if matcher.match(maybeMailAddress) {
//
//            xx_print("有效的邮箱地址")
//        }
//
////
//
//        let phonePattern = "^1[3|4|5|7|8][0-9]\\d{8}$"
//
//        let matchers = RegexHelper(phonePattern)
//        let maybePhone = "13000000000"
//
//        if matchers.match(maybePhone) {
//
//            xx_print("有效的手机号码")
//        }

