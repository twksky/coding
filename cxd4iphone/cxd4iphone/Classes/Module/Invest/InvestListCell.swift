//
//  InvestListCell.swift
//  cxd4iphone
//
//  Created by hexy on 12/1/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit

class InvestListCell: BaseTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        selectionStyle = .None
    }

    override func updateUI(viewModel: BaseCellViewModel) {
        
//        xx_print("xxxxx")
//        let vm = viewModel as! InvestCellViewModel
//        xx_print(vm.bidModel.exceptTime)
//        titleLabel.text = vm.bidModel.loanPurpose!
//        timeLabel.text = vm.releaseTime
//        totalInvestNumLabel.text = vm.bidModel.loanMoney!
//        availableNumLabel.text = vm.bidModel.remainMoney!
        xx_removeAllChildViews(middleView)
//        makeRateView(vm.bidModel.rate!)
        makeCircleProgressView()
        
    }
    
    func makeTimeLastView(num: String, unit: String) {
        
//        let rateView = RateView(num: rate, numFontSize: 50, symbolFontSize: 19, isTipLabel: false)
//        
//        middleView.addSubview(rateView)
//        rateView.snp_makeConstraints { (make) -> Void in
//            
//            make.left.equalTo(middleView)
//            make.centerY.equalTo(middleView)
//        }
    }

    func makeRateView(rate: String) {
        
        let rateView = RateView(num: rate, numFontSize: 50, symbolFontSize: 19, isTipLabel: false)
        
        middleView.addSubview(rateView)
        rateView.snp_makeConstraints { (make) -> Void in
            
            make.left.equalTo(middleView)
            make.centerY.equalTo(middleView)
        }
    }
    
    func makeCircleProgressView() {
        
        let cpView = CircleProgressView()
        
        middleView.addSubview(cpView)
        cpView.snp_makeConstraints { (make) -> Void in
            
            make.centerY.right.equalTo(middleView)
            make.width.height.equalTo(xx_height(55))
        }
        cpView.progress = 0
    }
    override func makeUI() {
        self.accessoryType = .None
        self.backgroundColor = UIColor.whiteColor()
        
        // 顶部分割线
        let divideView = UIView()
        divideView.backgroundColor = xx_colorWithHex(hexValue: 0xf8f8f8)
        
        contentView.addSubview(divideView)
        divideView.snp_makeConstraints { (make) -> Void in
            
            make.top.left.right.equalTo(contentView)
            make.height.equalTo(10)
        }
        
        //投资标识
        contentView.addSubview(indentIV)
        indentIV.snp_makeConstraints { (make) -> Void in
            
            make.top.equalTo(divideView.snp_bottom).offset(5)
            make.left.equalTo(contentView)
        }
        
        
        // 顶部
        let topView = UIView()
//        topView.backgroundColor = xx_randomColor()
        
        contentView.addSubview(topView)
        topView.snp_makeConstraints { (make) -> Void in
            
            make.top.equalTo(divideView.snp_bottom)
            make.left.equalTo(contentView).offset(35)
            make.height.equalTo(30)
            make.right.equalTo(contentView).offset(-15)
        }
        
        // 产品名称
        topView.addSubview(titleLabel)
//        titleLabel.backgroundColor = xx_randomColor()
        titleLabel.snp_makeConstraints { (make) -> Void in
            
            make.top.left.equalTo(topView)
            make.centerY.equalTo(topView)
        }
        
        // 发布时间
        contentView.addSubview(timeLabel)
//        timeLabel.backgroundColor = xx_randomColor()
        timeLabel.snp_makeConstraints { (make) -> Void in
            
            make.top.right.equalTo(topView)
            make.centerY.equalTo(topView)
        }
        
        // 底部
        let bottomView = UIView()
//        bottomView.backgroundColor = xx_randomColor()
        
        contentView.addSubview(bottomView)
        bottomView.snp_makeConstraints { (make) -> Void in
            
            make.left.equalTo(contentView).offset(15)
            make.right.equalTo(contentView).offset(-15)
            make.bottom.equalTo(contentView)
            make.height.equalTo(30)
        }
        
        let hLine = UIView()
        hLine.backgroundColor = xx_colorWithHex(hexValue: 0xededed)
        
        bottomView.addSubview(hLine)
        hLine.snp_makeConstraints { (make) -> Void in
            
            make.top.left.right.equalTo(bottomView)
            make.height.equalTo(1)
        }
        
        let vLine = UIView()
        vLine.backgroundColor = xx_colorWithHex(hexValue: 0xededed)
        
        bottomView.addSubview(vLine)
        vLine.snp_makeConstraints { (make) -> Void in
            
            make.center.equalTo(bottomView)
            make.height.equalTo(16)
            make.width.equalTo(1)
        }
        
        let totalLabel = makeFormatView("项目总额", leftFontSize: 12, rightString: " (元)", rightFontSize: 9, texColor:  xx_colorWithHex(hexValue: 0x333333))
        
        bottomView.addSubview(totalLabel)
        totalLabel.snp_makeConstraints { (make) -> Void in
            
            make.left.centerY.equalTo(bottomView)
        }
        
        bottomView.addSubview(totalInvestNumLabel)
        totalInvestNumLabel.snp_makeConstraints { (make) -> Void in
            
            make.left.equalTo(totalLabel.snp_right).offset(3)
            make.centerY.equalTo(bottomView)
        }
        
        bottomView.addSubview(availableNumLabel)
        availableNumLabel.snp_makeConstraints { (make) -> Void in
            
            make.right.centerY.equalTo(bottomView)
        }
        
        let availableLabel = makeFormatView("可投金额", leftFontSize: 12, rightString: " (元)", rightFontSize: 9, texColor:  xx_colorWithHex(hexValue: 0x333333))
        
        bottomView.addSubview(availableLabel)
        availableLabel.snp_makeConstraints { (make) -> Void in
            
            make.right.equalTo(availableNumLabel.snp_left).offset(-3)
            make.centerY.equalTo(bottomView)
        }
        
        // 中间
//                middleView.backgroundColor = xx_randomColor()
        
        contentView.addSubview(middleView)
        middleView.snp_makeConstraints { (make) -> Void in
            
            make.edges.equalTo(UIEdgeInsetsMake(40, 15, -30, -15))
        }
        
        
        
    }
    
     /// 投资标识
    private lazy var indentIV = UIImageView(image: UIImage(named: "invest_newer"))
    private lazy var titleLabel = UILabel(title: "房屋抵押BJ1508021-10", fontColor: xx_colorWithHex(hexValue: 0x333333), bgColor: nil, fontSize: 15, maxWrapWidth: 0)
    private lazy var timeLabel = UILabel(title: "发布时间:2015-11-12", fontColor: xx_colorWithHex(hexValue: 0x999999), bgColor: nil, fontSize: 10, maxWrapWidth: 0)
    private lazy var totalInvestNumLabel = UILabel(title: "5,500,000", fontColor: xx_colorWithHex(hexValue: 0x333333), bgColor: nil, fontSize: 15, maxWrapWidth: 0)
    private lazy var availableNumLabel = UILabel(title: "1,500,000", fontColor: xx_colorWithHex(hexValue: 0x333333), bgColor: nil, fontSize: 15, maxWrapWidth: 0)

    private lazy var middleView = UIView(bgColor: UIColor.whiteColor())
    
    private func makeFormatView(leftString: String, leftFontSize: CGFloat, rightString: String, rightFontSize:CGFloat, texColor: UIColor) -> UIView {
        
        let format = UIView()
        
        let leftLabel = UILabel(title: leftString, fontColor: texColor, bgColor: nil, fontSize: leftFontSize, maxWrapWidth: 0)
        
        format.addSubview(leftLabel)
        leftLabel.snp_makeConstraints { (make) -> Void in
            
            make.top.left.bottom.equalTo(format)
        }
        let rightLabel = UILabel(title: rightString, fontColor: texColor, bgColor: nil, fontSize: rightFontSize, maxWrapWidth: 0)
        
        format.addSubview(rightLabel)
        rightLabel.snp_makeConstraints { (make) -> Void in
            
            make.left.equalTo(leftLabel.snp_right)
            make.bottom.equalTo(format).offset(-2)
            make.right.equalTo(format)
        }
        return format
    }
    
    
}
