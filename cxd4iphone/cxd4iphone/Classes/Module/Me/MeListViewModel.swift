//
//  MeListViewModel.swift
//  cxd4iphone
//
//  Created by hexy on 12/21/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit
import ReactiveCocoa

class MeListViewModel: BaseTableListViewModel {

    var userIncomeViewModel: UserIncomeViewModel?
    
    func loadUserIncome() -> RACSignal {
        
        return RACSignal.createSignal({ (subscriber) -> RACDisposable! in
            

            
            APIManager.loadUserIncome().subscribeNext({ (result) -> Void in
                
//                xx_JsonPrint(dict: result)
                let dict = result as! [String: AnyObject]
                self.userIncomeViewModel = UserIncomeViewModel(userIncomeModel: UserIncomeModel(dict: dict))

                subscriber.sendCompleted()
                
                }, error: { (error) -> Void in
                    
                    subscriber.sendError(error)
            })
            return RACDisposable(block: {})
        })
    }

}
