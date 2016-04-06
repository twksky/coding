//
//  ChoiceFooterViewModel.swift
//  cxd4iphone
//
//  Created by hexy on 12/8/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit

class RecommendBidViewModel: NSObject {

    var bidModel: BidModel
    
 
    var minInvestMoney: String {
        
        return "\(bidModel.minInvestMoney)"
    }
    
    var lastTime: String {
        
        return "\(bidModel.deadline)"
    }
    // MARK: - 构造函数
    init(bidModel: BidModel) {
        self.bidModel = bidModel
        
        
        super.init()
    }

}
