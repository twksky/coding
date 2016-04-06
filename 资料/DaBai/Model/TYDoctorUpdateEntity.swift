//
//  TYDoctorUpdateEntity.swift
//  DaBai
//
//  Created by BaiTianWei on 15/5/25.
//  Copyright (c) 2015年 BaiTianWei. All rights reserved.
//

import UIKit

class TYDoctorUpdateEntity: TYBaseEntity {
    /**
    *  用户ID
    */
    var userId:Int!
    /**
    *  用户名
    */
    var userName:String!
    /**
    *  出生日期
    */
    var birthDate:String!
    /**
    *  性别
    */
    var sexId:String!
    /**
    *   省
    */
    var province:String!
    /**
    *   市
    */
    var city:String!
    /**
    *   区
    */
    var town:String!
    /**
    *  单位
    */
    var workOrg:String!
    /**
    *  大科室
    */
    var workBigDep:String = ""
    /**
    *  科室
    */
    var workDep:String!
    /**
    *  职称
    */
    var workTitle:String!
    /**
    *  行医资格证号
    */
    var certTip:String!
    /**
    *  行医资格证图片
    */
    var certImg:String!
    
    func fromDoctorInformationEntity(doctor:TYDoctorInformationEntity){
        self.userId = doctor.userId
        self.userName = doctor.userName
        self.birthDate = doctor.birthDate
        self.sexId = doctor.sexId
        self.province = doctor.province
        self.city = doctor.city
        self.town = doctor.town
        self.workOrg = doctor.workOrg
        self.workBigDep = doctor.workBigDep
        self.workDep = doctor.workDep
        self.workTitle = doctor.workTitle
        self.certTip = doctor.certTip
        self.certImg = doctor.certImg
    }
}
