//
//  IDGetPatientCaseModel.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/9/24.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDGetPatientCaseModel.h"

#import <MJExtension.h>

@implementation IDGetPatientCaseModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"patientCase_id":@"id"};

}

@end
