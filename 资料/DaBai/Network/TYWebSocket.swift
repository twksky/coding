//
//  File.swift
//  DaBai
//
//  Created by BaiTianWei on 15/6/23.
//  Copyright (c) 2015年 BaiTianWei. All rights reserved.
//

import Foundation
class TYWebSocket:NSObject,SRWebSocketDelegate {
    struct Inner {
        static let instance:TYWebSocket = TYWebSocket()
    }
    class var shared:TYWebSocket {
        return Inner.instance
    }
    //    MARK: - WebSocket
    var webSocket:SRWebSocket!
    func openWebSocket(){
        let cookieJar = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in cookieJar.cookies as! [NSHTTPCookie] {
            let value:String? = cookie.valueForKey("value") as? String
            if value != nil {
                let url:NSURL = NSURL(string: WebSocketUrl + value!)!
                webSocket = SRWebSocket(URLRequest: NSURLRequest(URL: url))
                webSocket.delegate = self
            }
        }
        
        
        if webSocket != nil {
            webSocket.open()
        }
    }
    func closeWebSocket(){
        if webSocket != nil {
            webSocket.close()
        }
    }
    
    func webSocket(webSocket: SRWebSocket!, didCloseWithCode code: Int, reason: String!, wasClean: Bool) {
        print("webSocket close")
    }
    func webSocket(webSocket: SRWebSocket!, didFailWithError error: NSError!) {
        print("webSocket error")
    }
    func webSocket(webSocket: SRWebSocket!, didReceiveMessage message: AnyObject!) {
        NSNotificationCenter.defaultCenter().postNotificationName("ReceiveWebSocketMessage", object: message)
    }
    func webSocketDidOpen(webSocket: SRWebSocket!) {
        print("webSocket open")
    }
    
}