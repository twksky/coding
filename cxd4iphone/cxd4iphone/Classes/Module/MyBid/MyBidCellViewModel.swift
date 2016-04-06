//
//  MyBidCellViewModel.swift
//  cxd4iphone
//
//  Created by hexy on 12/15/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit

let MyBidCellReuseID = "MyBidCellReuseID"

class MyBidCellViewModel: BaseCellViewModel {

    override var reuseId: String {
        
        return MyBidCellReuseID
    }
    
    init() {
        
        super.init(icon: nil, title: nil, detail: nil, destVC: nil)
        
        //        self.viewModel  = HomeCellModel(xx: "hehhehe", destVC: destVC)
    }
}
