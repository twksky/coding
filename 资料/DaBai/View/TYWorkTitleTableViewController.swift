//
//  TYWorkTitleTableViewController.swift
//  DaBai
//
//  Created by BaiTianWei on 15/6/25.
//  Copyright (c) 2015年 BaiTianWei. All rights reserved.
//

import UIKit

class TYWorkTitleTableViewController: UITableViewController {
    var callBack:((TYWorkTitleTableViewCellModel) -> ())!
    /// 数据源数组
    private var dataArr:[TYWorkTitleTableViewCellModel] = [] {
        didSet{
            self.tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println(TYDicStorage.dicList())

        var tmpDataArr:[TYWorkTitleTableViewCellModel]

        

    }
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:TYWorkTitleTableViewCell? = tableView.dequeueReusableCellWithIdentifier("TYWorkTitleTableViewCell") as? TYWorkTitleTableViewCell
        if cell == nil {
            cell = TYWorkTitleTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "TYWorkTitleTableViewCell")
        }
        cell?.model = dataArr[indexPath.row]
        return cell!
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let model = dataArr[indexPath.row]
        self.callBack(model)
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
class TYWorkTitleTableViewCell: UITableViewCell {
    var model:TYWorkTitleTableViewCellModel! {
        didSet{
            self.textLabel?.text = model.text
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class TYWorkTitleTableViewCellModel: TYBaseEntity {
    var id:String!
    var text:String!
}
