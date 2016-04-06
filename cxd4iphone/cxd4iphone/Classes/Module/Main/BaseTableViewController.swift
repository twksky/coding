//
//  BaseTableViewController.swift
//  cxd4iphone
//
//  Created by hexy on 15/11/19.
//  Copyright © 2015年 hexy. All rights reserved.
//

import UIKit
import ReactiveCocoa

private struct kConstraints {
    
    static let backgroundColor: UIColor = xx_colorWithHex(hexValue: 0xf8f8f8)
    static let separatorColor: UIColor  = xx_colorWithHex(hexValue: 0xc3c3c3)
}

class BaseTableViewController: UITableViewController {

  
    lazy var tableListViewModel = BaseTableListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = kConstraints.backgroundColor
        tableView.separatorStyle = .None
        
        makeTableView()
    }
    
    func makeTableView() {
        
        
        
        tableView.registerClass(BaseTableViewCell.self, forCellReuseIdentifier: baseCellReuseId)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        
        return UIStatusBarStyle.LightContent
    }
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return tableListViewModel.sections.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return tableListViewModel.sections[section].count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let vm = tableListViewModel.sections[indexPath.section][indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier(vm.reuseId, forIndexPath: indexPath) as! BaseTableViewCell
        
        cell.viewModel = vm
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let vm = tableListViewModel.sections[indexPath.section][indexPath.row].viewModel
        
        guard let destVC = vm.destVC else {
            
            cellSelected(indexPath)
            return
        }
        destVC.title = vm.title
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    
    func cellSelected(indexPath: NSIndexPath) { }
    
}
