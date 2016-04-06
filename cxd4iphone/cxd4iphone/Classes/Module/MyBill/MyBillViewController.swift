//
//  MyBillViewController.swift
//  cxd4iphone
//
//  Created by hexy on 12/3/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit

class MyBillViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        APIManager.loadUserBillList(1).subscribeNext({ (result) -> Void in
            
                xx_JsonPrint(dict: result)
            }, error: { (error) -> Void in
                
                xx_print(error)
            }) { () -> Void in
                
        }
        
        let btn = UIButton(title: "全部", titleColor: UIColor.whiteColor(), titleSize: 12, bgColor: UIColor.clearColor())
        btn.addTarget(self, action: "showPickerView", forControlEvents: .TouchUpInside)
        btn.frame = CGRectMake(0, 0, 50, 30)
        let rightItem = UIBarButtonItem(customView: btn)
        
        
        self.navigationItem.rightBarButtonItem = rightItem

    }

    override func makeTableView() {
        
        tableView.sectionHeaderHeight = xx_height(40)
        tableView.backgroundColor = UIColor.whiteColor()

//        tableView.separatorStyle = .SingleLine
        tableView.rowHeight = xx_height(80)
        tableView.separatorColor = xx_colorWithHex(hexValue: 0xededed)
        
        self.tableListViewModel = MyBillListViewModel()
        
        tableView.registerClass(MyBillListCell.self, forCellReuseIdentifier: MyBillCellReuseID)
        tableView.sectionFooterHeight = 0.1
        
    }
    
    func showPickerView() {
        
        let pick = PickerView()
        pick.show()
    }

}

extension MyBillViewController {
    
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
       
        return MyBillSectionHeaderView()
    }
    
    
}


//class MyBillViewController: UITableViewController {
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        makeTableView()
//    }
//    
//    func makeTableView() {
//        
//        //        tableView.sectionHeaderHeight = xx_height(40)
//        tableView.backgroundColor = UIColor.whiteColor()
//        
//        //        tableView.separatorStyle = .SingleLine
//        //        tableView.separatorColor = xx_colorWithHex(hexValue: 0xededed)
//        
//        //        self.tableListViewModel = MyBillListViewModel()
//        
//        tableView.registerClass(MyBillListCell.self, forCellReuseIdentifier: MyBillCellReuseID)
//        //        tableView.sectionFooterHeight = 0.1
//        
//    }
//    
//    var stateCache: [NSIndexPath :Bool] = [:]
//}
//
//extension MyBillViewController {
//    
//    
//    //    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//    //
//    //
//    //        return MyBillSectionHeaderView()
//    //    }
//    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier(MyBillCellReuseID, forIndexPath: indexPath) as! MyBillListCell
//        return cell
//    }
//    
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 12
//    }
//    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        let isOpen = stateCache[indexPath] ?? false
//        
//        stateCache[indexPath] = !isOpen
//        tableView.beginUpdates()
//        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
//        tableView.endUpdates()
//    }
//    
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        if let state = stateCache[indexPath] where state {
//            return 80
//        }
//        return 50
//    }
//    
//}