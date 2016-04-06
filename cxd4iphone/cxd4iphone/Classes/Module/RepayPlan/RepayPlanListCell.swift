//
//  RepayScheduleListCell.swift
//  cxd4iphone
//
//  Created by hexy on 12/22/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit

class RepayPlanListCell: BaseTableViewCell {

    override func updateUI(viewModel: BaseCellViewModel) {
        
    }
    
    override func makeUI() {
        
        self.accessoryType = .None
        self.backgroundColor = Define.backgroundColor
        
        let wrap = UIView(bgColor: UIColor.whiteColor())
        
        contentView.addSubview(wrap)
        wrap.snp_makeConstraints { (make) -> Void in
            
            make.edges.equalTo(UIEdgeInsetsMake(xx_height(10), 0, 0, 0))
        }
        
        let hLine = UIView(bgColor: Define.separatorColor)
        
        wrap.addSubview(hLine)
        hLine.snp_makeConstraints { (make) -> Void in
            
            make.left.right.equalTo(wrap)
            make.height.equalTo(0.5)
            make.top.equalTo(wrap).offset(xx_height(30))
        }
        
        
    }
}
