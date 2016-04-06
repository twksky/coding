//
//  ServiceHeaderView.swift
//  cxd4iphone
//
//  Created by hexy on 11/30/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit

private struct kConstraints {
    
    static let hackMargin: CGFloat   = ((xx_rateWidth() == 1.0) ? -4 : -5)
    static let marginLeft: CGFloat   = 2
    static let numLeft: CGFloat   = -1
    static let bottomTextColor: UIColor  = xx_colorWithHex(hexValue: 0xa6c3ff)
}

class TotalStaticView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var totalStaticViewModel: TotalStaticViewModel? {
        
        didSet {
            let vm = totalStaticViewModel!
            xx_print(vm)
            makeTradeView(vm.tradeBillion, millionNumStr: vm.tradeMillion, unitNumStr: vm.tradeUnit)
            makeProfit(vm.profitBillion, millionNumStr: vm.profitMillion, unitNumStr: vm.profitUnit)
            makeBailView(nil, millionNumStr: "1000")
            makeBadDebtView("0", millionNumStr: "0", unitNumStr: "0", exceedNum: "0")
        }
    }
    private lazy var topLeftWrap = UIView()
    private lazy var topRightWrap = UIView()
    private lazy var bottomLeftWrap = UIView()
    private lazy var bottomRightWrap = UIView()
    
    private func makeUI() {
        
        let iv = UIImageView(image: UIImage(named: "service_header"))
        addSubview(iv)
        
        iv.snp_makeConstraints { (make) -> Void in
            
            make.edges.equalTo(self)
        }
        
        addSubview(topLeftWrap)
        addSubview(topRightWrap)
        addSubview(bottomLeftWrap)
        addSubview(bottomRightWrap)
        
        topLeftWrap.snp_makeConstraints { (make) -> Void in
            
            make.top.left.equalTo(self)
        }
        
        topRightWrap.snp_makeConstraints { (make) -> Void in
            
            make.top.right.equalTo(self)
            make.left.equalTo(topLeftWrap.snp_right)
            make.width.equalTo(topLeftWrap)
        }
        
        bottomLeftWrap.snp_makeConstraints { (make) -> Void in
            
            make.top.equalTo(topLeftWrap.snp_bottom)
            make.left.bottom.equalTo(self)
            make.width.height.equalTo(topLeftWrap)
        }
        
        bottomRightWrap.snp_makeConstraints { (make) -> Void in
            
            make.top.equalTo(topRightWrap.snp_bottom)
            make.left.equalTo(bottomLeftWrap.snp_right)
            make.right.bottom.equalTo(self)
            make.width.height.equalTo(topLeftWrap)
        }
        
        
        let tradeLabel = createLabel("诚信贷累计交易金额", fontColor: nil, fontSize: nil)
        let profitLabel = createLabel("理财用户在诚信贷赚取", fontColor: nil, fontSize: nil)
        let badDebtLabel = createLabel("至今坏账/逾期", fontColor: kConstraints.bottomTextColor, fontSize: nil)
        let bailLabel = createLabel("理财保证金", fontColor: kConstraints.bottomTextColor, fontSize: nil)
        
        topLeftWrap.addSubview(tradeLabel)
        topRightWrap.addSubview(profitLabel)
        bottomRightWrap.addSubview(badDebtLabel)
        bottomLeftWrap.addSubview(bailLabel)
        
        tradeLabel.snp_makeConstraints { (make) -> Void in
            
            make.centerX.equalTo(topLeftWrap)
            make.bottom.equalTo(topLeftWrap)
        }
        
        
        profitLabel.snp_makeConstraints { (make) -> Void in
            
            make.centerX.equalTo(topRightWrap)
            make.bottom.equalTo(tradeLabel)
        }
        
        badDebtLabel.snp_makeConstraints { (make) -> Void in
            
            make.centerX.equalTo(bottomRightWrap)
            make.bottom.equalTo(bottomRightWrap).offset(-5)
        }
        
        bailLabel.snp_makeConstraints { (make) -> Void in
            
            make.centerX.equalTo(bottomLeftWrap)
            make.bottom.equalTo(badDebtLabel)
        }
    }
    
}
extension TotalStaticView {
    
