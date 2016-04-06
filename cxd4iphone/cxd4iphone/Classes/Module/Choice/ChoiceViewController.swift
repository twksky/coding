//
//  ChoiceViewController.swift
//  cxd4iphone
//
//  Created by hexy on 15/11/19.
//  Copyright © 2015年 hexy. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SVProgressHUD
import AttributedLabel

private struct kConstraints {
    
    static let headerRect: CGRect = CGRectMake(0, 0, xx_screenWidth(), xx_height(150))
    static let footerRect: CGRect = CGRectMake(0, 0, xx_screenWidth(), xx_screenHeight()-49-xx_height(150))
}

class ChoiceViewController: BaseTableViewController {
    
    private lazy var choiceListViewModel = ChoiceListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        choiceListViewModel.loadBanner().subscribeError({ (error) -> Void in
            
                xx_print(error)
            
            }) { () -> Void in
                
                self.carousel.setImages(self.choiceListViewModel.imageURLs, timeInterval: nil, clickImageBlock: { (index) -> () in
                    
                    self.pushToCarouselDetail(index)
                })
        }
        
        
        choiceListViewModel.loadNewerBid().subscribeNext({ (_) -> Void in
            
            }, error: { (error) -> Void in
                
                xx_print(error)
            }) { () -> Void in
                
                self.recommend.recommendBidViewModel = self.choiceListViewModel.recommendBidViewModel
        }
        
        xx_print(AccountViewModel.shared.userLogin)
    }

    


    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBarHidden = false
    }
    
    override func makeTableView() {
        
        self.tableListViewModel = choiceListViewModel
        
        automaticallyAdjustsScrollViewInsets = false
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.tableHeaderView = carousel
        tableView.tableFooterView = recommend
        
    }
    
    func pushToCarouselDetail(index: Int) {
        
        let URLStr = choiceListViewModel.carousels[index].carouselModel.url!
        let title = choiceListViewModel.carousels[index].carouselModel.title!
        
        let vc = WebViewController(URLStr: URLStr)
        vc.title = title
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private lazy var carousel = CarouselView(frame: kConstraints.headerRect)
    
    private lazy var recommend: ChoiceFooterView = {
        
        let recommend = ChoiceFooterView(frame: kConstraints.footerRect)
        
        recommend.profitBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (_) -> Void in
            
            self.navigationController?.pushViewController(BuyViewController(bidID: self.choiceListViewModel.bidId), animated: true)
            
        }
        return recommend
    }()
    
}
