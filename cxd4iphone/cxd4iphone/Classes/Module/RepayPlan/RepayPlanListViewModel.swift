//
//  RepayScheduleListViewModel.swift
//  cxd4iphone
//
//  Created by hexy on 12/22/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit

class RepayPlanListViewModel: BaseTableListViewModel {

    override init() {
        
        super.init()
        
        let vm1 = RepayPlanCellViewModel()
        
        self.sections = [[vm1, vm1, vm1, vm1, vm1, vm1, vm1, vm1]]
    }
}
