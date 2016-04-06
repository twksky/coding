//
//  IDGetPatientCaseProcesses.h
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/9/24.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDGetPatientCaseProcesses : NSObject

// 过程id
@property (nonatomic, strong) NSString *processes_id;

// 过程名称
@property (nonatomic, strong) NSString *name;

// 过程图片地址
@property (nonatomic, strong) NSString *icon_url;

// 是否已填
@property (nonatomic, assign) BOOL fill;

// 基本的url
@property (nonatomic, strong) NSString *base_url;


@end
