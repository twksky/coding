//
//  FeedBackView.swift
//  cxd4iphone
//
//  Created by hexy on 12/11/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit

class FeedBackView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeUI() {
        
//        backgroundColor = xx_randomColor()
        
        let wrap = UIView()
        
        self.addSubview(wrap)
        wrap.snp_makeConstraints { (make) -> Void in
            
            make.edges.equalTo(UIEdgeInsetsMake(20, 15, -20, -15))
        }
        
        
        wrap.addSubview(feedbackTextView)
        feedbackTextView.snp_makeConstraints { (make) -> Void in
            
            make.top.left.right.equalTo(wrap)
            make.height.equalTo(xx_height(180))
        }
        
        wrap.addSubview(placeholderLabel)
        placeholderLabel.snp_makeConstraints { (make) -> Void in
            
            make.top.equalTo(feedbackTextView).offset(8)
            make.left.equalTo(feedbackTextView).offset(13)
        }

        wrap.addSubview(submitBtn)
        submitBtn.snp_makeConstraints { (make) -> Void in
            
            make.left.bottom.right.equalTo(wrap)
            make.height.equalTo(xx_height(40))
        }
    }

    
    lazy var feedbackTextView: UITextView = {
        
        let tv = UITextView(bgColor: UIColor.whiteColor())
        tv.textContainerInset = UIEdgeInsetsMake(10, 10, 0, 10)
        tv.font = xx_fontOfSize(size: 16)
        tv.layer.cornerRadius = 3
        return tv
    }()
    
    lazy var placeholderLabel = UILabel(title: "请输入您的反馈意见", fontColor: Define.moreLightFontColor, bgColor: nil, fontSize: 14, maxWrapWidth: 0)
    
    lazy var submitBtn: UIButton = {
        
        let btn = UIButton(title: "提 交", titleColor: UIColor.whiteColor(), titleSize: 18, bgColor: Define.redColor)
        btn.setBackgroundImage(UIImage.createImgaeWithColor(Define.grayColor), forState: .Disabled)
        btn.enabled = false
        return btn
    }()
}
