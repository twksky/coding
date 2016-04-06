//
//  Define.swift
//  cxd4iphone
//
//  Created by hexy on 11/22/15.
//  Copyright © 2015 hexy. All rights reserved.
//

import UIKit
import SVProgressHUD

public struct Define {
    
    static let textFieldColor: CGColorRef = xx_colorWithHex(hexValue: 0xbcbcbc).CGColor
    static let redColor: UIColor          = xx_colorWithHex(hexValue: 0xf64242)
    static let blueColor: UIColor         = xx_colorWithHex(hexValue: 0x3d64b4)
    static let lightFontColor: UIColor    = xx_colorWithHex(hexValue: 0x666666)
    static let moreLightFontColor: UIColor    = xx_colorWithHex(hexValue: 0x666666)
    static let darkFontColor: UIColor     = xx_colorWithHex(hexValue: 0x333333)
    static let grayColor: UIColor     = xx_colorWithHex(hexValue: 0xc7c7c7)
    static let backgroundColor: UIColor   = xx_colorWithHex(hexValue: 0xf8f8f8)
    static let separatorColor: UIColor    = xx_colorWithHex(hexValue: 0xededed)
    
    static let pageSize: Int = 10
}

///  自定义打印
func xx_print<T>(msg:T, printError: Bool = false, file: String = __FILE__, method: String = __FUNCTION__, line: Int = __LINE__) {
    
    if printError {
        
        print("\((file as NSString).lastPathComponent)[\(line)] -> \(method):\n\(msg)\n")
        
    } else {
        
        #if DEBUG
            print("\((file as NSString).lastPathComponent)[\(line)] -> \(method):\n\(msg)\n")
        #endif
    }
}

///  生成随机色
func xx_randomColor() -> UIColor {
    
    return UIColor(red: CGFloat(arc4random() % 256) / 255.0,
        green: CGFloat(arc4random() % 256) / 255.0,
        blue: CGFloat(arc4random() % 256) / 255,
        alpha: 1.0)
}

///  通过16进制数获取颜色
func xx_colorWithHex(hexValue hexValue: UInt32) -> UIColor {
    
    let red     = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
    let green   = CGFloat((hexValue & 0x00FF00) >>  8) / 255.0
    let blue    = CGFloat( hexValue & 0x0000FF       ) / 255.0
    return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    
}

///  通过16进制数获取颜色
func xx_colorWithHex(hexValue hexValue: UInt32, alpha: CGFloat) -> UIColor {
    
    let red     = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
    let green   = CGFloat((hexValue & 0x00FF00) >>  8) / 255.0
    let blue    = CGFloat( hexValue & 0x0000FF       ) / 255.0
    return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    
}

///  包装数字以适应不同机型
func xx_folat(size: CGFloat) -> CGFloat {
    
   return (xx_iPhone6() || xx_iPhone6p()) ? size * xx_rateWidth() : size
}

func xx_height(height: CGFloat) -> CGFloat {
    
    return height * xx_rateHeight()
}

func xx_width(width: CGFloat) -> CGFloat {
    
    return width * xx_rateWidth()
}

func xx_fontOfSize(size size : CGFloat) -> UIFont {
    
    return UIFont(name: "KohinoorDevanagari-Regular", size: xx_folat(size))!
}


extension SVProgressHUD {
    
     public override class func initialize() {
        SVProgressHUD.setDefaultStyle(.Custom)
        SVProgressHUD.setDefaultAnimationType(.Flat)
        SVProgressHUD.setBackgroundColor(UIColor.blackColor())
        SVProgressHUD.setForegroundColor(UIColor.whiteColor())
    }
    
    func updateBlurBounds() {}
}

func xx_showError(error: NSError) {
    
    if let msg = (error.userInfo as! [String: AnyObject])["msg"] as? String {
        
        SVProgressHUD.showInfoWithStatus(msg)
    }
}

func xx_showHUD(status: String?) {
    
    if let status = status {
        
        SVProgressHUD.showWithStatus(status)
        return
    }
    SVProgressHUD.show()
}

func xx_showInfo(info: String) {
    
     SVProgressHUD.showInfoWithStatus(info)
}

func xx_hideHUD() {
    
    SVProgressHUD.dismiss()
}

func xx_screenWidth() -> CGFloat {
    
    return UIScreen.mainScreen().bounds.width
}

