//
//  ResetPasswdStepTwoViewController.swift
//  cxd4iphone
//
//  Created by hexy on 12/9/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit

private struct kConstraints {
    
    static let headerHeight: CGFloat = xx_height(200)
    static let headerRect: CGRect    = CGRectMake(0, 0, xx_screenWidth(), kConstraints.headerHeight)
}

class NewPasswdController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let header =  NewPasswdView(frame: kConstraints.headerRect)
        
//        header.nextStepBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (_) -> Void in
//            
//            self.navigationController?.pushViewController(ResetPasswdStepTwoViewController(aTitle: "忘记密码2"), animated: true)
//        }
        tableView.tableHeaderView = header

    }

    

}
