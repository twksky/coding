//
//  APIManager.swift
//  cxd4iphone
//
//  Created by hexy on 11/22/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit
import Alamofire
import AFNetworking
import ReactiveCocoa

enum RequestMethod: String {
    
    case GET    = "GET"
    case POST   = "POST"
    case PUT    = "PUT"
    case DELETE = "DELETE"
}

class APIManager: AFHTTPSessionManager {
    
    static let kBaseURL: String = "http://101.201.145.110:8090/"
    // 不需要传额外的header参数
    private static let sharedManager: APIManager = {
        
        var instance = APIManager(baseURL: NSURL(string: kBaseURL))
        instance.responseSerializer.acceptableContentTypes?.insert("text/plain")
        instance.responseSerializer.acceptableContentTypes?.insert("text/html")
        return instance
    }()
    
    // 需要传额外的header参数
    private static var instance: APIManager?
    private static var onceToken: dispatch_once_t = 0
    
    class func sharedInstance() -> APIManager {
        
        dispatch_once(&onceToken) { () -> Void in
            let config = NSURLSessionConfiguration.defaultSessionConfiguration()
            
            config.HTTPAdditionalHeaders = ["sourceCode":"","sourceType":"2", "useVersion":xx_version()]
            
            
            instance = APIManager(baseURL: NSURL(string: kBaseURL), sessionConfiguration: config)
            
            instance!.reachabilityManager.startMonitoring()
            instance!.responseSerializer.acceptableContentTypes?.insert("text/plain")
            instance!.responseSerializer.acceptableContentTypes?.insert("text/html")
            
            // 打开这一行可以去到值为null的的字段
//            (instance!.responseSerializer as! AFJSONResponseSerializer).removesKeysWithNullValues = true
        }
        instance!.requestSerializer.setValue(AccountViewModel.shared.token, forHTTPHeaderField: "TOKEN")
        return instance!
    }
    
    
    // MARK: - 图片轮播
    ///  加载首页图片轮播图
    ///
    ///  - returns: RACSignal
    class func loadBanner() -> RACSignal {
        
        let URLString = "otherc/loadBanners"
        return request(.GET, URLString: URLString, parameters: nil)
    }
    
    // MARK: - 新手标
    ///  加载首页新手标
    ///
    ///  - parameter userId: 用户的id
    ///
    ///  - returns: RACSignal
    class func loadNewerBid(userId: String?) -> RACSignal {
        
        let URLString = "loanc/loadNewerLoan"
        
        var params = [String: AnyObject]()
        params["userID"] = userId
       
        return request(.GET, URLString: URLString, parameters: params)
    }
    
    // MARK: - 投资项目列表
    ///  加载投资项目的列表
    ///
    ///  - parameter page: 页数
    ///  - parameter size: 每页大小
    ///
    ///  - returns: RACSignal
    class func loadBidList(bidSelectModel: BidSelectModel) -> RACSignal {
        
        let URLString = "loanc/loans"
        
      
        
        return request(.GET, URLString: URLString, parameters: bidSelectModel.keyValues())
    }
    
    // MARK: - 项目详情
    
    class func loadBidDetail(bidId: String) -> RACSignal {
        
        let URLString = "loanc/loan"
        
        var params = [String: AnyObject]()
        
        params["loanId"] = bidId
        
        return request(.GET, URLString: URLString, parameters: params)
    }
    
    // MARK: - 用户总投资
    class func loadTotalInvestStatic() -> RACSignal {
        
        let URLString = "otherc/moneyStatic"
        
        return request(.GET, URLString: URLString, parameters: nil)
    }
    
    // MARK: - 注册
    class func register(registModel: RegistModel) -> RACSignal {
        
        let URLString = "userc/register"
        

        
        return request(.GET, URLString: URLString, parameters: registModel.keyValues())
    }
    
    // MARK: - 获取手机验证码
    class func verifiCode(phoneNo: String) -> RACSignal {
        
        let URLString = "userc/registerSendVerificationCode"
        
        var params = [String: AnyObject]()
        
        params["phoneNo"] = phoneNo
        
        return request(.GET, URLString: URLString, parameters: params)
    }
    
    // MARK: - 检测手机号(数据结构不正确)
    class func checkIsUsedPhone(phoneNo: String) -> RACSignal {
        
        let URLString = "userc/isUsePhone"
        
        var params = [String: AnyObject]()
        
        params["phoneNo"] = phoneNo
        
        return request(.GET, URLString: URLString, parameters: params)
    }
    var realName: String?
    var idCard: String?
    var phoneNo: String?
    
    // MARK: - 实名认证
    class func authentication(realName: String, idCard: String, phoneNo: String) -> RACSignal {
        
        let URLString = "userc/realnameAuthentication"
        
        var params = [String: AnyObject]()
        params["realName"] = realName
        params["idCard"] = idCard
        params["phoneNo"] = phoneNo
        
        return request(.GET, URLString: URLString, parameters: params)
    }

    // MARK: - 投标
    class func invest(loanId: String, investMoney: String) -> RACSignal {
        
        let URLString = "loanc/invest"
        
        var params = [String: AnyObject]()
        params["loanId"] = loanId
        params["investMoney"] = investMoney
        
        return request(.GET, URLString: URLString, parameters: params)
    }
    
    // MARK: - 充值
    class func recharge(money: String) -> RACSignal {
        
        let URLString = "myaccountc/recharge"
        
        var params = [String: AnyObject]()
        params["money"] = money

        return request(.GET, URLString: URLString, parameters: params)
    }
    
    // MARK: - 提现
    class func withdraw(money: String) -> RACSignal {
        
        let URLString = "myaccountc/withdraw"
        
        var params = [String: AnyObject]()
        params["money"] = money
        
