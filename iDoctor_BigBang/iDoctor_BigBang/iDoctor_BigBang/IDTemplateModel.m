//
//  IDTemplateModel.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/10/23.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDTemplateModel.h"
#import <MJExtension.h>

@implementation IDTemplateModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"id":@"templateId"};
}

+ (NSDictionary *)objectClassInArray
{
    return @{@"fields":@"NSString"};
}

@end
