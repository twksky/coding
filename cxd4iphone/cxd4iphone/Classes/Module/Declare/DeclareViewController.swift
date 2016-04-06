//
//  NewerDeclareViewController.swift
//  cxd4iphone
//
//  Created by hexy on 12/10/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit

class DeclareViewController: BaseTableViewController {

    private lazy var declareListViewModel = DeclareListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        declareListViewModel.loadDeclareList().subscribeError({ (error) -> Void in
            
                xx_showError(error)
            
            }) { () -> Void in
                
                self.tableView.reloadData()
        }
    }


    override func makeTableView() {
        
        
        
        self.tableListViewModel = declareListViewModel
        
        tableView.registerClass(DeclareCell.self, forCellReuseIdentifier: declareCellReuseId)
        
        tableView.rowHeight = xx_height(160)
        
    }

    override func cellSelected(indexPath: NSIndexPath) {
        
//        xx_print(self.declareListViewModel.sections[indexPath.section][indexPath.section])
        let vm = declareListViewModel.sections[indexPath.section][indexPath.section] as! DeclareCellViewModel
        xx_print(vm.URLString)
        
        let vc = WebViewController(URLStr: vm.URLString)
        vc.title = vm.title
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
