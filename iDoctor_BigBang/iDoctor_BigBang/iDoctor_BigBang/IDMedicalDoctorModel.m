//
//  IDMedicalDoctorModel.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/10/15.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDMedicalDoctorModel.h"

#import <MJExtension.h>

@implementation IDMedicalDoctorModel

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"doctor_id":@"id"};
}

@end
