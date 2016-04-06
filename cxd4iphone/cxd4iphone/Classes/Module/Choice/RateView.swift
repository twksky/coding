//
//  self.swift
//  cxd4iphone
//
//  Created by hexy on 12/16/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit

class RateView: UIView {
    
    private var _num: String = "20"
    private var _numFontSize: CGFloat = 0
    private var _symbolFontSize: CGFloat = 0
    private var _isTipLabel: Bool = true
    
    init(num: String, numFontSize: CGFloat, symbolFontSize: CGFloat, isTipLabel: Bool) {
        super.init(frame: CGRectZero)
        
        _num = num
        _numFontSize = numFontSize
        _symbolFontSize = symbolFontSize
        _isTipLabel = isTipLabel

        makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeUI() {
        
        let numLabel = UILabel(title: _num, fontColor: Define.redColor, bgColor: nil, fontSize: _numFontSize, maxWrapWidth: 0)
        self.addSubview(numLabel)
        numLabel.snp_makeConstraints { (make) -> Void in
            
            make.top.left.bottom.equalTo(self)
        }
        
        
        let symbolLabel =  UILabel(title: "%", fontColor:Define.redColor, bgColor: nil, fontSize: _symbolFontSize, maxWrapWidth: 0)
        
        self.addSubview(symbolLabel)
        symbolLabel.snp_makeConstraints { (make) -> Void in
            
            make.left.equalTo(numLabel.snp_right)
            make.right.equalTo(self)
            make.centerY.equalTo(numLabel).offset(xx_folat(_symbolFontSize/1.8))
        }
        
        if !_isTipLabel {
            return
        }
        let tipLabel =  UILabel(title: "年化收益率", fontColor:Define.lightFontColor, bgColor: nil, fontSize: 12, maxWrapWidth: 0)
        
        self.addSubview(tipLabel)
        tipLabel.snp_makeConstraints { (make) -> Void in
            
            make.centerX.equalTo(self)
            make.centerY.equalTo(symbolLabel.snp_bottom).offset(-xx_folat(4))
        }
    }
    
}
