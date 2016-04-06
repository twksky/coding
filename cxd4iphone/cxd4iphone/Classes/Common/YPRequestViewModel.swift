//
//  YPRequestViewModel.swift
//  cxd4iphone
//
//  Created by hexy on 12/18/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit
import ReactiveCocoa

class YPRequestViewModel: NSObject {
    
    static let shared = YPRequestViewModel()
    
    override init() {
        
        ypRequestModel = YPRequestModel(dict: ["":""])
   
    }

    var ypRequestModel: YPRequestModel?
    
    var html: String {
        
        return xx_HTML((ypRequestModel?.actionUrl)!, sign: (ypRequestModel?.sign)!, req: (ypRequestModel?.reqContent)!)
    }
    
}
