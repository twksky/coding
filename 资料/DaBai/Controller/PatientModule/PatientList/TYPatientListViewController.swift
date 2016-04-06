//
//  TYPatientListViewController.swift
//  DaBai
//
//  Created by BaiTianWei on 15/6/4.
//  Copyright (c) 2015年 BaiTianWei. All rights reserved.
//

import UIKit

class TYPatientListViewController: TYBaseViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    private var page:Int = 1
    /// 数据源数组
    private var dataArr:[TYPatientListTableViewCellEntity] = [] {
        didSet{
            self.tableView.reloadData()
        }
    }
    
    
    private func setInformation() {
        self.tableView.tableFooterView = UIView()
        self.downLoadData()
        self.tableView.addLegendHeaderWithRefreshingBlock { () -> Void in
            self.downLoadData()
        }
        self.tableView.addLegendFooterWithRefreshingBlock { () -> Void in
            self.downLoadMoreDate()
        }
        self.tableView.footer.hidden = true
    }
    private func downLoadData(){
        let handler = TYBaseHandler(API: TYAPI_GET_PATIENT_LIST)
        handler.executeTaskWithSVProgressHUD(["userId":TYDoctorInformationStorage.doctorInformation().userId], callBackData: { (callBackData) -> Void in
            self.page = 1
            var tmpDataArr = [TYPatientListTableViewCellEntity]()
            if let data = callBackData as? [[NSObject : AnyObject]] {
                for dict in data {
                    var model = TYPatientListTableViewCellEntity()
                    model.setValuesForKeysWithDictionary(dict)
                    tmpDataArr.append(model)
                }
                self.dataArr = tmpDataArr
            }
            self.endRefreshing()
            }) { () -> Void in
                self.endRefreshing()
        }

    }
    private func downLoadMoreDate(){
        let handler = TYBaseHandler(API: TYAPI_GET_PATIENT_LIST)
        handler.executeTaskWithSVProgressHUD([
            "userId":TYDoctorInformationStorage.doctorInformation().userId,
            "page":self.page + 1
            ], callBackData: { (callBackData) -> Void in
                if callBackData != nil {
                    self.page++
                }
                var tmpDataArr = [TYPatientListTableViewCellEntity]()
                if let data = callBackData as? [[NSObject : AnyObject]] {
                    for dict in data {
                        var model = TYPatientListTableViewCellEntity()
                        model.setValuesForKeysWithDictionary(dict)
                        tmpDataArr.append(model)
                    }
                    self.dataArr += tmpDataArr
                }
                self.endRefreshing()
            }) { () -> Void in
                self.endRefreshing()
        }
    }
    /**
    结束刷新
    */
    private func endRefreshing(){
        self.tableView.legendFooter.endRefreshing()
        self.tableView.legendHeader.endRefreshing()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setInformation()
    }
    //MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:TYPatientListTableViewCell? = tableView.dequeueReusableCellWithIdentifier("TYPatientListTableViewCell") as? TYPatientListTableViewCell
        if cell == nil {
            cell = NSBundle.mainBundle().loadNibNamed("TYPatientListTableViewCell", owner: self, options: nil).last as? TYPatientListTableViewCell
        }
        cell?.model = dataArr[indexPath.row]
        return cell!
    }
    //MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let patientId = self.dataArr[indexPath.row].patientId
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        
        let nextViewController:TYPatientInfoViewController = storyboard.instantiateViewControllerWithIdentifier("TYPatientInfoViewController") as! TYPatientInfoViewController
        nextViewController.patientId = patientId
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }

}
