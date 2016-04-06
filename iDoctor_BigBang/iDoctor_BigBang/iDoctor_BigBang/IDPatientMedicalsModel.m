//
//  IDPatientMedicalsModel.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/10/20.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDPatientMedicalsModel.h"
#import <MJExtension.h>

@implementation IDPatientMedicalsModel

+ (NSDictionary *)objectClassInArray {
    
    return @{@"comments": @"IDPatientMedicalsCommentsModel"};
}

@end
