//
//  IDPatientMedical.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/9/28.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDPatientMedical.h"

#import <MJExtension.h>

@implementation IDPatientMedical

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"patientCase_id":@"id"};

}

@end