func xx_screenHeight() -> CGFloat {
    
    return UIScreen.mainScreen().bounds.height
}

func xx_rateWidth() -> CGFloat {
    
    return xx_screenWidth() / 320.0
}

func xx_rateHeight() -> CGFloat {
    
    return xx_screenHeight() / 480.0
}

func xx_iPhone4() -> Bool {
    
    return (480.0 == xx_screenHeight())
}


func xx_iPhone5() -> Bool {
    
    return (568.0 == xx_screenHeight())
}

func xx_iPhone6() -> Bool {
    
    return (375.0 == xx_screenWidth())
}

func xx_iPhone6p() -> Bool {
    
    return (414.0 == xx_screenWidth())
}

func xx_version() -> String {
    
    return (NSBundle.mainBundle().infoDictionary! as NSDictionary)["CFBundleShortVersionString"]! as! String
}
func xx_packageName() -> String {
    
    return (NSBundle.mainBundle().infoDictionary! as NSDictionary)["CFBundleIdentifier"]! as! String
}
typealias Task = (cancel : Bool) -> ()

func xx_delay(time:NSTimeInterval, task:()->()) ->  Task? {
    
    func dispatch_later(block:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(time * Double(NSEC_PER_SEC))),
            dispatch_get_main_queue(),
            block)
    }
    
    var closure: dispatch_block_t? = task
    var result: Task?
    
    let delayedClosure: Task = {
        cancel in
        if let internalClosure = closure {
            if (cancel == false) {
                dispatch_async(dispatch_get_main_queue(), internalClosure);
            }
        }
        closure = nil
        result = nil
    }
    
    result = delayedClosure
    
    dispatch_later {
        if let delayedClosure = result {
            delayedClosure(cancel: false)
        }
    }
    
    return result;
}

func xx_cancel(task:Task?) {
    
    task?(cancel: true)
}

func xx_dict2JSONString(dict dict:AnyObject?, jsonWritingOptions opt: NSJSONWritingOptions)-> NSString {
    
    guard let aDict = dict else { return "null" }
    let data = try! NSJSONSerialization.dataWithJSONObject(aDict, options: opt)
    let strJson = NSString(data: data, encoding: NSUTF8StringEncoding)
    
    return strJson!
}

func xx_JsonPrint(dict dict:AnyObject) {
    
    xx_print(xx_dict2JSONString(dict: dict, jsonWritingOptions: [.PrettyPrinted]))
}

func xx_removeAllChildViews(superView: UIView) {
    
    for view in superView.subviews {
        
        view.removeFromSuperview()
    }
}

func xx_length(str: String) -> Int {
    
    let str = str as NSString
    return str.containsString(".") ? (str.substringToIndex(str.rangeOfString(".").location) as NSString).length : str.length
}

func xx_documentDir() -> NSString {
    
    return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last! as NSString
}

func xx_accountFilePath() -> String {
    
    return xx_documentDir().stringByAppendingPathComponent("account.plist")
}

func xx_ypCallBackURLsFilePath() -> String {
    
    return xx_documentDir().stringByAppendingPathComponent("ypCallBackURLs.data")
}

struct RegexHelper {
    
    let regex: NSRegularExpression?
    
    init(_ pattern: String) {
        
        try! regex = NSRegularExpression(pattern: pattern,options: NSRegularExpressionOptions.CaseInsensitive)
        
    }
    
    func match(input: String) -> Bool {
        
        if let matches = regex?.matchesInString(input, options: [],range: NSMakeRange(0, input.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))) {
        
            return matches.count > 0
            
        } else {
            
            return false
        }
    }
}


func xx_xmlStingWithDict(dict:[String: AnyObject]) -> String {
    
    var s = ""
    for (k, v) in dict {
        s.appendContentsOf("<\(k)>\(v)</\(k)>")
    }
    return s
}
func xx_HTML(yeepayURL: String, sign: String, req: String) -> String {
    
    return "<!DOCTYPE html><html><head><title>跳转...</title><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" /></head><body><form action=\"\(yeepayURL)\" id=\"frm1\" style=\"display:none;\"><input type=\"hidden\" name=\"sign\" value=\"\(sign)\" /><input type=\"hidden\" name=\"req\" value=\"\(req)\" /></form><script type=\"text/javascript\">document.getElementById(\"frm1\").submit()</script></body></html>"
}

