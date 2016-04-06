//
//  ChargeSettingViewController.swift
//  DaBai
//
//  Created by BaiTianWei on 15/6/3.
//  Copyright (c) 2015年 BaiTianWei. All rights reserved.
//

import UIKit

class ChargeSettingViewController: UITableViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var imageOrderPriceLabel: UILabel!
    @IBOutlet weak var videoOrderPriceLabel: UILabel!

    @IBOutlet weak var telOrderOriceLabel: UILabel!
    @IBOutlet weak var followUpPriceLabel: UILabel!
    @IBAction func submit(sender: AnyObject) {
        let handler = TYDoctorUpdateOrderPriceHandler()
        handler.executeDoctorUpdateOrderPriceTask(imageOrderPriceLabel.text, telOrderPrice: telOrderOriceLabel.text, videoOrderPrice: videoOrderPriceLabel.text, followUpPrice: followUpPriceLabel.text, success: { (operation, responseObject) -> Void in
            if let resultFlag = responseObject["optFlag"] as? Bool {
                if !resultFlag {
                    let message = responseObject["message"] as? String
                    SVProgressHUD.showErrorWithStatus(message)
                }else {
                    SVProgressHUD.showSuccessWithStatus("修改成功")
                    let data:AnyObject! = responseObject["data"]
                }
            }else{
                
                SVProgressHUD.showErrorWithStatus("数据解析失败")
            }
        }) { (operation, error) -> Void in
            SVProgressHUD.showErrorWithStatus("服务器连接失败")

        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let alertController = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addTextFieldWithConfigurationHandler(nil)
        let certainAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default) { (action) -> Void in
            let textField:UITextField? = alertController.textFields?.first as? UITextField
            
            switch indexPath.row {
            case 0:
                self.imageOrderPriceLabel.text = textField?.text
            case 1:
                self.videoOrderPriceLabel.text = textField?.text
            case 2:
                self.telOrderOriceLabel.text = textField?.text
            case 3:
                self.followUpPriceLabel.text = textField?.text
            default:
                break
            }
            
        }
        alertController.addAction(certainAction)
        self.presentViewController(alertController, animated: true, completion: nil)

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
    private func setInformation(){
        let doctorInformation = TYDoctorInformationStorage.doctorInformation()
        imageOrderPriceLabel.text = "\(doctorInformation.imgOrderPrice)"
        videoOrderPriceLabel.text = "\(doctorInformation.videoOrderPrice)"
        telOrderOriceLabel.text = "\(doctorInformation.telOrderPrice)"
        followUpPriceLabel.text = "\(doctorInformation.followUpPrice)"
        
    }
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        self.configurationView()
        TYDoctorInformationStorage.refreshInformation { () -> Void in
            self.setInformation()
        }
    }

}
