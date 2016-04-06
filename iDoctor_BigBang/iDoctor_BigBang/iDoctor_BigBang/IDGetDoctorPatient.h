//
//  IDGetDoctorPatient.h
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/9/25.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDGetDoctorPatient : NSObject

// 患者ID
@property (nonatomic, strong) NSString *patient_id;

// 患者名字
@property (nonatomic, strong) NSString *loginname;

// 患者头像
@property (nonatomic, strong) NSString *avatar_url;

// 年龄
@property (nonatomic, assign) NSInteger age;

// 性别
@property (nonatomic, strong) NSString *sex;

// 患者被填过的病例名称
@property (nonatomic, strong) NSString *medical_name;

// 昵称
@property (nonatomic, strong) NSString *nickname;

// 真实姓名
@property (nonatomic, strong) NSString *realname;

//聊天需要用的一个显示的通知的名字（twk加）
@property (nonatomic, strong) NSString  *noteName;

//聊天需要用的方法
- (NSString *)getDisplayName;

- (NSString *)getNoteName;

@end
