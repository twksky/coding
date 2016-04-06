//
//  Model.swift
//  cxd4iphone
//
//  Created by hexy on 12/16/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit

class Model: NSObject {

    init(dict: [String: AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    
    func keyValues() -> [String : AnyObject] {
        
        return ["":""]
    }

}
