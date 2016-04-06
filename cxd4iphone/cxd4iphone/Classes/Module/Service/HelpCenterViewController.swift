//
//  HelpCenterViewController.swift
//  cxd4iphone
//
//  Created by hexy on 12/11/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit

class HelpCenterViewController: BaseTableViewController {

    init() {
        super.init(style: .Grouped)
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
        
        
        self.tableListViewModel = HelpCenterListViewModel()
        tableView.registerClass(BaseTableViewCell.self, forCellReuseIdentifier: baseCellReuseId)
        tableView.sectionFooterHeight = 0.1
        
    }
    
    override func cellSelected(indexPath: NSIndexPath) {
        
        xx_print(indexPath.row)
    }

}

extension HelpCenterViewController {
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return xx_height(10)
    }
    
}
