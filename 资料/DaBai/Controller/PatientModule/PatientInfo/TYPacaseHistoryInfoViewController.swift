//
//  TYPacaseHistoryInfoViewController.swift
//  DaBai
//
//  Created by BaiTianWei on 15/6/8.
//  Copyright (c) 2015年 BaiTianWei. All rights reserved.
//

import UIKit

class TYPacaseHistoryInfoViewController: TYBaseViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var telLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var symptomTextView: UITextView!
    @IBOutlet weak var diacrisisTextView: UITextView!
    @IBOutlet weak var processTextView: UITextView!
    @IBOutlet weak var consultButton: UIButton!
    /// 患者ID
    var patientId:Int!
    /// 病历ID
    var caseId:Int!
    /// 患者姓名
    var patientName:String!
    /// 患者年龄
    var patientAge:String!
    /// 患者性别
    var patientSex:String!
    /// 患者手机号
    var patientTel:String!
    /// 咨询状态
    var consultState:String!
    /// 下载的数据
    private var data:AnyObject! {
        didSet {
            settingDownLoadInformation()
        }
    }
    
    @IBAction func submitConsult(sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        switch self.consultState {
        case "1":
            let nextViewController:TYDoctorListViewController = storyboard.instantiateViewControllerWithIdentifier("TYDoctorListViewController") as! TYDoctorListViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
        default:
            let nextViewController:TYSelectConsultViewController = storyboard.instantiateViewControllerWithIdentifier("TYSelectConsultViewController") as! TYSelectConsultViewController
            nextViewController.consultState = self.consultState
            self.navigationController?.pushViewController(nextViewController, animated: true)
            break
        }
        
    }
    
    private func settingInformation(){
        self.downLoadData()
        self.nameLabel.text = self.patientName
        self.ageLabel.text = self.patientAge
        self.telLabel.text = self.patientTel
        switch self.consultState {
        case "1":
            self.consultButton.setTitle("提交咨询", forState: UIControlState.Normal)
        default:
            self.consultButton.setTitle("进入咨询", forState: UIControlState.Normal)
        }
    }
    private func settingDownLoadInformation(){
        if let symptomText = data.objectForKey("symptomText") as? String {
            self.setTextView(self.symptomTextView, key: symptomText)
        }
        if let diacrisisText = data.objectForKey("diacrisisText") as? String{
            self.setTextView(self.diacrisisTextView, key: diacrisisText)
        }
        if let processText = data.objectForKey("processText") as? String{
            self.setTextView(self.processTextView, key: processText)
        }
    }
    private func setTextView(textView:UITextView,key:String) {
        let handler = TYOssDownloadHandler(key: key)
        handler.getText({ (text) -> Void in
            if text != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    textView.text = text
                })
            }
        })
    }
    private func downLoadData(){
        let handler = TYBaseHandler(API: TYAPI_GET_PACASEHISTORY_INFO)
        let parameter = ["patientId":self.patientId,"caseId":self.caseId]
        handler.executeTaskWithSVProgressHUD(parameter, callBackData: { (callBackData) -> Void in
            self.data = callBackData.objectAtIndex(0)
            }, failed: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.settingInformation()
    }
}
