//
//  ManagerUtil.m
//  AppFramework
//
//  Created by ABC on 7/6/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "ManagerUtil.h"
#import <JSONKit-NoWarning/JSONKit.h>

@implementation ManagerUtil

+ (NSInteger)parseStatusCode:(NSDictionary *)jsonData
{
    NSInteger statusCode = -1;
    if ([jsonData objectForKey:@"status_code"]) {
        statusCode = [[jsonData objectForKey:@"status_code"] integerValue];
    }
    return statusCode;
}

+ (NSString *)parseStatusMessage:(NSDictionary *)jsonData
{
    return [jsonData objectForKey:@"status_message"];
}

+ (id)filterObject:(id)obj
{
    if ([obj isEqual:[NSNull null]]) {
        return nil;
    }
    return obj;
}

+ (NSString *)parseGender:(NSString *)enGender
{
    if ([enGender isEqualToString:@"male"]) {
        return @"男";
    } else if ([enGender isEqualToString:@"female"]) {
        return @"女";
    }
    return @"";
}

@end
