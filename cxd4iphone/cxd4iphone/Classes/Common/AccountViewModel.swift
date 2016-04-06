//
//  AccountViewModel.swift
//  cxd4iphone
//
//  Created by hexy on 12/17/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit
import ReactiveCocoa

class AccountViewModel: NSObject {

    static let shared = AccountViewModel()
    
    override init() {
        
        accountModel = AccountModel.loadAccount()
        registModel =  RegistModel(dict: ["":""])
    }
    
    var accountModel: AccountModel?
    
    var token: String? {
        
        return accountModel?.token
    }
    var userId: String {
        
        return (accountModel?.id)!
    }
    var userLogin: Bool {
        
        return token != nil
    }
    
    
    var registModel: RegistModel
    
    
    func register() -> RACSignal {
        
        return RACSignal.createSignal({ (subscriber) -> RACDisposable! in
            
            APIManager.register(self.registModel).subscribeNext({ (result) -> Void in
                
                    xx_JsonPrint(dict: result)
                    subscriber.sendCompleted()
                }, error: { (error) -> Void in
                    
                    subscriber.sendError(error)
            })
            return RACDisposable(block: {})
        })
    }
    
    func login(loginName: String, passwd: String) -> RACSignal {
        
        return RACSignal.createSignal({ (subscriber) -> RACDisposable! in
            
            APIManager.login(loginName, passwd: passwd).subscribeNext({ (result) -> Void in
                
//                    xx_JsonPrint(dict: result)
                    let dict = result as! [String: AnyObject]
                    let account = AccountModel(dict: dict)
                    account.saveAccount()
                    self.accountModel = account
                    subscriber.sendCompleted()
                
                }, error: { (error) -> Void in
                    
                    subscriber.sendError(error)
            })
            return RACDisposable(block: {})
        })
    }

    
    func authen() -> RACSignal {
        
        return RACSignal.createSignal({ (subscriber) -> RACDisposable! in
            
            
            return RACDisposable(block: {})
        })
    }

}
