//
//  MyBidViewController.swift
//  cxd4iphone
//
//  Created by hexy on 12/3/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit

class MyBidViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        APIManager.loadUserInvestRecord(1).subscribeNext({ (result) -> Void in
            
            xx_JsonPrint(dict: result)
            }, error: { (error) -> Void in
                
                xx_print(error)
            }) { () -> Void in
                
        }
        
        let btn = UIButton(title: "全部", titleColor: UIColor.whiteColor(), titleSize: 12, bgColor: UIColor.clearColor())
        btn.addTarget(self, action: "showPickerView", forControlEvents: .TouchUpInside)
        btn.frame = CGRectMake(0, 0, 50, 30)
        let rightItem = UIBarButtonItem(customView: btn)
        
        
        self.navigationItem.rightBarButtonItem = rightItem

    }
    
    func showPickerView() {
        
        let pick = PickerView()
        pick.show()
    }


    override func makeTableView() {
        
        
        tableView.rowHeight = xx_height(200)
        
        self.tableListViewModel = MyBidListViewModel()
        tableView.registerClass(MyBidListCell.self, forCellReuseIdentifier: MyBidCellReuseID)
        tableView.sectionFooterHeight = 0.1
        
        
    }
    
    override func cellSelected(indexPath: NSIndexPath) {
        
        self.navigationController?.pushViewController(RepayPlanViewController(aTitle: "还款计划"), animated: true)
    }
}
