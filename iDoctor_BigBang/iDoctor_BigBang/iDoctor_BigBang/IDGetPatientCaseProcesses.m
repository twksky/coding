//
//  IDGetPatientCaseProcesses.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/9/24.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDGetPatientCaseProcesses.h"
#import <MJExtension.h>

@implementation IDGetPatientCaseProcesses

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"processes_id":@"id"};
}

@end
