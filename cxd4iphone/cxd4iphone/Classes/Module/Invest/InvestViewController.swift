//
//  InvestViewController.swift
//  cxd4iphone
//
//  Created by hexy on 15/11/19.
//  Copyright © 2015年 hexy. All rights reserved.
//

import UIKit
import ReactiveCocoa

private struct kConstraints {
    
    static let InvestListCellReuseIdentifier: String = "InvestListCellReuseIdentifier"
}

class InvestViewController: BaseTableViewController {

    private lazy var investListViewModel = InvestListViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        let mo = investListViewModel.bidSelectModel
//        mo.pageSize = "20"
//        mo.currentPage = "1"
//        mo.rateMax = "0.2"
//        mo.rateMin = "0.15"
//        mo.dateMax = "6"
//        mo.dateMin = "3"
//        xx_print(mo.keyValues())
//        xx_JsonPrint(dict: mo.keyValues())
        
//        APIManager.loadBidList(mo).subscribeNext({ (res) -> Void in
//            
////                xx_print(res)
//            xx_JsonPrint(dict: res)
//            }, error: { (error) -> Void in
//                xx_print(error)
//            }) { () -> Void in
//                
//        }
        
        investListViewModel.loadBidList(true).subscribeError({ (error) -> Void in
            
                xx_print(error)
            }) { () -> Void in
                
                xx_print(self.investListViewModel.sections)
                self.tableView.reloadData()
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
        self.tableListViewModel = investListViewModel
        
        tableView.registerClass(InvestListCell.self, forCellReuseIdentifier: InvestCellReuseID)
        tableView.rowHeight = xx_height(140)
        tableView.separatorStyle = .None
    }
    
    override func cellSelected(indexPath: NSIndexPath) {
        
//        xx_print("\(indexPath.section)--\(indexPath.row)")
//        xx_print(investListViewModel.sections[indexPath.section][indexPath.row])
        
        let vm = investListViewModel.sections[indexPath.section][indexPath.row] as! InvestCellViewModel
        
        xx_print(vm.bidModel.id!)
        

        navigationController?.pushViewController(BuyViewController(bidID: vm.bidModel.id!), animated: true)
    }

}


