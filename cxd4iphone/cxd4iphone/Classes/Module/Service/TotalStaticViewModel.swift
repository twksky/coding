//
//  ServiceHeaderViewModel.swift
//  cxd4iphone
//
//  Created by hexy on 11/30/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit

class TotalStaticViewModel: NSObject {

    
    var staticModel: TotalInvestStaticModel
    
    
    var tradeBillion: String {
        
        return formatter(staticModel.totalMoney!).b!
    }
    var tradeMillion: String {
    
        return formatter(staticModel.totalMoney!).m!
    }
    var tradeUnit: String {
        
        return formatter(staticModel.totalMoney!).u!
    }
    
    var profitBillion: String? {
        
        return formatter(staticModel.totalProfit!).b
    }
    var profitMillion: String {
        
        return formatter(staticModel.totalProfit!).m!
    }
    var profitUnit: String {
        
       return formatter(staticModel.totalProfit!).u!
    }
    
    // MARK: - 构造函数
    init(staticModel: TotalInvestStaticModel) {
        
        self.staticModel = staticModel
        
        super.init()
    }
    
    
    func formatter(num: String) -> Formatter {
        
        let fo = Formatter()
        
        let str = num as NSString
        
        let len = xx_length(num)
        
        if len > 8 {
            
            let index = len % 8
            fo.b = str.substringToIndex(index)
            fo.m = str.substringWithRange(NSMakeRange(index * 1, 4))
            fo.u = str.substringWithRange(NSMakeRange(index * 2, 4))
            
        } else if 8 == len {
            
            fo.b = nil
            fo.m = str.substringToIndex(4)
            fo.u = str.substringFromIndex(4)
            
        } else if len > 4 {
            
            let index = len % 4
            fo.b = nil
            fo.m = str.substringToIndex(index)
            fo.u = str.substringWithRange(NSMakeRange(index * 1, 4))
            
        } else {
            
            fo.b = nil
            fo.m = nil
            fo.u = str.substringToIndex(len)
        }
    
        return fo
    }

}
class Formatter:NSObject {
    
    var b: String?
    var m: String?
    var u: String?
}
