//
//  QuickQuestion.h
//  AppFramework
//
//  Created by DebugLife on 1/20/15.
//  Copyright (c) 2015 AppChina. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Patient;

@interface QuickQuestion : NSObject

@property (nonatomic, assign) NSInteger     questionID;
@property (nonatomic, assign) NSInteger     userID;
@property (nonatomic, assign) NSInteger     regionID;
@property (nonatomic, strong) NSString      *conditionDescription;
@property (nonatomic, strong) NSMutableArray       *imagesURLStrings;
@property (nonatomic, assign) NSInteger     imagesCount;
@property (nonatomic, strong) NSString      *lastTime;
@property (nonatomic, strong) NSString      *incentives;
@property (nonatomic, strong) NSString      *otherDisease;
@property (nonatomic, strong) NSString      *operationHistory;
@property (nonatomic, strong) NSString      *geneticHistory;
@property (nonatomic, strong) NSString      *department;
@property (nonatomic, strong) NSDate        *createTime;
@property (nonatomic, strong) NSDate        *modifyTime;
@property (nonatomic, strong) NSMutableArray       *comments;
@property (nonatomic, assign) NSInteger     commentsCount;
@property (nonatomic, strong) Patient       *patient;

@property (nonatomic, strong) NSString *sex;
@property (nonatomic, assign) NSInteger age;

@end
