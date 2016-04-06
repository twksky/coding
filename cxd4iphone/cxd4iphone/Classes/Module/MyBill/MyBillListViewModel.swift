//
//  MyBillListViewModel.swift
//  cxd4iphone
//
//  Created by hexy on 12/15/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit

class MyBillListViewModel: BaseTableListViewModel {

    override init() {
        
        super.init()
        
        let vm1 = MyBillCellViewModel()
        
        self.sections = [[vm1, vm1, vm1, vm1, vm1, vm1, vm1, vm1]]

    }
    

}
