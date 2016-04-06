//
//  InvestCellViewModel.swift
//  cxd4iphone
//
//  Created by hexy on 12/10/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit

let InvestCellReuseID = "InvestCellReuseID"

class InvestCellViewModel: BaseCellViewModel {

    override var reuseId: String {
        
        return InvestCellReuseID
    }
    
    var releaseTime: String {
        
        return "发布时间:\(bidModel.exceptTime!)"
    }

    var bidModel: BidModel
    
    init(bidModel: BidModel) {
        
        self.bidModel = bidModel
        
        super.init(icon: nil, title: nil, detail: nil, destVC: nil)
    }
}
