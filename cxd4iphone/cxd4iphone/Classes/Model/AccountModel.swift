//
//  AccountModel.swift
//  cxd4iphone
//
//  Created by hexy on 12/8/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit

class AccountModel: Model, NSCoding {
 
    var id: String?

    var mobileNumber: String?

    var sex: String?

    var realname: String?

    var referrer: String?

    var password: String?

    var idCard: String?

    var birthday: String?

    var username: String?

    var token: String?

    var registerTime: String?

    var score: Int = 0

    var email: String?

    var status: String?
    
    override init(dict: [String : AnyObject]) {
        
        super.init(dict: dict)
    }
    
    func saveAccount() {
        
        xx_print(xx_accountFilePath())
        NSKeyedArchiver.archiveRootObject(self, toFile: xx_accountFilePath())
    }
    
    class func loadAccount() -> AccountModel? {
        
        return NSKeyedUnarchiver.unarchiveObjectWithFile(xx_accountFilePath()) as? AccountModel
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(id, forKey: "id")
        aCoder.encodeObject(token, forKey: "token")
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(dict: ["":""])
        id = aDecoder.decodeObjectForKey("id") as? String
        token = aDecoder.decodeObjectForKey("token") as? String
    }
}
