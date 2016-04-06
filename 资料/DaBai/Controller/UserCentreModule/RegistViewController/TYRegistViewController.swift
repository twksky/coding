//
//  TYRegistViewController.swift
//  DaBai
//
//  Created by BaiTianWei on 15/5/22.
//  Copyright (c) 2015年 BaiTianWei. All rights reserved.
//

import UIKit

class TYRegistViewController: TYBaseViewController,UITextFieldDelegate {

    @IBOutlet weak var telTextField: UITextField!
    @IBOutlet weak var verificationCodeTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var password2TextField: UITextField!
    @IBOutlet weak var registButton: UIButton!
    @IBOutlet weak var getVerificationCodeButton: UIButton!
    @IBOutlet weak var backgrounView: UIView!
    /// 键盘frame
    private var keyboardRect:CGRect?
    /// 触发键盘事件的textFiled
    private var currentTextField:UITextField?
    
    @IBAction func regist(sender: UIButton) {
        
        if self.telTextField.text.isEmpty{
            SVProgressHUD.showErrorWithStatus("请输入手机号")
        }else if !(TYAppUtils.checkPhoneNumber(self.telTextField.text)){
            SVProgressHUD.showErrorWithStatus("请输入正确的手机号")
        }else if self.verificationCodeTextField.text.isEmpty{
            SVProgressHUD.showErrorWithStatus("请输入校检码")
        }else if self.passwordTextField.text.isEmpty {
            SVProgressHUD.showErrorWithStatus("请输入密码")
        }else if self.password2TextField.text.isEmpty {
            SVProgressHUD.showErrorWithStatus("请输入密码")
        }else if self.passwordTextField.text != self.password2TextField.text{
            SVProgressHUD.showErrorWithStatus("两次输入的密码不同")
        }else {
            self.registPost()
        }
    }
    @IBAction func getVerificationCode(sender: UIButton) {
        if telTextField.text.isEmpty {
            SVProgressHUD.showErrorWithStatus("请输入手机号")
        }else {
            let handler = TYBaseHandler(API: TYAPI_GET_SMS_VERITY_CODE)
            handler.executeTaskWithSVProgressHUD(["userTel":telTextField.text], callBackData: { (callBackData) -> Void in
                SVProgressHUD.showSuccessWithStatus("操作成功")
                }, failed: nil)
        }
    }
    
    /**
    注册请求
    */
    private func registPost(){
        let handler = TYBaseHandler(API: TYAPI_REGIST)
        SVProgressHUD.showWithStatus("正在注册")
        handler.executeTaskWithSVProgressHUD(["userTel":telTextField.text,"checkCode":verificationCodeTextField.text,"userPassword":passwordTextField.text,"loginName":telTextField.text], callBackData: { (callBackData) -> Void in
            //注册成功
            SVProgressHUD.showSuccessWithStatus("注册成功")
            //登陆
            self.login()
            

        }, failed: nil)
    }
    private func login() {
        let handler = TYBaseHandler(API: TYAPI_LOGIN)
        handler.executeTaskWithSVProgressHUD(["mUserName":telTextField.text,"mPassWord":passwordTextField.text,"clientVersion":"1","PhoneType":2], callBackData: { (callBackData) -> Void in
            self.handlerData(callBackData)
            }, failed: nil)
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
        self.pushNextViewController()
        
    }
    private func pushNextViewController() {
        SVProgressHUD.showSuccessWithStatus("登陆成功")
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let nextViewController = mainStoryboard.instantiateViewControllerWithIdentifier("TYBaseInformationTableViewController") as! TYBaseInformationTableViewController
        nextViewController.isUserCenter = false
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }

    /**
    配置视图
    */
    private func configurationView(){
        self.backgrounView.layer.cornerRadius = 8
        self.backgrounView.layer.masksToBounds = true
        self.registButton.layer.cornerRadius = 4
        self.registButton.layer.masksToBounds = true
        self.getVerificationCodeButton.layer.cornerRadius = 4
        self.getVerificationCodeButton.layer.masksToBounds = true
    }
    override func viewDidLoad() {
        self.configurationView()
        self.configurationKeyboardNotification()
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.currentTextField?.resignFirstResponder()
    }
    
    
    /**
    配置键盘的通知
    */
    func configurationKeyboardNotification(){
        // MARK: - 注册键盘通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - 键盘出现和消失时调动的函数
    func keyboardWillShow(aNotification:NSNotification) {
        let userInfo:NSDictionary = aNotification.userInfo!
        self.keyboardRect = userInfo.objectForKey(UIKeyboardFrameEndUserInfoKey)?.CGRectValue()
        if (self.currentTextField != nil) {
            let height = self.keyboardRect!.origin.y - (self.backgrounView.frame.origin.y + self.currentTextField!.frame.size.height + self.currentTextField!.frame.origin.y)
            if height<0 {
                self.backgrounView.transform = CGAffineTransformMakeTranslation(0, height)
                
            }
        }
    }
    func keyboardWillHide(aNotification:NSNotification) {
        self.backgrounView.transform = CGAffineTransformMakeTranslation(0, 0)
    }
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        self.currentTextField = textField
    }
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        self.currentTextField = nil
        return true
    }
}
