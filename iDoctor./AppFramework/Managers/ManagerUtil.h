//
//  ManagerUtil.h
//  AppFramework
//
//  Created by ABC on 7/6/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ManagerUtil : NSObject

+ (NSInteger)parseStatusCode:(NSDictionary *)jsonData;
+ (NSString *)parseStatusMessage:(NSDictionary *)jsonData;
+ (id)filterObject:(id)obj;
+ (NSString *)parseGender:(NSString *)enGender;

@end
