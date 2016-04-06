//
//  QuickDiagnoseComment.m
//  iDoctor_BigBang
//
//  Created by 周世阳 on 15/10/21.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import "QuickDiagnoseComment.h"

@implementation QuickDiagnoseComment

+ (NSDictionary *)replacedKeyFromPropertyName {
    
    return @{
             @"commentId": @"id",
             @"commentContent": @"description"
             };
}


@end


