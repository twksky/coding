//
//  BaseWebViewController.swift
//  cxd4iphone
//
//  Created by hexy on 15/11/19.
//  Copyright © 2015年 hexy. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

   convenience init(URLStr: String) {
      
        self.init()
    
        if let url = NSURL(string: URLStr) {
            
            request = NSURLRequest(URL: url)
        }
    }
    
    convenience init(htmlStr: String) {
        
        self.init()
        
        self.htmlStr = htmlStr
            
    }
    
    lazy var htmlStr = String?()
//    lazy var htmlData = NSData?()
    lazy var request = NSURLRequest?()
    
    lazy var webView: UIWebView = {
        
        let web = UIWebView(bgColor: UIColor.whiteColor())
        web.delegate = self
        return web
    }()
    
    override func loadView() {
        super.loadView()
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        guard let html = htmlStr else {
            
            guard let req = request else { return }
            
            webView.loadRequest(req)
            
            return
        }
        
        webView.loadHTMLString(html, baseURL: nil)
        
    }

    
}

extension WebViewController: UIWebViewDelegate {
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        xx_print(request)
        return true
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        
        xx_showHUD("加载中...")
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        xx_hideHUD()
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        
        
    }
}