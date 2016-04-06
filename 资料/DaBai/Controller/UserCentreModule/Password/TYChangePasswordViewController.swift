//
//  TYChangePasswordViewController.swift
//  DaBai
//
//  Created by BaiTianWei on 15/6/3.
//  Copyright (c) 2015年 BaiTianWei. All rights reserved.
//

import UIKit

class TYChangePasswordViewController: UIViewController,UITextFieldDelegate {
    /// 键盘frame
    var keyboardRect:CGRect?
    /// 触发键盘事件的textFiled
    var currentTextField:UITextField?
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var commitButton: UIButton!
    @IBOutlet weak var originalPasswordTextField: UITextField!
    
    @IBOutlet weak var newPasswordTextField: UITextField!

    @IBOutlet weak var newPasswordTextField2: UITextField!
    @IBAction func submit(sender: UIButton) {
        if originalPasswordTextField.text.isEmpty {
            SVProgressHUD.showErrorWithStatus("请输入原密码")
            return
        }
        if newPasswordTextField.text.isEmpty {
            SVProgressHUD.showErrorWithStatus("请输入新密码")
            return
        }
        if newPasswordTextField2.text.isEmpty {
            SVProgressHUD.showErrorWithStatus("请再次输入新密码")
            return
        }
        if newPasswordTextField.text != newPasswordTextField2.text {
            SVProgressHUD.showErrorWithStatus("两次输入的密码不同")
            return
        }
        let handler = TYBaseHandler(API: TYAPI_UPDATE_PASSWORD)
        let parameter = [
            "userId":TYDoctorInformationStorage.doctorInformation().userId,
            "userTel":TYDoctorInformationStorage.doctorInformation().userTel,
            "oldUserPassword":originalPasswordTextField.text,
            "userPassword":newPasswordTextField.text]
        handler.executeTaskWithSVProgressHUD(parameter, callBackData: { (callBackData) -> Void in
            SVProgressHUD.showSuccessWithStatus("操作成功")
            self.navigationController?.popViewControllerAnimated(true)
        }, failed: nil)
    }
    // MARK: - 键盘出现和消失时调动的函数
    func keyboardWillShow(aNotification:NSNotification) {
        let userInfo:NSDictionary = aNotification.userInfo!
        self.keyboardRect = userInfo.objectForKey(UIKeyboardFrameEndUserInfoKey)?.CGRectValue()
        if (self.currentTextField != nil) {
            let height = self.keyboardRect!.origin.y - (self.backgroundView.frame.origin.y + self.currentTextField!.frame.size.height + self.currentTextField!.frame.origin.y)
            if height<0 {
                self.backgroundView.transform = CGAffineTransformMakeTranslation(0, height)
            }
        }
    }
    func keyboardWillHide(aNotification:NSNotification) {
        self.backgroundView.transform = CGAffineTransformMakeTranslation(0, 0)
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
    配置视图
    */
    private func configurationView(){
        self.commitButton.layer.cornerRadius = 4
        self.commitButton.layer.masksToBounds = true
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
