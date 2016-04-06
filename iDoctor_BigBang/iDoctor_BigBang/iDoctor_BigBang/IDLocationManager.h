//
//  IDLocationManager.h
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/11/7.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDLocationManager : NSObject

@property (nonatomic, strong) NSString *location;

+ (instancetype)sharedInstance;

@end
