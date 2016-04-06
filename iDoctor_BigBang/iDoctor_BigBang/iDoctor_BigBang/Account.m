//
//  Account.m
//  iDoctor_BigBang
//
//  Created by tianxiewuhua on 15/9/14.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import "Account.h"
#import <MJExtension.h>

@implementation Account

- (NSString *)getDisplayName
{
    if (self.realname && ![self.realname isEqual:[NSNull null]] && [self.realname length] > 0) {
        return self.realname;
    }
    return [NSString stringWithFormat:@"%ld", (long)self.doctor_id];
}

+ (NSDictionary *)replacedKeyFromPropertyName
{
    
    return @{@"doctor_id":@"id"};
}

+ (NSDictionary *)objectClassInArray {
    
    return @{@"skills": @"IDDoctorIsGoodAtDiseaseModel"};
}

MJExtensionCodingImplementation

@end
