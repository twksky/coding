//
//  MeHeaderView.swift
//  cxd4iphone
//
//  Created by hexy on 11/24/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit

private struct kConstraints {
    
    static let backgroundColor: UIColor   = xx_colorWithHex(hexValue: 0xededed)
}

class UserIncomeTopView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var userIncomeViewModel: UserIncomeViewModel? {
        
        didSet {
            
            let vm = userIncomeViewModel!
            totalProfitLabel.text = vm.userIncomeModel.collectProfit!
            totalAssestsLabel.text = vm.userIncomeModel.totalMoney!
        }
    }
    
    private func makeUI() {
        
        backgroundColor = kConstraints.backgroundColor
        
        let iv = UIImageView(image: UIImage(named: "me_header_background"))
        
        addSubview(iv)
        iv.snp_makeConstraints { (make) -> Void in
            
            make.edges.equalTo(self)
        }
        
        let lb = UILabel(title: "累计收益 (元) :", fontColor: UIColor.whiteColor(), bgColor: nil, fontSize: 14, maxWrapWidth: 0)
        
        iv.addSubview(lb)
        lb.snp_makeConstraints { (make) -> Void in
            
            make.top.equalTo(iv).offset(18)
            make.left.equalTo(iv).offset(15)
        }
        
        
        iv.addSubview(totalProfitLabel)
        totalProfitLabel.snp_makeConstraints { (make) -> Void in
            
            make.center.equalTo(iv)
        }
        
        iv.addSubview(totalAssestsLabel)
        totalAssestsLabel.snp_makeConstraints { (make) -> Void in
            
            make.right.equalTo(iv).offset(-15)
            make.bottom.equalTo(iv).offset(-12)
            make.width.greaterThanOrEqualTo(10)
        }
        
        let tlb = UILabel(title: "资产总额 (元) :", fontColor: UIColor.whiteColor(), bgColor: nil, fontSize: 14, maxWrapWidth: 0)
        
        iv.addSubview(tlb)
        tlb.snp_makeConstraints { (make) -> Void in
            
            make.right.equalTo(totalAssestsLabel.snp_left).offset(-3)
            make.centerY.equalTo(totalAssestsLabel)
        }
        
    }
    
    lazy var totalProfitLabel = UILabel(title: "0.00", fontColor: UIColor.whiteColor(), bgColor: nil, fontSize: 40, maxWrapWidth: 0)
    
    lazy var totalAssestsLabel = UILabel(title: "0.00", fontColor: UIColor.whiteColor(), bgColor: nil, fontSize: 18, maxWrapWidth: 0)
    
}


