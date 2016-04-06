//
//  TYLoginViewController.swift
//  DaBai
//
//  Created by BaiTianWei on 15/5/22.
//  Copyright (c) 2015年 BaiTianWei. All rights reserved.
//

import UIKit
class TYLoginViewController: TYBaseViewController{
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registButton: UIButton!
    @IBOutlet weak var findPasswordButton: UIButton!
    @IBAction func login(sender: AnyObject) {
        if self.usernameTextField.text.isEmpty {
            SVProgressHUD.showErrorWithStatus("请输入用户名")
        }else if self.passwordTextField.text.isEmpty {
            SVProgressHUD.showErrorWithStatus("请输入密码")
        }else {
            self.loginPost()
        }
    }
    /**
    登陆请求
    */
    private func loginPost() {
        let handler = TYBaseHandler(API: TYAPI_LOGIN)
        SVProgressHUD.showWithStatus("正在登陆")
        var parameter:[String:AnyObject] = ["mUserName":usernameTextField.text,"mPassWord":passwordTextField.text,"clientVersion":"1","equipmentType":2]
        
        if let deviceToken:String? = UserDefaultsUtils.valueWithKey("deviceToken") as? String {
            if deviceToken != nil {
                parameter.updateValue(deviceToken!, forKey: "equipmentNumber")
            }

        }
        
        handler.executeTaskWithSVProgressHUD(parameter, callBackData: { (callBackData) -> Void in
            SVProgressHUD.showSuccessWithStatus("登陆成功")
            self.handlerData(callBackData)
            self.setCookie()
            TYWebSocket.shared.openWebSocket()
        }, failed: nil)
    }
    /**
    设置cookie
    */
    private func setCookie() {
        var cookies = [[String:NSObject]]()
        let cookieJar = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in cookieJar.cookies as! [NSHTTPCookie] {
            var cookieProperties = [NSHTTPCookieName:cookie.name,NSHTTPCookieExpires:NSDate(timeIntervalSinceNow: 60*60*24*7),NSHTTPCookieDomain:cookie.domain]
            if cookie.path != nil {
                cookieProperties.updateValue(cookie.path!, forKey: NSHTTPCookieValue)
            }
            if cookie.value != nil {
                cookieProperties.updateValue(cookie.value!, forKey: NSHTTPCookieValue)
            }
            if cookie.path != nil {
                cookieProperties.updateValue(cookie.path!, forKey: NSHTTPCookiePath)
            }
            cookies.append(cookieProperties)
        }
        for cookie in cookieJar.cookies as! [NSHTTPCookie] {
            cookieJar.deleteCookie(cookie)
        }
        for cookieProperties in cookies {
            var cookie = NSHTTPCookie(properties: cookieProperties)
            if cookie != nil {
                NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookie(cookie!)
            }
        }
        
    }
    /**
    处理数据
    
    :param: data 数据
    */
    private func handlerData(data:AnyObject){
        if let sysConfigData = data["sysConfig"] as? [NSObject:AnyObject]    {
            TYSysConfigStorage.saveSysConfig(sysConfigData)
        }
        if let doctorData = data["dcDoctor"] as? [NSObject:AnyObject] {
            TYDoctorInformationStorage.saveDoctorInformation(doctorData)
        }
        self.handlerDic()
        self.pushNextViewController()
        
    }
    private func handlerDic(){
        if TYDicStorage.dicList() == nil {
            TYDicStorage.updateDicList()
        }
        
    }
    private func pushNextViewController(){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        if let nextViewController = mainStoryboard.instantiateViewControllerWithIdentifier("MainTabBarController") as? UITabBarController {
            nextViewController.selectedIndex = 2
            self.presentViewController(nextViewController, animated: true, completion: nil)
        }
    }
    /**
    配置视图
    */
    private func configurationView(){
        
        self.usernameTextField.leftViewMode = UITextFieldViewMode.Always
        self.passwordTextField.leftViewMode = UITextFieldViewMode.Always
        
        let phoneicon = UIImageView(image: UIImage(named: "login_phone_textfield_icon"))
        phoneicon.frame = CGRectMake(0, 0, 30, 30)
        phoneicon.contentMode = UIViewContentMode.Center
        
        let passwordicon = UIImageView(image: UIImage(named: "login_password_textfield_icon"))
        passwordicon.frame = CGRectMake(0, 0, 30, 30)
        passwordicon.contentMode = UIViewContentMode.Center
        
        
        self.usernameTextField.leftView = phoneicon
        self.passwordTextField.leftView = passwordicon
        self.backgroundView.layer.cornerRadius = 8
        self.backgroundView.layer.masksToBounds = true
        self.loginButton.layer.cornerRadius = 4
        self.loginButton.layer.masksToBounds = true
        
        self.registButton.layer.cornerRadius = 4
        self.registButton.layer.masksToBounds = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configurationView()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.usernameTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
    }
}
