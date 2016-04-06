//
//  TYDoctorAccountEntity.swift
//  DaBai
//
//  Created by BaiTianWei on 15/5/26.
//  Copyright (c) 2015年 BaiTianWei. All rights reserved.
//

import UIKit

class TYDoctorAccountEntity: TYBaseEntity {
    /**
    *  用户ID
    */
    var userId:Int!
    /**
    *  用户姓名
    */
    var userName:String!
    /**
    *  手机号
    */
    var userTel:String!
    /**
    *  身份证
    */
    var idCard:String!
    /**
    *  账号
    */
    var account:String!
    /**
    *  账号类型 1:支付宝 2:微信3:银行
    */
    var accountType:String!
    /**
    *  账号名称
    */
    var accountName:String!
}
