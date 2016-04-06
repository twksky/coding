//
//  MyAccountListViewModel.swift
//  cxd4iphone
//
//  Created by hexy on 12/10/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit

class MyAccountListViewModel: BaseTableListViewModel {

    override init() {
        
        super.init()
        
        let bindMobileVM = BaseCellViewModel(icon: UIImage(named: "auth_tele")!, title: "手机绑定", detail: "186****006", destVC: DeclareViewController())
        
        let realNameVM = BaseCellViewModel(icon: UIImage(named: "auth_card")!, title: "实名认证", detail: "未认证", destVC: HelpCenterViewController())
        
        let bankCardVM = BaseCellViewModel(icon: UIImage(named: "auth_bankCard")!, title: "银行卡", detail: "未绑定", destVC: HelpCenterViewController())
        
        let loginPwdVM = BaseCellViewModel(icon: UIImage(named: "auth_pwd")!, title: "登录密码", detail: nil, destVC: nil)
        
        let tradePwdVM = BaseCellViewModel(icon: UIImage(named: "auth_pwd")!, title: "交易密码", detail: nil, destVC: FeedBackViewController())
        let gesturePwdVM = BaseCellViewModel(icon: UIImage(named: "auth_gesture")!, title: "手势", detail: nil, destVC: FeedBackViewController())
        let fingerPwdVM = BaseCellViewModel(icon: UIImage(named: "auth_finger")!, title: "指纹", detail: nil, destVC: FeedBackViewController())
        
        self.sections = [[bindMobileVM, realNameVM, bankCardVM],[loginPwdVM, tradePwdVM, gesturePwdVM, fingerPwdVM]]
    }

}
