//
//  TYPatientListTableViewCellEntity.swift
//  DaBai
//
//  Created by BaiTianWei on 15/6/4.
//  Copyright (c) 2015年 BaiTianWei. All rights reserved.
//

import UIKit

class TYPatientListTableViewCellEntity: TYBaseEntity {
    /**
    *  患者ID
    */
    var patientId:Int = 0
    /**
    *  患者名字
    */
    var patientName:String!
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
}
