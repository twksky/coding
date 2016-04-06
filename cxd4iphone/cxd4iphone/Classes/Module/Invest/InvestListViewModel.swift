//
//  InvestListViewModel.swift
//  cxd4iphone
//
//  Created by hexy on 12/1/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit
import ReactiveCocoa

class InvestListViewModel: BaseTableListViewModel {

//    override init() {
//        
//        super.init()
//        
//        let vm1 = InvestCellViewModel(bidModel: BidModel(dict: ["":""]))
//        
//        self.sections = [[vm1, vm1, vm1, vm1,vm1,vm1,vm1,vm1,vm1,vm1,vm1,vm1,vm1,vm1]]
//    }
//    
    
    lazy var bidSelectModel = BidSelectModel(dict: ["":""])
    
//    lazy var invests = [InvestCellViewModel]()
    
    func loadBidList(pullDown: Bool) -> RACSignal {
        
        return RACSignal.createSignal({ (subscriber) -> RACDisposable! in
            
            self.bidSelectModel.pageSize = "10"
            self.bidSelectModel.currentPage = "1"
            
            APIManager.loadBidList(self.bidSelectModel).subscribeNext({ (result) -> Void in
                
                    let array = result as! [[String: AnyObject]]
                
                    var arrM = [InvestCellViewModel]()
                    for dict in array {
                        
                        arrM.append(InvestCellViewModel(bidModel: BidModel(dict: dict)))
                    }
                
                    self.sections = [arrM]
                    subscriber.sendCompleted()
                
                }, error: { (error) -> Void in
                    
                    subscriber.sendError(error)
            })
            return RACDisposable(block: {})
        })
    }

}
