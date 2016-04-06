//
//  TYDoctorEntity.swift
//  DaBai
//
//  Created by BaiTianWei on 15/5/25.
//  Copyright (c) 2015年 BaiTianWei. All rights reserved.
//

import UIKit

class TYDoctorInformationEntity: TYBaseEntity {
    /**
    *   用户ID
    */
    var userId:Int = 0
    /**
    *  用户姓名
    */
    var userName:String = ""
    /**
    *  用户电话
    */
    var userTel:String = ""
    /**
    *  邮件
    */
    var Email:String = ""
    /**
    *  性别
    */
    var sexId:String = ""
    /**
    *  身份证
    */
    var idCard:String = ""
    /**
    *   省
    */
    var province:String = ""
    /**
    *   市
    */
    var city:String = ""
    /**
    *   区
    */
    var town:String = ""
    /**
    *  医院
    */
    var workOrg:String = ""
    /**
    *  大科室
    */
    var workBigDep:String = ""
    /**
    *  科室
    */
    var workDep:String = ""
    /**
    *  职称
    */
    var workTitle:String = ""
    /**
    *  行医资格证号
    */
    var certTip:String = ""
    /**
    *  头像_路径
    */
    var headImg:String = ""
    /**
    *   行医资格证图片_路径
    */
    var certImg:String = ""
    /**
    *  行医格言
    */
    var dmotto:String = ""
    /**
    *  专业特长
    */
    var personalSpecialty:String = ""
    /**
    *  个人展现
    */
    var dresume:String = ""
    /**
    *  审核状态
    */
    var checkState:String = ""
    /**
    *  视频咨询状态 1:开 2:关
    */
    var videoOrderState:String = ""
    
    /**
    *  图文咨询状态 1:开 2:关
    */
    var imgOrderState:String = ""
    
    /**
    *  电话咨询状态 1:开 2:关
    */
    var telOrderState:String = ""
    
    
    /**
    *  图文咨询价格
    */
    var imgOrderPrice:Int = 0
    /**
    *  视频咨询价格
    */
    var videoOrderPrice:Int = 0
    /**
    *  电话咨询价格
    */
    var telOrderPrice:Int = 0
    /**
    *  患者随访价格
    */
    var followUpPrice:Int = 0
    /**
    *  出生日期
    */
    var birthDate:String = ""
    /**
    *  医生角色1:专家,2:医生
    */
    var dcRole:String = ""
    /**
    *咨询状态1：在线 2：离线
    */
    var begOrderPrice:String = ""
    /**
    *在线状态1：在线 2：离线
    */
    var onLineState:String = ""
    /**
    *检索医生
    */
    var queryStr:String = ""
}
