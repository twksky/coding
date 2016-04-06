//
//  TYSysConfigEntity.swift
//  DaBai
//
//  Created by BaiTianWei on 15/5/26.
//  Copyright (c) 2015年 BaiTianWei. All rights reserved.
//

import UIKit
class TYSysConfigEntity: TYBaseEntity {
    var oosBucket:String!
    var oosAccessKeyID:String!
    var oosAccessKeySercet:String!
    /**
    *云存储图片路径
    */
    var oosImagePath:String!
    /**
    *云存储声音路径
    */
    var oosSoundPath:String!
    /**
    *云存储视频路径
    */
    var oosVideoPath:String!
    /**
    *字典版本号
    */
    var dicVersion:String!
    var ccpVoipaccount:String!
    var ccpSubToken:String!
    var ccpvoipPwd:String!
    var ccpSubAccountSid:String!
    /**
    *图文咨询价格
    */
    var imgOrderPrice:Int = 400
    /**
    *电话咨询价格
    */
    var telOrderPrice:Int = 400
    /**
    *视频咨询价格
    */
    var videoOrderPrice:Int = 400
    /**
    *患者随访价格
    */
    var followUpPrice:Int = 400
    /**
    *服务费
    */
    var servicePrice:Int = 0
    /**
    *服务器版本号
    */
    var serverVersion:String!
    /**
    *云存储Referer值
    */
    var ossReferer:String!
    /**
    *云存储域名
    */
    var ossDomainName:String!
    /**
    *产品服务协议
    */
    var serviceAgreement:String!
    /**
    *oss缩略域名
    */
    var thumbnailDomain:String!
    
}
