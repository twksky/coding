//
//  FollowUpReport.h
//  AppFramework
//
//  Created by DebugLife on 1/31/15.
//  Copyright (c) 2015 AppChina. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Patient;
@class Account;

@interface FollowUpReport : NSObject

@property (nonatomic, assign) NSInteger         reportID;
@property (nonatomic, strong) NSString          *followUpType;
@property (nonatomic, strong) NSMutableArray    *imagesURLStrings;
@property (nonatomic, assign) NSInteger         imagesCount;
@property (nonatomic, strong) NSString          *medicalRecordNumber;   // 病历号
@property (nonatomic, assign) NSInteger         reportFrequencyInDay;
@property (nonatomic, assign) NSInteger         reportCount;
@property (nonatomic, strong) Patient           *patient;
@property (nonatomic, strong) Account           *doctor;
@property (nonatomic, strong) NSMutableArray    *reportItems;
@property (nonatomic, assign) NSInteger         totalPrice;
@property (nonatomic, assign) BOOL              isReceive;

@end
