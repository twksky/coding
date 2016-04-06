//
//  ScoreModel.h
//  AppFramework
//
//  Created by tianxiewuhua on 15/6/23.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScoreModel : NSObject

// 积分的ID
@property (nonatomic, assign) NSInteger scoreId;

// 积分的条数
@property (nonatomic, assign) NSInteger count;

// 积分的描述
@property (nonatomic, strong) NSString *scoreDescription;

// 得到积分的时间
@property (nonatomic, strong) NSString *scoreCtimeIso;
@end
