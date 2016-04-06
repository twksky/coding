//
//  TYFindPasswordViewController.swift
//  DaBai
//
//  Created by BaiTianWei on 15/5/28.
//  Copyright (c) 2015年 BaiTianWei. All rights reserved.
//

import UIKit

class TYFindPasswordViewController: TYBaseViewController {
    /// 键盘frame
    var keyboardRect:CGRect?
    /// 触发键盘事件的textFiled
    var currentTextField:UITextField?
    @IBOutlet weak var telTextField: UITextField!
    @IBOutlet weak var verificationCodeTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var password2TextField: UITextField!
    @IBOutlet weak var commitButton: UIButton!
    @IBOutlet weak var getVerificationCodeButton: UIButton!
    @IBOutlet weak var backgrounView: UIView!
    @IBAction func commit(sender: UIButton) {
        
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
            self.commitPost()
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
    /**
    配置键盘的通知
    */
    private func configurationKeyboardNotification(){
        // MARK: - 注册键盘通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    /**
    修改密码
    */
    private func commitPost(){
        let handler = TYBaseHandler(API: TYAPI_FIND_PASSWORD)
        handler.executeTaskWithSVProgressHUD(["userTel":telTextField.text,"userPassword":passwordTextField.text,"checkCode":verificationCodeTextField.text], callBackData: { (callBackData) -> Void in
            SVProgressHUD.showSuccessWithStatus("修改密码成功")
            self.navigationController?.popViewControllerAnimated(true)
            }, failed: nil)
    }
    /**
    配置视图
    */
    private func configurationView(){
        self.backgrounView.layer.cornerRadius = 8
        self.backgrounView.layer.masksToBounds = true
        self.commitButton.layer.cornerRadius = 4
        self.commitButton.layer.masksToBounds = true
        self.getVerificationCodeButton.layer.cornerRadius = 4
        self.getVerificationCodeButton.layer.masksToBounds = true
    }
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configurationView()
        self.configurationKeyboardNotification()
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.currentTextField?.resignFirstResponder()
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
