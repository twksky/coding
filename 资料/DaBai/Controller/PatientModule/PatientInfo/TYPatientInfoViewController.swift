//
//  PatientInfoViewController.swift
//  DaBai
//
//  Created by BaiTianWei on 15/6/5.
//  Copyright (c) 2015年 BaiTianWei. All rights reserved.
//

import UIKit
class TYPatientInfoViewController: TYBaseViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var telLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    /// 患者ID
    var patientId:Int!
    /// 数据源数组 病例数组
    private var dataArr:[TYPatientInfoTableViewCellEntity] = [] {
        didSet{
            self.tableView.reloadData()
        }
    }
    private var data:AnyObject! {
        didSet {
            self.settingDownLoadInformation()
        }
    }
    @IBAction func addPacaseHistory(sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let nextViewController:TYAddPacaseHistoryViewController = storyboard.instantiateViewControllerWithIdentifier("TYAddPacaseHistoryViewController") as! TYAddPacaseHistoryViewController
        nextViewController.patientId = self.patientId
        self.navigationController?.pushViewController(nextViewController, animated: true)

    }

    private func settingInformation() {
        self.tableView.tableFooterView = UIView()
        self.downLoadBaseInfo()
        self.downLoadPacasehistoryList()
    }
    private func settingDownLoadInformation(){
        let patientName: AnyObject? = data.objectForKey("patientName")
        let patientSexId: AnyObject? = data.objectForKey("patientSexId")
        let patientTel: AnyObject? = data.objectForKey("patientTel")
        let patientBirthDate: AnyObject? = data.objectForKey("patientBirthDate")
        if patientName != nil {
            self.nameLabel.text = "\(patientName!)"
        }
        if patientSexId != nil {
        }
        if patientTel != nil {
            self.telLabel.text = "\(patientTel!)"
        }
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if patientBirthDate != nil {
            let data = formatter.dateFromString(patientBirthDate as! String)
            self.ageLabel.text = "\(TYAppUtils.ageWithDateOfBirth(data!))"
        }
    }
    /**
    下载基本信息
    */
    private func downLoadBaseInfo() {
        let handler = TYBaseHandler(API: TYAPI_GET_PATIENT_INFO)
        handler.executeTaskWithSVProgressHUD(["patientId":self.patientId], callBackData: { (callBackData) -> Void in
            if callBackData != nil {
                self.data = callBackData.objectAtIndex(0)

            }
        }, failed: nil)

    }
    /**
    下载患者病例列表
    */
    private func downLoadPacasehistoryList() {
        let handler = TYBaseHandler(API: TYAPI_GET_PACASEHISTORY_LIST)
        let parameter = ["patientId":self.patientId]
        handler.executeTaskWithSVProgressHUD(["patientId":self.patientId], callBackData: { (callBackData) -> Void in
            var tmpDataArr = [TYPatientInfoTableViewCellEntity]()
            if let data = callBackData as? [[NSObject : AnyObject]] {
                for dict in data {
                    var model = TYPatientInfoTableViewCellEntity()
                    model.setValuesForKeysWithDictionary(dict)
                    tmpDataArr.append(model)
                
                }
                self.dataArr = tmpDataArr
            }
        }, failed: nil)

    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.settingInformation()
    }
    // MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:TYPatientInfoTableViewCell? = tableView.dequeueReusableCellWithIdentifier("TYPatientInfoTableViewCell") as? TYPatientInfoTableViewCell
    
        if cell == nil {
            cell = NSBundle.mainBundle().loadNibNamed("TYPatientInfoTableViewCell", owner: self, options: nil).last as? TYPatientInfoTableViewCell
        }
        cell?.model = self.dataArr[indexPath.row]
        return cell!
    }
    // MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let patientId = self.dataArr[indexPath.row].patientId
        let caseId = self.dataArr[indexPath.row].caseId
        
        let consultState = self.dataArr[indexPath.row].consultState
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let nextViewController:TYPacaseHistoryInfoViewController = storyboard.instantiateViewControllerWithIdentifier("TYPacaseHistoryInfoViewController") as! TYPacaseHistoryInfoViewController
        nextViewController.patientId = patientId
        nextViewController.caseId = caseId
        nextViewController.consultState = consultState

        nextViewController.patientName = nameLabel.text
        nextViewController.patientAge = ageLabel.text
        nextViewController.patientTel = telLabel.text
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
}
