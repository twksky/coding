//
//  NewerDeclareCellViewModel.swift
//  cxd4iphone
//
//  Created by hexy on 12/11/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit

let declareCellReuseId = "declareCellReuseId"

class DeclareCellViewModel: BaseCellViewModel {

    override var reuseId: String {
        
        return declareCellReuseId
    }

    
    var thumbURL : NSURL {
        
        
        return NSURL(string: "\(declareModel.imgRoot!)\(declareModel.thumb!)")!
    }
    
    var URLString: String {
        
        return "\(declareModel.node_url!)"
    }
    var title: String {
        
        return "\(declareModel.title!)"
    }
    var declareModel: DeclareModel
    
    init(declareModel: DeclareModel) {
        
        self.declareModel = declareModel
        
        super.init(icon: nil, title: nil, detail: nil, destVC: nil)
    }
}
