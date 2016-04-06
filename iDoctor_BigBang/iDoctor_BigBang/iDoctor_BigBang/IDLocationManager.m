//
//  IDLocationManager.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/11/7.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDLocationManager.h"

@implementation IDLocationManager

+(instancetype)sharedInstance
{
    static IDLocationManager *instance;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        
        instance = [[self alloc] init];
    });
    
    return instance;
}

@end
