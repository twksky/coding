//
//  TYDoctorUpdateExpandEntity.swift
//  DaBai
//
//  Created by BaiTianWei on 15/6/2.
//  Copyright (c) 2015年 BaiTianWei. All rights reserved.
//

import UIKit

class TYDoctorUpdateExpandEntity: TYBaseEntity {
    
    /**
    *   用户ID
    */
    var userId:Int!
    /**
    *  头像_路径
    */
    var headImg:String!
    /**
    *  行医格言
    */
    var dmotto:String!
    /**
    *  个人特长
    */
    var personalSpecialty:String!
    /**
    *  个人展现
    */
    var dresume:String!
    func fromDoctorInformationEntity(doctor:TYDoctorInformationEntity){
        
        self.userId = doctor.userId
        self.dmotto = doctor.dmotto
        self.headImg = doctor.headImg
        self.personalSpecialty = doctor.personalSpecialty
        self.dresume = doctor.dresume
    }
}
