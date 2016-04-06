//
//  RegistModel.swift
//  cxd4iphone
//
//  Created by hexy on 12/15/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit

class RegistModel: Model {

    var userName: String?
    
    var password: String?
    
    var phoneNo: String?
    
    var authCode: String?
    
    var referrer: String?
    

    override func keyValues() -> [String : AnyObject] {
        
        let keys = ["userName", "password", "phoneNo", "authCode", "referrer"]
        
        return dictionaryWithValuesForKeys(keys)
    }
    
}