    private func createLabel(title: String, fontColor: UIColor?, fontSize: CGFloat?) -> UILabel {
        
        
        return UILabel(title: title, fontColor: (fontColor ?? UIColor.whiteColor()), bgColor: nil, fontSize: (fontSize ?? 10), maxWrapWidth: 0)
    }

    private func makeTradeView(billionNumStr: String, millionNumStr: String, unitNumStr: String) {
        
        let tradeWrap =  createThreeNumFormatView(billionNumStr, numTwoString: millionNumStr, numThreeString: unitNumStr, textColor: UIColor.whiteColor())
        
        topLeftWrap.addSubview(tradeWrap)
        tradeWrap.snp_makeConstraints { (make) -> Void in
            
            make.center.equalTo(topLeftWrap)
        }

    }
    
    private func makeProfit(billionNumStr: String?, millionNumStr: String, unitNumStr: String) {
        
        if billionNumStr != nil {
            
            let profitWrap = createThreeNumFormatView(billionNumStr!, numTwoString: millionNumStr, numThreeString: unitNumStr, textColor: UIColor.whiteColor())
            
            topRightWrap.addSubview(profitWrap)
            profitWrap.snp_makeConstraints { (make) -> Void in
                
                make.center.equalTo(topRightWrap)
            }
            
        } else {
            
            let profitWrap = createTwoNumFormatView(millionNumStr, numOneUnitString: "万", numTwoString: unitNumStr, numTwoUnitString: "元", textColor: UIColor.whiteColor())
            
            topRightWrap.addSubview(profitWrap)
            profitWrap.snp_makeConstraints { (make) -> Void in
                
                make.center.equalTo(topRightWrap)
            }
        }
        
    }
    
    private func makeBailView(billionNumStr: String?, millionNumStr: String) {
        
        if billionNumStr != nil {
            
            let profitWrap = createTwoNumFormatView(billionNumStr!, numOneUnitString: "亿", numTwoString: millionNumStr, numTwoUnitString: "万", textColor: kConstraints.bottomTextColor)
            
            bottomLeftWrap.addSubview(profitWrap)
            profitWrap.snp_makeConstraints { (make) -> Void in
                
                make.center.equalTo(bottomLeftWrap)
            }
            
        } else {
            
            let profitWrap = createNumFormatView(millionNumStr, unitString: "万", textColor: kConstraints.bottomTextColor)
            
            bottomLeftWrap.addSubview(profitWrap)
            profitWrap.snp_makeConstraints { (make) -> Void in
                
                make.center.equalTo(bottomLeftWrap)
            }
        }
        
    }
    
    private func makeBadDebtView(billionNumStr: String, millionNumStr: String, unitNumStr: String, exceedNum: String) {
        
        let wrap = UIView()
        
        bottomRightWrap.addSubview(wrap)
        wrap.snp_makeConstraints { (make) -> Void in
            
            make.center.equalTo(bottomRightWrap)
        }
        
        let badDebtView = createNumFormatView("0", unitString: "元", textColor: kConstraints.bottomTextColor)
//        let badDebtView = createTwoNumFormatView("1000", numOneUnitString: "万", numTwoString: "2345", numTwoUnitString: "元", textColor: kConstraints.bottomTextColor)
//        let badDebtView = createThreeNumFormatView("1", numTwoString: "2340", numThreeString: "460", textColor: kConstraints.bottomTextColor)
        wrap.addSubview(badDebtView)
        badDebtView.snp_makeConstraints { (make) -> Void in
            
            make.top.left.bottom.equalTo(wrap)
        }
        
        let bais = UILabel(title: "/", fontColor: kConstraints.bottomTextColor, bgColor: nil, fontSize: 15, maxWrapWidth: 0)
//        bais.backgroundColor = xx_randomColor()
        wrap.addSubview(bais)
        bais.snp_makeConstraints { (make) -> Void in
            
            make.left.equalTo(badDebtView.snp_right).offset(1)
            make.centerY.equalTo(wrap)//.offset(1)
//            make.right.equalTo(wrap)
        }
        
        let exceedView = createNumFormatView("0", unitString: "期", textColor: kConstraints.bottomTextColor)
        
        wrap.addSubview(exceedView)
        exceedView.snp_makeConstraints { (make) -> Void in
            
            make.left.equalTo(bais.snp_right).offset(1)
            make.top.bottom.right.equalTo(wrap)
        }
    }
    
