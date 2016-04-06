//
//  TYDoctorListViewController.swift
//  DaBai
//
//  Created by BaiTianWei on 15/6/15.
//  Copyright (c) 2015年 BaiTianWei. All rights reserved.
//

import UIKit

class TYDoctorListViewController: UIViewController,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    private var page:Int = 1
    private var dataArr:[TYDoctorTableViewCellEntity] = [] {
        didSet{
            self.tableView.reloadData()
        }
    }
    func goBack() {
        let nextViewController = self.navigationController?.viewControllers[1] as! UIViewController
        self.navigationController?.popToViewController(nextViewController, animated: true)
    }
    private func setInformation(){
        self.tableView.tableFooterView = UIView()
        self.downLoadData()
        self.tableView.addLegendHeaderWithRefreshingBlock { () -> Void in
            self.downLoadData()
        }
        self.tableView.addLegendFooterWithRefreshingBlock { () -> Void in
            self.downLoadMoreData()
        }
    }
    private func downLoadData(){
        let handler = TYBaseHandler(API: TYAPI_DOCTOR_LIST)
        
        handler.executeTaskWithSVProgressHUD(["begOrderState":"1","page":1], callBackData: { (callBackData) -> Void in
            self.page = 1
            var tmpDataArr = [TYDoctorTableViewCellEntity]()
            if let data = callBackData as? [[NSObject : AnyObject]] {
                for dict in data {
                    var model = TYDoctorTableViewCellEntity()
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
    private func downLoadMoreData(){
        let handler = TYBaseHandler(API: TYAPI_DOCTOR_LIST)
        
        handler.executeTaskWithSVProgressHUD(["begOrderState":"1","page":page + 1], callBackData: { (callBackData) -> Void in
            if callBackData != nil {
                self.page++
            }
            var tmpDataArr = [TYDoctorTableViewCellEntity]()
            if let data = callBackData as? [[NSObject : AnyObject]] {
                for dict in data {
                    var model = TYDoctorTableViewCellEntity()
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
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: self, action: "goBack")
    }
    
//MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 84
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:TYDoctorTableViewCell? = tableView.dequeueReusableCellWithIdentifier("TYDoctorTableViewCell") as? TYDoctorTableViewCell
        if cell == nil {
            cell = NSBundle.mainBundle().loadNibNamed("TYDoctorTableViewCell", owner: self, options: nil).last as? TYDoctorTableViewCell
        }
        cell?.model = self.dataArr[indexPath.row]
        return cell!
    }
//    MARK: -UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let nextViewController:TYSelectDoctorViewController = storyboard.instantiateViewControllerWithIdentifier("TYSelectDoctorViewController") as! TYSelectDoctorViewController
        nextViewController.doctorId = self.dataArr[indexPath.row].userId
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    
}
