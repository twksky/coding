//
//  IDGetPatientInformation.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/9/24.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDGetPatientInformation.h"
#import <MJExtension.h>

@implementation IDGetPatientInformation

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"patient_id":@"id"};
}

@end
