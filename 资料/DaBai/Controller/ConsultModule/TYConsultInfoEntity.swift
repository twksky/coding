//
//  TYConsultInfoEntity.swift
//  DaBai
//
//  Created by BaiTianWei on 15/6/11.
//  Copyright (c) 2015年 BaiTianWei. All rights reserved.
//

import UIKit

class TYConsultInfoEntity: TYBaseEntity {
    /**
    *  咨询ID
    */
    var consultId:Int = 0
    /**
    *  病历ID
    */
    var caseId:Int = 0
    /**
    *  咨询医生ID
    */
    var fromDcId:Int = 0
    /**
    *  咨询医生姓名
    */
    var fromDcName:String!
    /**
    *  被咨询医生ID
    */
    var toDcId:Int = 0
    /**
    *  被咨询医生姓名
    */
    var toDcName:String!
    /**
    *  科室
    */
    var consultDep:String!
    /**
    * 咨询状态
    * 1:未咨询
    * 2:发起/待确认
    * 3:接受/待支付
    * 5:进行中/支付完成
    * 6:拒绝
    * 7:结束
    * 8:取消
    */
    var consultState:String!
    /**
    *  患者姓名
    */
    var patientName:String!
    /**
    *  患者ID
    */
    var patientId:Int = 0
    /**
    *  患者手机号
    */
    var patientTel:String!
    /**
    *  患者性别
    */
    var patientSexId:String!
    /**
    *  患者出生日期
    */
    var patientBirthDate:String!
    /**
    *  拒绝原因类型
    */
    var denialType:String!
    /**
    *  拒绝其它_文字
    */
    var denialText:String!
    /**
    *  拒绝其它_语音
    */
    var denialSound:String!
    /**
    *  咨询类型1:图文,2:语音,3:视频,4:随访
    */
    var consultType:String!
    /**
    *  咨询价格
    */
    var consultPrice:Int = 0
    /**
    *  创建时间
    */
    var ctime:String!
    /**
    *  订单编号
    */
    var orderNumber:String!
}
