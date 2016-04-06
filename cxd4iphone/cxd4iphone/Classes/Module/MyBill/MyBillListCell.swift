//
//  MyBillListCell.swift
//  cxd4iphone
//
//  Created by hexy on 12/15/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit

class MyBillListCell: BaseTableViewCell {

    
    override func makeUI() {
        self.accessoryType = .None
        
//        let wrap = UIView(bgColor: UIColor.orangeColor())
        let wrap = UIView()
        
        contentView.addSubview(wrap)
        wrap.snp_makeConstraints { (make) -> Void in
            
            make.edges.equalTo(UIEdgeInsetsMake(0, 15, -10, -15))
        }
        let line = UIView(bgColor: Define.separatorColor)
        contentView.addSubview(line)
        line.snp_makeConstraints { (make) -> Void in
            
            make.left.bottom.right.equalTo(contentView)
            make.height.equalTo(0.5)
        }
        
        
//        let topView = UIView(bgColor: UIColor.orangeColor())
        let topView = UIView()
        
        wrap.addSubview(topView)
        topView.snp_makeConstraints { (make) -> Void in
            
            make.top.left.right.equalTo(wrap)
            make.height.equalTo(xx_height(30))
        }
       
        
        topView.addSubview(timeLabel)
        timeLabel.snp_makeConstraints { (make) -> Void in
            
            make.left.centerY.equalTo(topView)
        }
        
        
        topView.addSubview(moneyLabel)
        moneyLabel.snp_makeConstraints { (make) -> Void in
            
            make.left.equalTo(timeLabel.snp_right)
            make.centerY.equalTo(topView)
            make.width.equalTo(timeLabel)
        }
        
        
        topView.addSubview(balanceLabel)
        balanceLabel.snp_makeConstraints { (make) -> Void in
            
            make.left.equalTo(moneyLabel.snp_right)
            make.centerY.equalTo(topView)
            make.width.equalTo(timeLabel)
        }
        
        
        topView.addSubview(typeLabel)
        typeLabel.snp_makeConstraints { (make) -> Void in
            
            make.left.equalTo(balanceLabel.snp_right)
            make.centerY.equalTo(topView)
            make.width.equalTo(timeLabel)
            make.right.equalTo(topView)
        }
        
    }
    
    
    lazy var timeLabel = UILabel(title: "2015-11-12", fontColor: Define.darkFontColor, bgColor: nil, fontSize: 12, maxWrapWidth: 0)
    lazy var moneyLabel = UILabel(title: "2000", fontColor: Define.darkFontColor, bgColor: nil, fontSize: 12, maxWrapWidth: 0)
    lazy var balanceLabel = UILabel(title: "200000", fontColor: Define.darkFontColor, bgColor: nil, fontSize: 12, maxWrapWidth: 0)
    lazy var typeLabel = UILabel(title: "投资成功", fontColor: Define.darkFontColor, bgColor: nil, fontSize: 12, maxWrapWidth: 0)
    
    lazy var rightBtn: UIButton = {
        
        let btn = UIButton(type: UIButtonType.InfoLight)
        btn.rac_signalForControlEvents(.TouchUpInside).subscribeNext({ (sender) -> Void in
            
            xx_print(sender)
        })
        return btn
    }()
}
