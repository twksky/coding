//
//  IDPatientMedical.h
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/9/28.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDPatientMedical : NSObject

// 是否展示
@property (nonatomic, assign) BOOL show;

// patientCase_id
@property (nonatomic, strong) NSString *patientCase_id;

// 等级
@property (nonatomic, assign) NSInteger rank;

// 病例名字
@property (nonatomic, strong) NSString *name;


@end
