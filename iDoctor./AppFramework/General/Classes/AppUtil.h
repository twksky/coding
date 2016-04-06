//
//  AppUtil.h
//  AppFramework
//
//  Created by ABC on 7/13/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppUtil : NSObject

+ (NSString *)pinyinFromChiniseString:(NSString *)string;
+ (char)sortSectionTitle:(NSString *)string;
+ (NSString*)parseString:(NSString *)stringValue;

@end
