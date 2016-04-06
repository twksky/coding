//
//  RepayScheduleViewController.swift
//  cxd4iphone
//
//  Created by hexy on 12/3/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit

class RepayPlanViewController: BaseTableViewController {

    private lazy var repayPlanListViewModel = RepayPlanListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIManager.loadRepayPlanList("20151112002256").subscribeNext({ (result) -> Void in
            
                xx_JsonPrint(dict: result)
            }, error: { (error) -> Void in
                
            }, completed: {})
    }

    override func makeTableView() {
        
        
        tableView.rowHeight = xx_height(200)
        
        self.tableListViewModel = repayPlanListViewModel
        tableView.registerClass(RepayPlanListCell.self, forCellReuseIdentifier: RepayPlanCellReuseID)
        tableView.sectionFooterHeight = 0.1
        
        
    }
}
