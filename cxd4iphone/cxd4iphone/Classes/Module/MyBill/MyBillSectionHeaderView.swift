//
//  MyBillSectionHeaderView.swift
//  cxd4iphone
//
//  Created by hexy on 12/4/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit

class MyBillSectionHeaderView: UIView {

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeUI() {
        
        backgroundColor = Define.backgroundColor
        
//        let wrap = UIView(bgColor: xx_randomColor())
        let wrap = UIView()
        
        self.addSubview(wrap)
        wrap.snp_makeConstraints { (make) -> Void in
            
            make.edges.equalTo(UIEdgeInsetsMake(10, 15, -10, -15))
        }
        
        let timeLabel = makeLabel("时间")
        
        wrap.addSubview(timeLabel)
        timeLabel.snp_makeConstraints { (make) -> Void in
            
            make.left.centerY.equalTo(wrap)
        }
        
        let moneyLabel = makeLabel("金额")
        
        wrap.addSubview(moneyLabel)
        moneyLabel.snp_makeConstraints { (make) -> Void in
            
            make.left.equalTo(timeLabel.snp_right)
            make.centerY.equalTo(wrap)
            make.width.equalTo(timeLabel)
        }
        
        
        let balanceLabel = makeLabel("余额")
        
        wrap.addSubview(balanceLabel)
        balanceLabel.snp_makeConstraints { (make) -> Void in
            
            make.left.equalTo(moneyLabel.snp_right)
            make.centerY.equalTo(wrap)
            make.width.equalTo(timeLabel)
        }
        
        let typeLabel =  makeLabel("类型")
        
        wrap.addSubview(typeLabel)
        typeLabel.snp_makeConstraints { (make) -> Void in
            
            make.left.equalTo(balanceLabel.snp_right)
            make.centerY.equalTo(wrap)
            make.width.equalTo(timeLabel)
            make.right.equalTo(wrap)
        }

    }
    
    func makeLabel(text: String) -> UILabel {
        
//        return UILabel(title: text, fontColor: Define.darkFontColor, bgColor: xx_randomColor(), fontSize: 12, maxWrapWidth: 0)
        return UILabel(title: text, fontColor: Define.darkFontColor, bgColor: nil, fontSize: 12, maxWrapWidth: 0)
    }
    
}
