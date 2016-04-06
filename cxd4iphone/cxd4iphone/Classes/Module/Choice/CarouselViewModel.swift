//
//  CarouselViewModel.swift
//  cxd4iphone
//
//  Created by hexy on 12/17/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit

class CarouselViewModel: NSObject {

    var carouselModel: CarouselModel
    
    var imageURL: NSURL {
        
        return NSURL(string: "\(carouselModel.imgRootUrl!)\(carouselModel.location!)")!
    }
    
    
    // MARK: - 构造函数
    init(carouselModel: CarouselModel) {
        
        self.carouselModel = carouselModel
        
        super.init()
    }

}
