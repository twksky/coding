//
//  BaseCellViewModel.swift
//  cxd4iphone
//
//  Created by hexy on 12/10/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit

let baseCellReuseId = "baseCellReuseId"

class BaseCellViewModel: NSObject {

    lazy var viewModel = BaseCellModel(icon: nil, title: nil, detail: nil, destVC: nil)
    
    var reuseId: String {
        
        return baseCellReuseId
    }
    
    init(icon: UIImage?, title: String?, detail: String?, destVC: UIViewController?) {
        
        super.init()
        viewModel = BaseCellModel(icon: icon, title: title, detail: detail, destVC: destVC)
    }

}
