//
//  AppUtils.swift
//  DaBai
//
//  Created by BaiTianWei on 15/6/3.
//  Copyright (c) 2015年 BaiTianWei. All rights reserved.
//

import UIKit

class TYAppUtils: NSObject {
    
    /**
    计算年龄
    
    :param: date 需要计算的日期
    
    :returns: 返回年龄
    */
    class func ageWithDateOfBirth(date: NSDate) -> NSInteger {
        // 出生日期转换 年月日
        let components1 = NSCalendar.currentCalendar().components(.DayCalendarUnit | .MonthCalendarUnit | .YearCalendarUnit, fromDate: date);
        let brithDateYear  = components1.year;
        let brithDateDay   = components1.day;
        let brithDateMonth = components1.month;
        
        // 获取系统当前 年月日
        let components2 = NSCalendar.currentCalendar().components(.DayCalendarUnit | .MonthCalendarUnit | .YearCalendarUnit, fromDate: NSDate())
        let currentDateYear  = components2.year;
        let currentDateDay   = components2.day;
        let currentDateMonth = components2.month;
        
        // 计算年龄
        var iAge = currentDateYear - brithDateYear - 1;
        if ((currentDateMonth > brithDateMonth) || (currentDateMonth == brithDateMonth && currentDateDay >= brithDateDay)) {
            iAge++;
        }
        return iAge;
    }
    /**
    计算年龄
    
    :param: dateStr 需要计算的日期 yyyy-MM-dd
    
    :returns: 返回年龄
    */
    class func ageWithDateOfBirthString(dateStr:String) -> NSInteger {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.dateFromString(dateStr)
        return TYAppUtils.ageWithDateOfBirth(date!)
    }
    class func checkPhoneNumber(phoneBumber:String)-> Bool {
        
        var MOBILECHECK:Bool = false
        
        if !MOBILECHECK {
            return true
        }
        
        
        let MOBILE = "^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$"
        let CM = "^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$"
        let CU = "^1(3[0-2]|5[256]|8[56])\\d{8}$"
        let CT = "^1((33|53|8[09])[0-9]|349)\\d{7}$"
        
        let predicatemobile = NSPredicate(format: "SELF MATCHES %@", MOBILE)
        let predicatecm = NSPredicate(format: "SELF MATCHES %@", CM)
        let predicatecu = NSPredicate(format: "SELF MATCHES %@", CU)
        let predicatect = NSPredicate(format: "SELF MATCHES %@", CT)
        
        let res1 = predicatemobile.evaluateWithObject(phoneBumber)
        let res2 = predicatecm.evaluateWithObject(phoneBumber)
        let res3 = predicatecu.evaluateWithObject(phoneBumber)
        let res4 = predicatect.evaluateWithObject(phoneBumber)

        if (res1 || res2 || res3 || res4) {
            return true
        }else {
            return false
        }
    }
    class func chechPassword(password:String)->Bool {
        return true
        let PASSWORD = "[\\w\\W]{6,18}"
        
        let predicatepw = NSPredicate(format: "SELF MATCHES %@", PASSWORD)
        return predicatepw.evaluateWithObject(password)
    }
    
    /**
    html颜色值转换为UIcolor
    
    :param: value html颜色值
    
    :returns: UIColor
    */
    class func HexRGB(value:Int) -> UIColor {
        let red = CGFloat((value&0xff0000)>>16)/255
        let green = CGFloat((value&0xff00)>>8)/255
        let blue = CGFloat(value&0xff)/255
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
    
    /**
    html颜色值转换为UIcolor
    
    :param: HexString 16进制颜色字符串
    :param: alpha 透明度
    
    :returns: UIColor
    */
    class func HexToColor(var HexString:String,alpha:CGFloat) -> UIColor {
        HexString = HexString.componentsSeparatedByString("#").last!
        HexString = HexString.componentsSeparatedByString("0x").last!
        var HexNum = UInt32()
        NSScanner(string: HexString).scanHexInt(&HexNum)
        let red = CGFloat((HexNum&0xff0000)>>16)/255
        let green = CGFloat((HexNum&0xff00)>>8)/255
        let blue = CGFloat(HexNum&0xff)/255
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
}
