//
//  BidViewController.swift
//  cxd4iphone
//
//  Created by hexy on 12/2/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit

private struct kConstraints {
    
    static let headerRect: CGRect = CGRectMake(0, 0, xx_screenWidth(), xx_screenHeight()-64-xx_height(190))
    static let footerRect: CGRect = CGRectMake(0, 0, xx_screenWidth(), xx_height(190))
}

class BuyViewController: BaseTableViewController {
    
    var bidID: String
    init(bidID: String) {
        
        self.bidID = bidID
        
        super.init(style: .Plain)
        self.title = "购买"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
        APIManager.loadBidDetail(self.bidID).subscribeNext({ (result) -> Void in
            
                xx_JsonPrint(dict: result)
            }, error: { (error) -> Void in
                xx_print(error)
            }) { () -> Void in
                
        }
    }

    override func makeTableView() {
        
//        automaticallyAdjustsScrollViewInsets = false
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.tableHeaderView = header
        
        header.pDetaiBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (_) -> Void in
            
            self.navigationController?.pushViewController(ProjectDetailViewController(aTitle: "项目详情"), animated: true)
        }
        header.pRiskBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (_) -> Void in
            
            self.navigationController?.pushViewController(ProjectRiskViewController(aTitle: "项目风控"), animated: true)
        }
        header.bidHistoryBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (_) -> Void in
            
            self.navigationController?.pushViewController(BidHistoryViewController(aTitle: "投资记录"), animated: true)
        }

        tableView.tableFooterView = footer
        footer.depositBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (_) -> Void in
            
            self.navigationController?.pushViewController(DepositViewController(aTitle: "充值"), animated: true)
        }
        
        xx_delay(1) { () -> () in
            
            self.header.rate = 20
        }
    }
    
    private lazy var header = BidHeaderView(frame: kConstraints.headerRect)
    private lazy var footer = BidFooterView(frame: kConstraints.footerRect)


}
