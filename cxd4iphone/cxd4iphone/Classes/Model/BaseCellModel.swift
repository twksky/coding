//
//  BaseCellModel.swift
//  cxd4iphone
//
//  Created by hexy on 12/10/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit

class BaseCellModel: Model {

    var icon: UIImage?
    var title: String?
    var detail: String?
    var destVC: UIViewController?

    init(icon: UIImage?, title: String?, detail: String?, destVC: UIViewController?) {

        
        self.icon   = icon
        self.title  = title
        self.detail = detail
        self.destVC = destVC
        super.init(dict: ["":""])
    }
}
