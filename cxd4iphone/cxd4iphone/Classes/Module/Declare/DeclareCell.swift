//
//  NewerDeclareCell.swift
//  cxd4iphone
//
//  Created by hexy on 12/11/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit
import Kingfisher

class DeclareCell: BaseTableViewCell {

    
    override func updateUI(viewModel: BaseCellViewModel) {
        
        let vm = viewModel as! DeclareCellViewModel
        
        bannerIv.kf_showIndicatorWhenLoading = true
        bannerIv.kf_setImageWithURL(vm.thumbURL, placeholderImage: nil, optionsInfo: [.Transition(ImageTransition.Fade(1))])
        
        timeLabel.text = vm.declareModel.create_time
    }
    override func makeUI() {
        
        
        self.accessoryType = .None
        self.selectionStyle = .None
        backgroundColor = xx_colorWithHex(hexValue: 0xf8f8f8)
        
        let wrap = UIView()
        
        contentView.addSubview(wrap)
        wrap.snp_makeConstraints { (make) -> Void in
            
            make.edges.equalTo(UIEdgeInsetsMake(15, 15, -5, -15))
        }
        
        wrap.addSubview(bannerIv)
        bannerIv.snp_makeConstraints { (make) -> Void in
            
            make.top.left.right.equalTo(wrap)
            make.height.equalTo(xx_height(120))
        }
        
        wrap.addSubview(timeLabel)
        timeLabel.snp_makeConstraints { (make) -> Void in
            
            make.top.equalTo(bannerIv.snp_bottom).offset(xx_height(1))
            make.left.right.equalTo(wrap)
        }
        
        let vLine = UIView(bgColor: xx_colorWithHex(hexValue: 0xededed))
        
        wrap.addSubview(vLine)
        vLine.snp_makeConstraints { (make) -> Void in
            
            make.left.bottom.right.equalTo(wrap)
            make.height.equalTo(1)
        }
    }
    
    lazy var bannerIv = UIImageView(image: UIImage(named: "me_header_background"))
    lazy var timeLabel = UILabel(title: "2015-11-25", fontColor: xx_colorWithHex(hexValue: 0x999999), bgColor: UIColor.clearColor(), fontSize: 12, maxWrapWidth: 0)
    
}
