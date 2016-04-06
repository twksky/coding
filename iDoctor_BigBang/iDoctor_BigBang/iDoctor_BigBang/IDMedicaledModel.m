//
//  IDMedicaledModel.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/9/30.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDMedicaledModel.h"
#import <MJExtension.h>

@implementation IDMedicaledModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"patient_medical_id":@"id"};
}

+ (NSDictionary *)objectClassInArray
{
    return @{@"receive_doctor_list":[NSNumber class]};
}

@end
