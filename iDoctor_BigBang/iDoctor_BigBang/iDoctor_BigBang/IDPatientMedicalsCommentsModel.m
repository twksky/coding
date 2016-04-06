//
//  IDPatientMedicalsCommentsModel.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/10/20.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDPatientMedicalsCommentsModel.h"
#import <MJExtension.h>

@implementation IDPatientMedicalsCommentsModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"patient_medical_id":@"id", @"comment_descreption":@"description"};
}

@end
