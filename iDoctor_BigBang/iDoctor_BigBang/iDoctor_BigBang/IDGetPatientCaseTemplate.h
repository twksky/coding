//
//  IDGetPatientCaseTemplate.h
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/9/25.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDGetPatientCaseTemplate : NSObject

// 模板ID
@property (nonatomic, strong) NSString *template_id;

// 病例模板名称
@property (nonatomic, strong) NSString *name;

@end
