//
//  MeViewController.swift
//  cxd4iphone
//
//  Created by hexy on 15/11/19.
//  Copyright © 2015年 hexy. All rights reserved.
//

import UIKit
import APParallaxHeader

private struct kConstraints {
    
    static let headerHeight: CGFloat = xx_height(110)
    static let headerRect: CGRect    = CGRectMake(0, 0, xx_screenWidth(), kConstraints.headerHeight)
    static let footerHeight: CGFloat = xx_screenHeight() - kConstraints.headerHeight - 64 - 49
    static let footerRect: CGRect    = CGRectMake(0, 0, xx_screenWidth(), kConstraints.footerHeight)
}

class MeViewController: BaseTableViewController {
    
    private lazy var meListViewModel = MeListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        meListViewModel.loadUserIncome().subscribeError({ (error) -> Void in
            
                xx_showError(error)
            
            }) { () -> Void in
                
                self.header.userIncomeViewModel = self.meListViewModel.userIncomeViewModel
                self.footer.userIncomeViewModel = self.meListViewModel.userIncomeViewModel
        }
    }
    
    override func makeTableView() {
        
        self.tableListViewModel = meListViewModel
        
        //        tableView.addParallaxWithView(header, andHeight: kConstraints.headerRect.height)
        tableView.tableHeaderView = header
        
        tableView.tableFooterView = footer
    }
    
    private lazy var header = UserIncomeTopView(frame: kConstraints.headerRect)
    
    private lazy var footer: UserIncomeBottomView = {
        
        let footer = UserIncomeBottomView(frame: kConstraints.footerRect)
        
        
        footer.myBidBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (_) -> Void in
            
            self.navigationController?.pushViewController(MyBidViewController(aTitle: "我的投资"), animated: true)
        }
        
        footer.myBillBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (_) -> Void in
            
            self.navigationController?.pushViewController(MyBillViewController(aTitle: "我的账单"), animated: true)
        }
        
        footer.myAccountBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (_) -> Void in
            
            self.navigationController?.pushViewController(MyAccountViewController(), animated: true)
        }
        
        footer.depositBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (_) -> Void in
            
            //            xx_print("充值")
            self.navigationController?.pushViewController(DepositViewController(aTitle: "充值"), animated: true)
            
        }
        
        footer.withdrawBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (_) -> Void in
            
            //            xx_print("提现")
            self.navigationController?.pushViewController(WithdrawViewController(aTitle: "提现"), animated: true)
        }

        
        return footer
    }()

}
