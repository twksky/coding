//
//  ServiceViewController.swift
//  cxd4iphone
//
//  Created by hexy on 15/11/19.
//  Copyright © 2015年 hexy. All rights reserved.
//

import UIKit

private struct kConstraints {
    
    static let headerHeight: CGFloat = xx_height(130)
    static let headerRect: CGRect    = CGRectMake(0, 0, xx_screenWidth(), xx_height(120))
    static let footerHeight: CGFloat = xx_screenHeight() - kConstraints.headerHeight - 64 - 49
    static let footerRect: CGRect    = CGRectMake(0, 0, xx_screenWidth(), kConstraints.footerHeight)
}

class ServiceViewController: BaseTableViewController {

    init() {
        super.init(style: .Grouped)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var serviceListViewModel = ServiceListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let str = "12345678".substringToIndex(4)
        xx_print(str)
            serviceListViewModel.loadTotalInvestStatic().subscribeError({ (error) -> Void in
                
                    xx_print(error)
                
                }) { () -> Void in
//                    
//                    xx_print("xxx")
//                    xx_print(self.serviceListViewModel.totalStaticViewModel?.staticModel)
                    self.header.totalStaticViewModel = self.serviceListViewModel.totalStaticViewModel
            }
        
    }
    

    
    override func makeTableView() {
        
        
        tableView.separatorStyle = .SingleLine
        tableView.rowHeight = xx_height(44)
        tableView.separatorColor = xx_colorWithHex(hexValue: 0xededed)
        tableView.tableHeaderView = header
        
//        xx_delay(1) {
//            
//            header.serviceHeaderViewModel = ServiceHeaderViewModel()
//        }
//        
        
        self.tableListViewModel = serviceListViewModel
        tableView.registerClass(BaseTableViewCell.self, forCellReuseIdentifier: baseCellReuseId)
        tableView.sectionFooterHeight = 0.1

    }
    
    override func cellSelected(indexPath: NSIndexPath) {
        
        xx_print(indexPath.row)
        UIApplication.sharedApplication().openURL(NSURL(string: "itms-apps://itunes.apple.com/cn/app/cheng-xin-dai-rang-nin-cai/id1059930439?l=en&mt=8")!)
    }
    
    private lazy var header = TotalStaticView(frame: kConstraints.headerRect)
}

extension ServiceViewController {
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return xx_height(10)
    }
    
}


