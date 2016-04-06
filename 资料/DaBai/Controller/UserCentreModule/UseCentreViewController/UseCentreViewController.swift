//
//  UseCentreViewController.swift
//  DaBai
//
//  Created by BaiTianWei on 15/5/29.
//  Copyright (c) 2015年 BaiTianWei. All rights reserved.
//

import UIKit

class UseCentreViewController: UITableViewController {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var workOrgLabel: UILabel!
    @IBOutlet weak var workDepLabel: UILabel!
    @IBOutlet weak var workTitleLabel: UILabel!
    @IBOutlet weak var userHeadImageView: UIImageView!
    @IBOutlet weak var imageOrderStateSwitch: UISwitch!
    @IBOutlet weak var telOrderStateSwitch: UISwitch!
    @IBOutlet weak var videoOrderStateSwitch: UISwitch!
    @IBOutlet weak var logoutButton: UIButton!
    @IBAction func changeDoctorOrderState(sender: UISwitch) {
        let imgOrderState = self.imageOrderStateSwitch.on ? "1" : "2"
        let telOrderState = self.telOrderStateSwitch.on ? "1" : "2"
        let videoOrderState = self.videoOrderStateSwitch.on ? "1" : "2"
        let handler = TYDoctorUpdateOrderStateHandler()
        handler.executeDoctorUpdateOrderStateTask(imgOrderState, telOrderState: telOrderState, videoOrderState: videoOrderState, success: { (operation, responseObject) -> Void in
            
            if let resultFlag = responseObject["optFlag"] as? Bool {
                if !resultFlag {
                    let message = responseObject["message"] as? String
                    SVProgressHUD.showErrorWithStatus(message)
                    sender.on = !sender.on
                    
                    if message == "登录过期,请重新登录!" || message == "请登录后再操作!" {
                        //重新登录
                        let cookieJar = NSHTTPCookieStorage.sharedHTTPCookieStorage()
                        for cookie in cookieJar.cookies as! [NSHTTPCookie] {
                            cookieJar.deleteCookie(cookie)
                        }
                        
                        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                        let nextViewController = mainStoryboard.instantiateInitialViewController() as! UIViewController
                        self.presentViewController(nextViewController, animated: true, completion: nil)
                    }
                }else {
                    SVProgressHUD.showSuccessWithStatus("操作成功")
                    TYDoctorInformationStorage.refreshInformation(nil)
                }
            }else{
                
                SVProgressHUD.showErrorWithStatus("数据解析失败")
                sender.on = !sender.on
            }
        }) { (operation, error) -> Void in
            println(error)
            SVProgressHUD.showErrorWithStatus("服务器连接失败")
            sender.on = !sender.on
        }

    }
    
    @IBAction func logout(sender: UIButton) {
        let alert = UIAlertController(title: "注销登录" , message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let logoutAction = UIAlertAction(title: "注销", style: UIAlertActionStyle.Destructive) { (action) -> Void in
//            清除cookie
            let cookieJar = NSHTTPCookieStorage.sharedHTTPCookieStorage()
            for cookie in cookieJar.cookies as! [NSHTTPCookie] {
                cookieJar.deleteCookie(cookie)
            }
//            logout post
            let handler = TYBaseHandler(API: TYAPI_LOGOUT)
            handler.executeTask(nil, success: nil, failed: nil)
//            退回登录界面
            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let nextViewController = mainStoryboard.instantiateInitialViewController() as! UIViewController
            self.presentViewController(nextViewController, animated: true, completion: nil)
        }
        alert.addAction(logoutAction)
        alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil))
        var popVer = alert.popoverPresentationController
        if popVer != nil {
            popVer?.sourceRect = sender.bounds
            popVer?.sourceView = sender
            popVer?.permittedArrowDirections = UIPopoverArrowDirection.Any
        }
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    private func setInformation() {
        
        
        let doctorInformation = TYDoctorInformationStorage.doctorInformation()
        userNameLabel.text = doctorInformation.userName
        workDepLabel.text = doctorInformation.workDep
        if doctorInformation.workDep == "" {
            workDepLabel.text = doctorInformation.workBigDep
        }
        workTitleLabel.text = doctorInformation.workTitle
        workOrgLabel.text = doctorInformation.workOrg
        
        if doctorInformation.telOrderState == "1" {
            telOrderStateSwitch.on = true
        }else {
            telOrderStateSwitch.on = false
        }
        if doctorInformation.imgOrderState == "1" {
            imageOrderStateSwitch.on = true
        }else {
            imageOrderStateSwitch.on = false
        }
        if doctorInformation.videoOrderState == "1" {
            videoOrderStateSwitch.on = true
        }else {
            videoOrderStateSwitch.on = false
        }
        if doctorInformation.headImg != "" {
            let handler = TYOssDownloadHandler(key: doctorInformation.headImg)
            handler.getdata { (data, error) -> Void in
                if data != nil {
                    let downloadImage = UIImage(data: data)
                    self.userHeadImageView.image = downloadImage!
                }
            }
        }
    }
    /**
    配置视图
    */
    private func configurationView(){
        self.logoutButton.layer.cornerRadius = 8
        self.logoutButton.layer.masksToBounds = true
        self.userHeadImageView.layer.cornerRadius = self.userHeadImageView.bounds.width/2
        self.userHeadImageView.layer.masksToBounds = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configurationView()
        self.setInformation()
        
    }
    override func viewWillAppear(animated: Bool) {
        TYDoctorInformationStorage.refreshInformation { () -> Void in
            self.setInformation()
        }
    }
}
