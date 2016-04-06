//
//  FeedBackViewController.swift
//  cxd4iphone
//
//  Created by hexy on 12/10/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit

private struct kConstraints {
    
    static let headerRect: CGRect    = CGRectMake(0, 0, xx_screenWidth(), xx_height(300))
}


class FeedBackViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func makeTableView() {
        
        tableView.tableHeaderView = header
        
        header.feedbackTextView.rac_textSignal().filter { (feedback) -> Bool in
            
            return (feedback as! String).lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0
            
        }.subscribeNext { (feedback) -> Void in
            
            self.header.placeholderLabel.hidden = true
            self.header.submitBtn.enabled = true
        }
        
        header.submitBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (sender) -> Void in
            
            xx_showHUD(nil)
            APIManager.feedback(self.header.feedbackTextView.text).subscribeNext({ (result) -> Void in
                
//                    xx_hideHUD()
                    xx_showInfo("我们已经收到您的反馈，会尽快处理！")
                
                }, error: { (error) -> Void in
                    
//                    xx_hideHUD()
//                    xx_print(error)
                    xx_showError(NSError(domain: "", code: 404, userInfo: ["msg": "哈哈发货"]))
                    
                }, completed: { () -> Void in
                    
//                    xx_hideHUD()
                    self.header.feedbackTextView.text = nil
                    self.view.endEditing(true)
                    self.header.placeholderLabel.hidden = false
                    (sender as! UIButton).enabled = false
            })
            
        }
    }
    private lazy var header = FeedBackView(frame: kConstraints.headerRect)
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if AccountViewModel.shared.userLogin {
            
            let al = UIAlertView(title: "提示", message: "您还没有登录,不能给我们反馈,是否现在去登录？", delegate: self, cancelButtonTitle: "算了", otherButtonTitles: "登录吧")
            al.show()
            
            header.feedbackTextView.editable = false
            
        } else {
            
            header.feedbackTextView.editable = true
        }
    }

}

extension FeedBackViewController: UIAlertViewDelegate {
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if 1 == buttonIndex {
            
            let nav = NavigationController(rootViewController:LoginViewController(aTitle: "登录"))
            self.presentViewController(nav, animated: true, completion: {})
            
        } else {
            
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
}
