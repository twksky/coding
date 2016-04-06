//
//  TYHuiZhenViewController.swift
//  DaBai
//
//  Created by BaiTianWei on 15/6/11.
//  Copyright (c) 2015年 BaiTianWei. All rights reserved.
//

import UIKit

class TYHuiZhenListViewController: TYBaseViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    private var dataArr:[TYConsultInfoEntity] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }

    private func setInformation(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.downLoadData()
    }
    private func downLoadData(){
        let handle = TYBaseHandler(API: TYAPI_GET_CONSULT_LIST)
        let parameter = ["toDcId":TYDoctorInformationStorage.doctorInformation().userId]
        handle.executeTaskWithSVProgressHUD(parameter, callBackData: { (callBackData) -> Void in
            var tmpDataArr = [TYConsultInfoEntity]()
            if let data = callBackData as? [[NSObject : AnyObject]] {
                for dict in data {
                    var model = TYConsultInfoEntity()
                    model.setValuesForKeysWithDictionary(dict)
                    tmpDataArr.append(model)
                }
                self.dataArr = tmpDataArr
            }
            }, failed: nil)
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

        var cell:TYConsultTableViewCell? = tableView.dequeueReusableCellWithIdentifier("TYConsultTableViewCell") as? TYConsultTableViewCell
        if cell == nil {
            cell = NSBundle.mainBundle().loadNibNamed("TYConsultTableViewCell", owner: self, options: nil).last as? TYConsultTableViewCell
        }
        cell?.model = dataArr[indexPath.row]
        return cell!
    }
    //MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let nextViewController:TYSelectConsultViewController = storyboard.instantiateViewControllerWithIdentifier("TYSelectConsultViewController") as! TYSelectConsultViewController
        nextViewController.consultState = dataArr[indexPath.row].consultState
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
}
