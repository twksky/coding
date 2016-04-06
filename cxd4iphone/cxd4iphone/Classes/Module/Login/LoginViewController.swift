//
//  LoginViewController.swift
//  cxd4iphone
//
//  Created by hexy on 12/8/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit
import ReactiveCocoa

private struct kConstraints {
    
    static let headerHeight: CGFloat = xx_height(260)
    static let headerRect: CGRect    = CGRectMake(0, 0, xx_screenWidth(), kConstraints.headerHeight)
}

class LoginViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let leftItem = UIBarButtonItem(title: "取消", style: .Plain, target: self, action: "hide")
        navigationItem.leftBarButtonItem = leftItem
        
        let rightItem = UIBarButtonItem(title: "注册", style: .Plain, target: self, action: "register")
        navigationItem.rightBarButtonItem = rightItem

        let header = LoginView(frame: kConstraints.headerRect)
        


        
        
        header.loginBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (_) -> Void in
            
            let loginName = header.loginNameTextField.text!
            let passwd = header.loginPasswdTextField.text!
            
            AccountViewModel.shared.login(loginName, passwd: passwd).subscribeError({ (error) -> Void in
                
                    xx_showError(error)
                
                }, completed: { () -> Void in
                    
                    xx_print("完成.....")
                    xx_print(AccountViewModel.shared.userId)
                    xx_print(AccountViewModel.shared.userLogin)
            })
            
        }
        
        header.forgotPasswdBtn.rac_signalForControlEvents(.TouchUpInside).subscribeNext { (_) -> Void in
            
            let vc = AuthCodeViewController(nextVC: NewPasswdController(aTitle: "重置密码"))
            self.navigationController?.pushViewController(vc, animated: true)
        }
        tableView.tableHeaderView = header

    }
    
    func isValidLoginName (loginName: String) -> Bool {
        
        return true
    }
    
    @objc private func hide() {
        
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    @objc private func register() {
        
        let vc = AuthCodeViewController(nextVC: RegistViewController(aTitle: "注册"))
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

//        header.loginNameTextField.rac_textSignal().filter { (loginName) -> Bool in
//
//            return (loginName as! String).lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 6
//
//        }.subscribeNext { (loginName) -> Void in
//
//             xx_print(loginName)
//        }
//        header.loginPasswdTextField.rac_textSignal().filter { (loginPasswd) -> Bool in
//
//            return (loginPasswd as! String).lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 6
//
//            }.subscribeNext { (loginPasswd) -> Void in
//
//                xx_print(loginPasswd)
//        }

//        let vaildUsernameSignal:RACSignal = userName.rac_textSignal() .map { (usernameText) -> AnyObject! in
//
//            return self.isValidUsername(usernameText as! String)
//
//        }
//
//
//        let validloginNameSignal: RACSignal = header.loginNameTextField.rac_textSignal().map { (loginName) -> AnyObject! in
//
//            return self.isValidLoginName(loginName as! String)
//        }
//        NSNotificationCenter.defaultCenter().rac_addObserverForName(UITextFieldTextDidEndEditingNotification, object: nil).takeUntil(self.rac_willDeallocSignal()).subscribeNext {
//
//            xx_print(($0.object as! UITextField).text!)
////            ($0.object as! UITextField).layer.borderColor = UIColor.orangeColor().CGColor
//        }
//        let xvalidloginNameSignal: RACSignal = header.loginNameTextField.rac_textSignal().filter { (loginName) -> Bool in
//
//            return (loginName as! String).lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 6
//
//        }.map { (loginName) -> AnyObject! in
//
//            return self.isValidLoginName(loginName as! String)
//        }

//        let xvalidloginNameSignal: RACSignal = header.loginNameTextField.rac_textSignal().filter { (text) -> Bool in
//
//            return (text as! String).lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0
//        }

//        let xvalidloginPasswdSignal: RACSignal = header.loginPasswdTextField.rac_textSignal().filter { (loginPasswd) -> Bool in
//
//            return (loginPasswd as! String).lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 6
//        }.map { (loginPasswd) -> AnyObject! in
//
//            return self.isValidLoginName(loginPasswd as! String)
//        }

//        let xvalidloginPasswdSignal: RACSignal = header.loginPasswdTextField.rac_textSignal().filter { (text) -> Bool in
//
//             return (text as! String).lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0
//        }

//        let xloginBtnEnabelSignal: RACSignal = RACSignal.combineLatest([xvalidloginNameSignal: NSNumber(), xvalidloginPasswdSignal: NSNumber()]) { () -> AnyObject! in
//
//            return true
//        }
//        let xloginBtnEnabelSignal: RACSignal = RACSignal.combineLatest([header.loginPasswdTextField.rac_textSignal(), header.loginNameTextField.rac_textSignal()]).map { (tuple) -> AnyObject! in
//
//            let a = tuple as! RACTuple
////            xx_print(a.allObjects())
//            xx_print((a.first as! NSString).length)
//            xx_print((a.second as! NSString).length)
////            return (a.first as! Bool) && (a.second as! Bool)
//            return Bool((a.first as! NSString).length > 0) && Bool((a.second as! NSString).length)
//        }
//
//

//        RACSignal.combineLatest([header.loginPasswdTextField.rac_textSignal(), header.loginNameTextField.rac_textSignal()]).map { (tuple) -> AnyObject! in
//
//            let a = tuple as! RACTuple
//            //            xx_print(a.allObjects())
//            xx_print((a.first as! NSString).length)
//            xx_print((a.second as! NSString).length)
//            //            return (a.first as! Bool) && (a.second as! Bool)
//            return Bool((a.first as! NSString).length > 0) && Bool((a.second as! NSString).length)
//            }
//.subscribeNext { (hhh) -> Void in
//
//            header.loginBtn.enabled = (hhh as! Bool)
//        }
//        xloginBtnEnabelSignal.subscribeNext { (hhh) -> Void in
//
//            header.loginBtn.enabled = (hhh as! Bool)
//        }

//
//                    xvalidloginNameSignal.subscribeNext { (boolValue) -> Void in
//
//            if (boolValue as! Bool) {
//
//                xx_print("hahahahhah")
//                header.loginNameTextField.layer.borderColor = UIColor.orangeColor().CGColor
//            }
//        }
