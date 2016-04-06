//
//  NewerDeclareListViewModel.swift
//  cxd4iphone
//
//  Created by hexy on 12/11/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit
import ReactiveCocoa

class DeclareListViewModel: BaseTableListViewModel {

//    override init() {
//        
//        super.init()
//        
//        
//        let declare = DeclareCellViewModel()
//        
//
//        
//        self.sections = [[declare, declare, declare]]
//    }
    
    
    func loadDeclareList() -> RACSignal {
        
        
        return RACSignal.createSignal({ (subscriber) -> RACDisposable! in
            
            
            APIManager.loadDeclareList(1).subscribeNext({ (result) -> Void in
                
                    let array = (result as! [String: AnyObject])["map"]  as! [[String: AnyObject]]

                        xx_JsonPrint(dict: array)
                    var arrM = [DeclareCellViewModel]()
                    for dict in array {
                        
                        arrM.append(DeclareCellViewModel(declareModel: DeclareModel(dict: dict)))
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
