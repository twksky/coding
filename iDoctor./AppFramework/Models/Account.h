//
//  Account.h
//  AppFramework
//
//  Created by ABC on 7/2/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegionItem.h"
#import "HospitalItem.h"

@interface Account : NSObject

@property (nonatomic, strong) NSString *token;

@property (nonatomic, assign) NSInteger accountID;
@property (nonatomic, strong) NSString *loginName;
@property (nonatomic, strong) NSString *easemobPassword;
@property (nonatomic, assign) BOOL      isOnline;

@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *realName;
@property (nonatomic, strong) RegionItem    *region;
@property (nonatomic, strong) HospitalItem  *hospital;
@property (nonatomic, strong) NSString *department;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *schedule;
@property (nonatomic, strong) NSString *brief;
@property (nonatomic, strong) NSString *credentialsID;
@property (nonatomic, strong) NSString *certificateImageURLString;
@property (nonatomic, strong) NSString *officePhone;
@property (nonatomic, strong) NSString *avatarImageURLString;
@property (nonatomic, strong) NSString *qCodeImageUrlString;
@property (nonatomic, strong) NSString *pinYinName;

@property (nonatomic, assign) long      money;
@property (nonatomic, assign) long      balance;

@property (nonatomic, assign) NSInteger     hospitalAskPrice;       // 出院
@property (nonatomic, assign) NSInteger     outPatientAskPrice;     // 门诊价格
@property (nonatomic, assign) NSInteger     urgencyAskPrice;

@property (nonatomic, assign) NSInteger     score;

- (NSString *)getDisplayName;

@end
