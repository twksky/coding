//
//  RepayScheduleCellViewModel.swift
//  cxd4iphone
//
//  Created by hexy on 12/22/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit

let RepayPlanCellReuseID = "RepayPlanCellReuseID"
class RepayPlanCellViewModel: BaseCellViewModel {

    override var reuseId: String {
        
        return RepayPlanCellReuseID
    }
    
    init() {
        
        super.init(icon: nil, title: nil, detail: nil, destVC: nil)
        
        //        self.viewModel  = HomeCellModel(xx: "hehhehe", destVC: destVC)
    }
}