        return request(.GET, URLString: URLString, parameters: params)
    }

    // MARK: - 绑卡
    class func bindBankCard() -> RACSignal {
        
        let URLString = "myaccountc/bindBankCard"
        
        var params = [String: AnyObject]()
        
        params["userId"] = AccountViewModel.shared.userId
        return request(.GET, URLString: URLString, parameters: params)
    }


    
    // MARK: - 登录
    ///  用户登录
    ///
    ///  - parameter username: 用户名
    ///  - parameter passwd:   密码
    ///
    ///  - returns: RACSignal
    class func login(username: String, passwd: String) -> RACSignal {
        
        let URLString = "userc/login"
        
        var params = [String: AnyObject]()
        
        params["loginName"] = username
        params["password"] = passwd
        
        return request(.GET, URLString: URLString, parameters: params)
    }
    
    // MARK: - 用户收益信息
    
    class func loadUserIncome() -> RACSignal {
        
        let URLString = "myaccountc/accountBalance"
        
        var params = [String: AnyObject]()
        
        params["userId"] = AccountViewModel.shared.userId
        
        return request(.GET, URLString: URLString, parameters: params)
    }
    
    // MARK: - 用户投资记录
    ///  获取用户的投资记录
    ///
    ///  - parameter userId: 用户id
    ///  - parameter page:   页
    ///  - parameter size:   页大小
    ///
    ///  - returns: RACSignal
    class func loadUserInvestRecord(page: Int) -> RACSignal {
        
        let URLString = "loanc/userInvests"
        
        var params = [String: AnyObject]()
        
        params["userId"] = AccountViewModel.shared.userId
        params["currentPage"] = page
        params["pageSize"] = Define.pageSize
        
        return request(.GET, URLString: URLString, parameters: params)

    }
    
    // MARK: - 还款计划
    class func loadRepayPlanList(loanId: String) -> RACSignal {
        
        let URLString = "loanc/repayPlan"
        
        var params = [String: AnyObject]()
        
        params["userId"] = AccountViewModel.shared.userId
        params["loanId"] = loanId
        
        return request(.GET, URLString: URLString, parameters: params)
        
    }

    
    // MARK: - 用户账单列表
    class func loadUserBillList(page: Int) -> RACSignal {
        
        let URLString = "myaccountc/transactionRecords"
        
        var params = [String: AnyObject]()
        
        params["userId"] = AccountViewModel.shared.userId
        params["currentPage"] = page
        params["pageSize"] = Define.pageSize
        
        return request(.GET, URLString: URLString, parameters: params)
        
    }
    
    // MARK: - 意见反馈
    class func feedback(content: String) -> RACSignal {
    
        let URLString = "otherc/feedback"
        
        var params = [String: AnyObject]()
        
        params["userId"] = AccountViewModel.shared.userId
        params["content"] = content
        
        return request(.GET, URLString: URLString, parameters: params)
    }
    
    // MARK: - 检测新版本
    class func checkNewVersion() -> RACSignal {
        
        let URLString = "otherc/version"
        
        var params = [String: AnyObject]()
        
        params["packageName"] = xx_packageName()
        params["version"] = xx_version()
        
        return request(.GET, URLString: URLString, parameters: params)
    }
    
    // MARK: - 最新公告列表
    class func loadDeclareList(page: Int) -> RACSignal {
        
        let URLString = "otherc/loadNews"
        
        var params = [String: AnyObject]()
        
        params["currentPage"] = page
        params["pageSize"] = Define.pageSize
        
        return request(.GET, URLString: URLString, parameters: params)
    }
    
    // MARK: - 网络访问方法
    ///  通用HTTP请求
    ///
    ///  - parameter method:     请求方法
    ///  - parameter URLString:  网络地址
    ///  - parameter parameters: 参数字典
    ///
    ///  - returns: RACSignal
    class func request(method: RequestMethod,URLString: String, parameters: [String : AnyObject]?) -> RACSignal {
        
        return RACSignal.createSignal({ (subscriber) -> RACDisposable! in
            
            let successBlock = { (task: NSURLSessionDataTask, responseObject: AnyObject) -> Void in
                
                let URLString = task.originalRequest!.URL!.absoluteString
//                let statusCode = (task.response as! NSHTTPURLResponse).statusCode
                
//                xx_print(responseObject)
                let dict = (responseObject as! NSDictionary)
                
                let code = dict["status"] as! Int
                let msg = dict["msg"] as! String
                if code != 200 {
                    
                    subscriber.sendError(NSError(domain: URLString, code: code, userInfo: ["msg": msg]))
                    return
                }
                
                subscriber.sendNext(dict["result"])
                subscriber.sendCompleted()
            }
            
            let failureBlock = { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                
                xx_print(error)
                if let task = task {
                    
                    let URLString = task.originalRequest!.URL!.absoluteString
                    xx_print(URLString)
                }
                subscriber.sendError(error)
            }
            
            let param = ["value":xx_dict2JSONString(dict: parameters, jsonWritingOptions: [])]
            
            switch method {
                
                case RequestMethod.GET:
                    
                    APIManager.sharedInstance().GET(URLString, parameters: param, success: successBlock, failure: failureBlock)
                    
                case RequestMethod.POST:
                    
                    APIManager.sharedInstance().POST(URLString, parameters: param, success: successBlock, failure: failureBlock)
                    
                case RequestMethod.PUT:
                    
                    APIManager.sharedInstance().PUT(URLString, parameters: param, success: successBlock, failure: failureBlock)
                    
                case RequestMethod.DELETE:
                    
                    APIManager.sharedInstance().DELETE(URLString, parameters: param, success: successBlock, failure: failureBlock)
            }
            
            return RACDisposable(block: {})
        })
    }
    
}

