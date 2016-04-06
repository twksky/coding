//
//  IDpatientCaseTagModel.h
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/9/24.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDpatientCaseTagModel : NSObject

// 症状
@property (nonatomic, strong) NSString *symptom;

// 伴随症状
@property (nonatomic, strong) NSString *follow_symptom;

// 发病时间
@property (nonatomic, strong) NSString *disease_time;

// 分期
@property (nonatomic, strong) NSString *stage;

// 病理分型
@property (nonatomic, strong) NSString *pathology;

// 检查项目
@property (nonatomic, strong) NSString *check_item;

// 相关病史
@property (nonatomic, strong) NSString *medical_history;

// 手术
@property (nonatomic, strong) NSString *operation;

// 治疗
@property (nonatomic, strong) NSString *treatment;

// 合并症
@property (nonatomic, strong) NSString *complication;


@end
