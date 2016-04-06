//
//  UrgentCallInfo.h
//  AppFramework
//
//  Created by DebugLife on 1/27/15.
//  Copyright (c) 2015 AppChina. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Patient;
@class Account;

@interface UrgentCallInfo : NSObject

@property (nonatomic, assign) NSInteger         callID;
@property (nonatomic, assign) NSInteger         money;
@property (nonatomic, strong) NSString          *infoDescription;
@property (nonatomic, strong) NSMutableArray    *imagesURLStrings;
@property (nonatomic, assign) NSInteger         imagesCount;
@property (nonatomic, strong) NSDate            *expireDate;
@property (nonatomic, strong) NSDate            *createTime;
@property (nonatomic, assign) BOOL              isReceive;
@property (nonatomic, strong) Patient           *patient;
@property (nonatomic, strong) Account           *doctor;

@property (nonatomic, assign) BOOL isExpanded;

@end
