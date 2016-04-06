//
//  RegistViewController.swift
//  cxd4iphone
//
//  Created by hexy on 12/8/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit

private struct kConstraints {
    
    static let headerHeight: CGFloat = xx_height(200)
    static let headerRect: CGRect    = CGRectMake(0, 0, xx_screenWidth(), kConstraints.headerHeight)
}

class AuthCodeViewController: BaseTableViewController {

    convenience init(nextVC: UIViewController) {
        
        self.init()
        self.nextVC = nextVC
        self.title = "手机号"
    }
    
    private var nextVC: UIViewController?
    private var timer: NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        header.checkBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (sender) -> Void in
            
            self.header.checkCodeTextField.becomeFirstResponder()
            
            let checkBtn = sender as! UIButton
            checkBtn.enabled = false
            checkBtn.setTitle("60s", forState: .Disabled)
            self.startTimer()
        }
        
        header.checkCodeTextField.rac_textSignal().filter { (text) -> Bool in
            
            return (text as! String).lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 6
            
        }.subscribeNext { (code) -> Void in
            
            xx_print(code)
            
            if self.header.checkBtn.enabled {
                
                AccountViewModel.shared.registModel.authCode = (code as! String)
                AccountViewModel.shared.registModel.phoneNo = self.header.checkCodeTextField.text
                self.header.nextStepBtn.enabled = true
            }
        }
        header.nextStepBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (_) -> Void in
            
            if let vc = self.nextVC {
                
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        }
        tableView.tableHeaderView = header
    }
    
    private lazy var header = AuthCodeView(frame: kConstraints.headerRect)
    /// 停止时钟
    func stopTimer() {
        
        timer?.invalidate()
        timer = nil
    }
    
    /// 开启时钟
    func startTimer() {
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "backward", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
    }

    static var count = 60
    @objc private func backward() {
        
        let count = AuthCodeViewController.count--
        self.header.checkBtn.setTitle("\(count)s", forState: .Disabled)
        
        if 0 == count {
            
            self.header.checkBtn.enabled = true
            self.header.checkBtn.setTitle("获取验证码", forState: .Normal)
            stopTimer()
        }
    }
}
