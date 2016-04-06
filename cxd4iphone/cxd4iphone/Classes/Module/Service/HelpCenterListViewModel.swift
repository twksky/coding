//
//  HelpCenterListViewModel.swift
//  cxd4iphone
//
//  Created by hexy on 12/11/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit

class HelpCenterListViewModel: BaseTableListViewModel {

    override init() {
        
        super.init()
        
        
        let vm1 = BaseCellViewModel(icon: nil, title: "新手指引", detail: nil, destVC: WebViewController(URLStr: "http://www.baidu.com"))
        
        let vm2 = BaseCellViewModel(icon: nil, title: "资费说明", detail: nil, destVC: WebViewController(URLStr: "http://www.baidu.com"))
        
        let vm3 = BaseCellViewModel(icon:nil, title: "登录/注册", detail: nil, destVC: WebViewController(URLStr: "http://www.baidu.com"))
        
        let vm4 = BaseCellViewModel(icon: nil, title: "充值/提现", detail: nil, destVC: WebViewController(URLStr: "http://www.baidu.com"))
        
        let vm5 = BaseCellViewModel(icon: nil, title: "投资/交易记录", detail: nil, destVC: WebViewController(URLStr: "http://www.baidu.com"))
        let vm6 = BaseCellViewModel(icon: nil, title: "了解投资产品", detail: nil, destVC: WebViewController(URLStr: "http://www.baidu.com"))
        
        self.sections = [[vm1, vm2, vm3, vm4, vm5, vm6]]
    }
}
