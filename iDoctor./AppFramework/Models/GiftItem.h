//
//  GiftItem.h
//  AppFramework
//
//  Created by ABC on 7/23/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GiftItem : NSObject

@property (nonatomic, assign) NSInteger dealID;
@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, strong) NSString  *userLoginName;
@property (nonatomic, strong) NSString  *userRealName;
@property (nonatomic, assign) NSInteger doctorID;
@property (nonatomic, strong) NSString  *doctorLoginName;
@property (nonatomic, strong) NSString  *doctorRealName;
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, assign) NSInteger money;
@property (nonatomic, assign) NSInteger acceptState;
@property (nonatomic, strong) NSString  *project;
@property (nonatomic, strong) NSString  *dateTimeISO;

@end
