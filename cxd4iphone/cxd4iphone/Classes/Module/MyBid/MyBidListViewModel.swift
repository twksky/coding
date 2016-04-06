//
//  MyBidListViewModel.swift
//  cxd4iphone
//
//  Created by hexy on 12/15/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit

class MyBidListViewModel: BaseTableListViewModel {

    override init() {
        
        super.init()
        
        let vm1 = MyBidCellViewModel()
        
        self.sections = [[vm1, vm1, vm1, vm1, vm1, vm1, vm1, vm1]]
    }

}
