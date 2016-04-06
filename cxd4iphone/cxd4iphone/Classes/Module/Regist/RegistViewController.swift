//
//  RegistSetpTwoViewController.swift
//  cxd4iphone
//
//  Created by hexy on 12/8/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit

private struct kConstraints {
    
    static let headerHeight: CGFloat = xx_height(260)
    static let headerRect: CGRect    = CGRectMake(0, 0, xx_screenWidth(), kConstraints.headerHeight)
}

class RegistViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let header =  RegistView(frame: kConstraints.headerRect)
        
//        header.nextStepBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (_) -> Void in
//            
//            self.navigationController?.pushViewController(RegistSetpTwoViewController(aTitle: "注册2"), animated: true)
//        }
        tableView.tableHeaderView = header

    }

    

}
