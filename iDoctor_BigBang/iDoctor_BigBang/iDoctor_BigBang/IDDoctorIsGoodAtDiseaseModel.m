//
//  IDDoctorIsGoodAtDiseaseModel.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/10/14.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDDoctorIsGoodAtDiseaseModel.h"

#import <MJExtension.h>

@implementation IDDoctorIsGoodAtDiseaseModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"disease_id":@"id"};
}

MJExtensionCodingImplementation

@end
