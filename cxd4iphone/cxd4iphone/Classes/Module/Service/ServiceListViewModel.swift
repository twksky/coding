//
//  ServiceListViewModel.swift
//  cxd4iphone
//
//  Created by hexy on 12/10/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit
import ReactiveCocoa


class ServiceListViewModel: BaseTableListViewModel {

    var totalStaticViewModel: TotalStaticViewModel?
    
    
    func loadTotalInvestStatic() -> RACSignal {
        
        return RACSignal.createSignal({ (subscriber) -> RACDisposable! in
            
            APIManager.loadTotalInvestStatic().subscribeNext({ (result) -> Void in
                
//                                    xx_print(dict)
                // 字典转模型。。。。
//                xx_JsonPrint(dict: (tuple[2] as! NSDictionary)["result"]!)
                //                    subscriber.sendNext(tuple[2])
                    self.totalStaticViewModel = TotalStaticViewModel(staticModel: TotalInvestStaticModel(dict: result as! [String: AnyObject]))
                    subscriber.sendCompleted()
                
                }, error: { (error) -> Void in
                    
                    //                    xx_print(error)
                    subscriber.sendError(error)
            })
            
            return RACDisposable(block: {})
        })
    }
    
    override init() {
        
        super.init()
        
        
        let declareVM = BaseCellViewModel(icon: UIImage(named: "service_notice")!, title: "最新公告", detail: nil, destVC: DeclareViewController())
        
        let aboutUsVM = BaseCellViewModel(icon: UIImage(named: "service_about")!, title: "关于我们", detail: nil, destVC: WebViewController(URLStr: "http://192.168.1.116:8082/tpl/help_center/reg.html"))
        
        let helpVM = BaseCellViewModel(icon: UIImage(named: "service_help")!, title: "帮助中心", detail: nil, destVC: HelpCenterViewController())
        
        let giveMarkVM = BaseCellViewModel(icon: UIImage(named: "service_mark")!, title: "给我评分", detail: nil, destVC: nil)
        
        let feedBackVM = BaseCellViewModel(icon: UIImage(named: "service_suggest")!, title: "意见反馈", detail: nil, destVC: FeedBackViewController())
        
        self.sections = [[declareVM, aboutUsVM, helpVM],[giveMarkVM, feedBackVM]]
    }
}
