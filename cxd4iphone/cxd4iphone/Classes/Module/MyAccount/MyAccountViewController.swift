//
//  MyAccountViewController.swift
//  cxd4iphone
//
//  Created by hexy on 12/3/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit

class MyAccountViewController: BaseTableViewController {

    init() {
        super.init(style: .Grouped)
        self.title = "我的账户"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func makeTableView() {
        
        tableView.separatorStyle = .SingleLine
        tableView.rowHeight = xx_height(44)
        tableView.separatorColor = xx_colorWithHex(hexValue: 0xededed)
        
        self.tableListViewModel = MyAccountListViewModel()
        tableView.registerClass(BaseTableViewCell.self, forCellReuseIdentifier: baseCellReuseId)
        tableView.sectionFooterHeight = 0.1
        
        let footer = UIView(frame: CGRectMake(0, 0, xx_screenWidth(), xx_height(80)))
        let exitBtn = UIButton(title: "退出登录", titleColor: UIColor.whiteColor(), titleSize: 18, bgColor: xx_colorWithHex(hexValue: 0x3d64b4))
        
        footer.addSubview(exitBtn)
        exitBtn.snp_makeConstraints { (make) -> Void in
            
            make.centerY.equalTo(footer)
            make.left.equalTo(footer).offset(15)
            make.right.equalTo(footer).offset(-15)
            make.height.equalTo(xx_height(40))
        }
        
        tableView.tableFooterView = footer

    }

}

extension MyAccountViewController {
    
        override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            
            return xx_height(10)
        }
}