    private func createThreeNumFormatView(numOneString: String, numTwoString: String, numThreeString: String, textColor: UIColor) -> UIView {
        
        let tradeWrap = UIView()
        
        let billionView = createNumFormatView(numOneString, unitString: "亿", textColor: textColor)
        
        tradeWrap.addSubview(billionView)
        billionView.snp_makeConstraints(closure: { (make) -> Void in
            
            make.top.left.bottom.equalTo(tradeWrap)
        })
        
        let millionView = createNumFormatView(numTwoString, unitString: "万", textColor: textColor)
        
        tradeWrap.addSubview(millionView)
        millionView.snp_makeConstraints(closure: { (make) -> Void in
            
            make.left.equalTo(billionView.snp_right).offset(kConstraints.marginLeft)
            make.top.bottom.equalTo(tradeWrap)
        })
        
        let unitView = createNumFormatView(numThreeString, unitString: "元", textColor: textColor)
        
        tradeWrap.addSubview(unitView)
        unitView.snp_makeConstraints(closure: { (make) -> Void in
            
            make.left.equalTo(millionView.snp_right).offset(kConstraints.marginLeft)
            make.top.bottom.right.equalTo(tradeWrap)
        })
        return tradeWrap
    }
    
    private func createTwoNumFormatView(numOneString: String, numOneUnitString: String, numTwoString: String, numTwoUnitString: String, textColor: UIColor) -> UIView {
        
        let profitWrap = UIView()
        
        let millionView = createNumFormatView(numOneString, unitString: numOneUnitString, textColor: textColor)
        
        profitWrap.addSubview(millionView)
        millionView.snp_makeConstraints(closure: { (make) -> Void in
            
            make.top.left.bottom.equalTo(profitWrap)
        })
        
        let unitView = createNumFormatView(numTwoString, unitString: numTwoUnitString, textColor: textColor)
        
        profitWrap.addSubview(unitView)
        unitView.snp_makeConstraints(closure: { (make) -> Void in
            
            make.left.equalTo(millionView.snp_right).offset(kConstraints.marginLeft)
            make.top.bottom.right.equalTo(profitWrap)
        })
        
        return profitWrap
    }

    private func createNumFormatView(numString: String, unitString: String, textColor: UIColor) -> UIView {
        
        let formatView = UIView()
        
        let numStringLabel = createLabel(numString, fontColor: textColor, fontSize: 20)
        
        formatView.addSubview(numStringLabel)
        numStringLabel.snp_makeConstraints { (make) -> Void in
            
            make.top.left.bottom.equalTo(formatView)
        }
        
        let unitLabel = createLabel(unitString, fontColor: textColor, fontSize: 10)
        
        formatView.addSubview(unitLabel)
        unitLabel.snp_makeConstraints { (make) -> Void in
            
            make.left.equalTo(numStringLabel.snp_right).offset(kConstraints.numLeft)
            make.bottom.equalTo(numStringLabel).offset(kConstraints.hackMargin)
            make.right.equalTo(formatView)
        }

        return formatView
    }
    
}