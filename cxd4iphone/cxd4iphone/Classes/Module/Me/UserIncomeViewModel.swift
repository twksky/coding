//
//  UserIncomeViewModel.swift
//  cxd4iphone
//
//  Created by hexy on 12/21/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit

class UserIncomeViewModel: NSObject {

    
    var userIncomeModel: UserIncomeModel
    
    
    // MARK: - 构造函数
    init(userIncomeModel: UserIncomeModel) {
        
        self.userIncomeModel = userIncomeModel
        
        super.init()
    }
    
}
