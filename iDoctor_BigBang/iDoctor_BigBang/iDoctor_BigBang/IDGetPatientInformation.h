//
//  IDGetPatientInformation.h
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/9/24.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

// 获得患者的基本信息


#import <Foundation/Foundation.h>

@interface IDGetPatientInformation : NSObject

// 登录名
@property (nonatomic, strong) NSString *loginname;

// 真实姓名
@property (nonatomic, strong) NSString *realname;

// 体重
@property (nonatomic, assign) NSInteger weight;

// 地区
@property (nonatomic, strong) NSString *full_region_path;

// 身高
@property (nonatomic, assign) NSInteger height;

// 生日
@property (nonatomic, strong) NSString *birth;

// 性别
@property (nonatomic, strong) NSString *sex;

// 昵称
@property (nonatomic, strong) NSString *nickname;

// 患者id
@property (nonatomic, strong) NSString *patient_id;

// 地区
@property (nonatomic, strong) NSString *region;

// 会员头像
@property (nonatomic, strong) NSString *avatar_url;

// 年龄
@property (nonatomic, assign) NSInteger age;


@end
