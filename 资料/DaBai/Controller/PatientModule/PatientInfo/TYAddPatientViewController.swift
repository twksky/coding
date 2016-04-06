//
//  TYAddPatientViewController.swift
//  DaBai
//
//  Created by BaiTianWei on 15/6/5.
//  Copyright (c) 2015年 BaiTianWei. All rights reserved.
//

import UIKit

class TYAddPatientViewController: UITableViewController {
    @IBOutlet weak var patientNameLabel: UILabel!
    @IBOutlet weak var patientBirthDateLabel: UILabel!
    @IBOutlet weak var patientSexLabel: UILabel!
    @IBOutlet weak var patientTelLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBAction func submit(sender: UIButton) {
        if patientNameLabel.text!.isEmpty {
            SVProgressHUD.showErrorWithStatus("请输入患者姓名")
            return
        }
        if patientBirthDateLabel.text!.isEmpty {
            SVProgressHUD.showErrorWithStatus("请输入患者出生日期")
            return
        }
        if patientSexLabel.text!.isEmpty {
            SVProgressHUD.showErrorWithStatus("请输入患者性别")
            return
        }
        if patientTelLabel.text!.isEmpty {
            SVProgressHUD.showErrorWithStatus("请输入患者手机号")
            return
        }
        let handelr = TYBaseHandler(API: TYAPI_ADD_PATIENT)
        
        var parameter:[String:AnyObject] = [
            "patientName":self.patientNameLabel.text!,
            "patientTel":self.patientTelLabel.text!,
            "patientBirthDate":self.patientBirthDateLabel.text!,
            "userId":TYDoctorInformationStorage.doctorInformation().userId,
            "userName":TYDoctorInformationStorage.doctorInformation().userName,
            "userTel":TYDoctorInformationStorage.doctorInformation().userTel,
            "workOrg":TYDoctorInformationStorage.doctorInformation().workOrg,
            "workDep":TYDoctorInformationStorage.doctorInformation().workDep,
            "workTitle":TYDoctorInformationStorage.doctorInformation().workTitle,
            "dcRole":TYDoctorInformationStorage.doctorInformation().dcRole,
            "headImg":TYDoctorInformationStorage.doctorInformation().headImg
        ]
        if patientSexLabel.text == "男" {
            parameter.updateValue("1", forKey: "patientSexId")
        }else if patientSexLabel.text == "女"{
            parameter.updateValue("2", forKey: "patientSexId")
        }
        handelr.executeTaskWithSVProgressHUD(parameter, callBackData: { (callBackData) -> Void in
            SVProgressHUD.showSuccessWithStatus("添加成功")
            if let patientId:Int? = callBackData.objectForKey("patientId") as? Int {
                let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                
                let nextViewController:TYPatientInfoViewController = storyboard.instantiateViewControllerWithIdentifier("TYPatientInfoViewController") as! TYPatientInfoViewController
                nextViewController.patientId = patientId
                self.navigationController?.pushViewController(nextViewController, animated: true)
            }
        }, failed: nil)
    }
    /**
    配置视图
    */
    private func configurationView(){
        self.titleLabel.layer.cornerRadius = 8
        self.titleLabel.layer.masksToBounds = true
        self.submitButton.layer.cornerRadius = 8
        self.submitButton.layer.masksToBounds = true

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configurationView()
    }
    //MARK: - UITextFieldDelegate
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        self.patientNameLabel.resignFirstResponder()
        self.patientTelLabel.resignFirstResponder()
        if textField == self.patientSexLabel {
            let alertController = UIAlertController(title: "选择性别", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            let manAction = UIAlertAction(title: "男", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                self.patientSexLabel.text = "男"
                
            })
            let womanAction = UIAlertAction(title: "女", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                self.patientSexLabel.text = "女"
                
            })
            alertController.addAction(manAction)
            alertController.addAction(womanAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return false
        }
        if textField == self.patientBirthDateLabel {
            let pickerDate = UIDatePicker()
            pickerDate.locale = NSLocale(localeIdentifier: "Chinese")
            pickerDate.datePickerMode = UIDatePickerMode.Date
            let title = "\n\n\n\n\n\n\n\n\n\n\n"
            let alertController = UIAlertController(title: title, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            let certainAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default) { (action) -> Void in
                let formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                self.patientBirthDateLabel.text = formatter.stringFromDate(pickerDate.date)
            }
            alertController.addAction(certainAction)
            alertController.view.addSubview(pickerDate)
            self.presentViewController(alertController, animated: true, completion: nil)
            return false
        }
        return true
    }
}
