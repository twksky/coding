//
//  IDGetPatientCaseTemplate.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/9/25.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDGetPatientCaseTemplate.h"

#import <MJExtension.h>

@implementation IDGetPatientCaseTemplate

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"template_id":@"id"};
}

@end
