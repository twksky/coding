//
//  DepositViewController.swift
//  cxd4iphone
//
//  Created by hexy on 12/3/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit

class DepositViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func makeTableView() {
        
        let input = MoneyInputView(balance: "1000.00", isDeposit: true)
//        input.frame = CGRectMake(0, 0, xx_screenWidth(), xx_height(100))
        
        tableView.tableHeaderView = input
    }
}

extension DepositViewController {
    
}