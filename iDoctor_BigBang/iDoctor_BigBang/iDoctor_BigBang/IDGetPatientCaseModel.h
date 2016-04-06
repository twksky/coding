//
//  IDGetPatientCaseModel.h
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/9/24.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDGetPatientCaseModel : NSObject

// 病例id
@property (nonatomic, strong) NSString *patientCase_id;

// 创建者的id
@property (nonatomic, strong) NSString *creater_id;

// 患者的id
@property (nonatomic, assign) NSInteger patient_id;

// 病例模板的id
@property (nonatomic, strong) NSString *medical_id;

// 病例模板的名字
@property (nonatomic, strong) NSString *medical_name;

// 地区的id
@property (nonatomic, assign) NSInteger region_id;

// 是否是第一次创建
@property (nonatomic, assign) BOOL first_create;


@end
