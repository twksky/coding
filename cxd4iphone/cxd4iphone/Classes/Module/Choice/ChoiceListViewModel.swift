//
//  ChoiceListViewModel.swift
//  cxd4iphone
//
//  Created by hexy on 12/15/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit
import ReactiveCocoa

class ChoiceListViewModel: BaseTableListViewModel {

    
    var recommendBidViewModel: RecommendBidViewModel?
    
    var imageURLs: [NSURL] {
        
        var arrM = [NSURL]()
        
        for carousel:CarouselViewModel in self.carousels {
            
            arrM.append(carousel.imageURL)
        }
        return arrM
    }
    var bidId: String {
        
        return (recommendBidViewModel?.bidModel.id)!
    }
    
    lazy var carousels = [CarouselViewModel]()
    
    func loadBanner() -> RACSignal {
        
        return RACSignal.createSignal({ (subscriber) -> RACDisposable! in
            
            APIManager.loadBanner().subscribeNext({ (result) -> Void in
                
                    let array = result as! [[String: AnyObject]]
                
                    for dict in array {
                        
                        self.carousels.append(CarouselViewModel(carouselModel: CarouselModel(dict: dict)))
                    }
                
                    subscriber.sendCompleted()
                
                }, error: { (error) -> Void in
                    
                    subscriber.sendError(error)
            })
            
            return RACDisposable(block: {})
        })
    }
    
    func loadNewerBid() -> RACSignal {
        
        
        return RACSignal.createSignal({ (subscriber) -> RACDisposable! in
            
            APIManager.loadNewerBid(nil).subscribeNext({ (result) -> Void in
                
                    let dict = result as! [String: AnyObject]
                    self.recommendBidViewModel = RecommendBidViewModel(bidModel: BidModel(dict: dict))
                    subscriber.sendCompleted()
                
                }, error: { (error) -> Void in
                    
                    subscriber.sendError(error)
            })
            
            return RACDisposable(block: {})
        })
        
    }
}
