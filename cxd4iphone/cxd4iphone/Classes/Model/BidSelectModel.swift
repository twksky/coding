//
//  BidSelectModel.swift
//  cxd4iphone
//
//  Created by hexy on 12/17/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit

class BidSelectModel: Model {

    var pageSize: String?
    
    var currentPage: String?
    
    var rateMax: String?
    
    var rateMin: String?
    
    var dateMax: String?
    
    var dateMin: String?
    

    override func keyValues() -> [String : AnyObject] {
        
        let keys = ["pageSize", "currentPage", "rateMax", "rateMin", "dateMax", "dateMin"]
        
        return dictionaryWithValuesForKeys(keys)
    }
}
