//
//  PickerView.swift
//  cxd4iphone
//
//  Created by hexy on 12/18/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit

private struct kConstraints {
    
    static let showRect: CGRect = CGRectMake(0, xx_screenHeight() * 0.4, xx_screenWidth(), xx_screenHeight() * 0.6)
    static let hideRect: CGRect = CGRectMake(0, xx_screenHeight(), xx_screenWidth(), xx_screenHeight() * 0.6)
}

class PickerView: UIView {

    let topView =  UIApplication.sharedApplication().keyWindow?.rootViewController?.view
    
    override init(frame: CGRect) {
        
        super.init(frame: CGRectMake(0, xx_screenHeight(), xx_screenWidth(), xx_screenHeight()/2))
        
        makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func makeUI() {
        
        self.backgroundColor = UIColor.whiteColor()
        
        let topWrap = UIView(bgColor: UIColor.whiteColor())
        
        self.addSubview(topWrap)
        topWrap.snp_makeConstraints { (make) -> Void in
            
            make.top.left.right.equalTo(self)
            make.height.equalTo(xx_height(40))
        }
        let cancel = UIButton(title: "取消", titleColor: Define.darkFontColor, titleSize: 14, bgColor: UIColor.whiteColor())
        cancel.addTarget(self, action: "hide", forControlEvents: .TouchUpInside)
        
        let sure = UIButton(title: "确定", titleColor: Define.darkFontColor, titleSize: 14, bgColor: UIColor.whiteColor())
        
        topWrap.addSubview(cancel)
        topWrap.addSubview(sure)
        
        cancel.snp_makeConstraints { (make) -> Void in
            
            make.top.left.height.equalTo(topWrap)
        }
        
        sure.snp_makeConstraints { (make) -> Void in
            
            make.left.equalTo(cancel.snp_right).offset(1)
            make.top.right.equalTo(topWrap)
            make.size.equalTo(cancel)
        }
        
        let vLine = UIView(bgColor: Define.separatorColor)
        let hLine = UIView(bgColor: Define.separatorColor)
        
        topWrap.addSubview(vLine)
        topWrap.addSubview(hLine)
        
        vLine.snp_makeConstraints { (make) -> Void in
            
            make.center.equalTo(topWrap)
            make.height.equalTo(xx_height(30))
            make.width.equalTo(0.5)
        }
        
        hLine.snp_makeConstraints { (make) -> Void in
            
            make.left.bottom.right.equalTo(topWrap)
            make.height.equalTo(0.5)
        }
        
        
        
        let bottomWrap = UIView()
        self.addSubview(bottomWrap)
        bottomWrap.snp_makeConstraints { (make) -> Void in
            
            make.top.equalTo(topWrap.snp_bottom)
            make.left.bottom.right.equalTo(self)
        }
        
        
        bottomWrap.addSubview(picker)
        picker.snp_makeConstraints { (make) -> Void in
            
            make.edges.equalTo(bottomWrap)
        }
    }

    func show() {
        
        topView?.addSubview(dimView)
        topView?.addSubview(self)
        
        UIView.animateWithDuration(0.2) { () -> Void in
            
            self.dimView.alpha = 0.5
            self.frame = kConstraints.showRect
        }

        
    }

    @objc private func hide() {
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in

                self.frame = kConstraints.hideRect
                self.dimView.alpha = 0.2
            
            }) { (Bool) -> Void in
                
                self.removeFromSuperview()
                self.dimView.removeFromSuperview()
        }
    }

    lazy var dimView: UIView = {
        
        let dim = UIView()
        dim.backgroundColor = UIColor.blackColor()
        dim.alpha = 0.2
        dim.frame = UIScreen.mainScreen().bounds
        
        let tap = UITapGestureRecognizer(target: self, action: "hide")
        dim.addGestureRecognizer(tap)
        return dim
    }()
    
    lazy var picker: UIPickerView = {
        
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        return picker
    }()
}

extension PickerView: UIPickerViewDataSource, UIPickerViewDelegate {
    
//    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
//        
//        return 2
//    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return 5
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return "哈哈哈哈"
    }
}























