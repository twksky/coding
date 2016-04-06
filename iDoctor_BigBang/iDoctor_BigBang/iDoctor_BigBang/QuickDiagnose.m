//
//  QuickDiagnose.m
//  iDoctor_BigBang
//
//  Created by 周世阳 on 15/10/14.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import "QuickDiagnose.h"

@implementation QuickDiagnose

+ (NSDictionary *)replacedKeyFromPropertyName {
    
    return @{@"quickDiagnoseId": @"id",
             @"quickDiagnoseDescription": @"description"};
}

@end

@implementation User

+ (NSDictionary *)replacedKeyFromPropertyName {
    
    return @{@"userId": @"id"};
}

@end


