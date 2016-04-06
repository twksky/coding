//
//  Patient.h
//  AppFramework
//
//  Created by ABC on 7/20/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FamilyMember;

@interface Patient : NSObject

@property (nonatomic, strong) NSString  *avatarURLString;
@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, strong) NSString  *loginName;
@property (nonatomic, strong) NSString  *pinYinLoginName;
@property (nonatomic, strong) NSString  *realName;
@property (nonatomic, strong) NSString  *pinYinRealName;
@property (nonatomic, strong) NSString  *noteName;
@property (nonatomic, strong) NSString  *pinYinNoteName;
@property (nonatomic, assign) NSInteger flowerAcceptance;
@property (nonatomic, assign) NSInteger flowerInvitation;
@property (nonatomic, assign) BOOL      isBlocked;
@property (nonatomic, assign) BOOL      isStarted;
@property (nonatomic, strong) FamilyMember  *firstFamilyMember;

- (NSString *)getDisplayName;
- (NSString *)getNoteName;

@end
