//
//  LocalCacheManager.h
//  AppFramework
//
//  Created by ABC on 7/13/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Account;

@interface LocalCacheManager : NSObject

+ (LocalCacheManager *)sharedInstance;

/*!
 @description 判断是否是第一次启动
 */
- (BOOL) isFirstLaunch;
- (void) setFirstLaunched;
- (BOOL)isPlayVibration;
- (void)setPlayVibration:(BOOL)bPlayVibration;
- (BOOL)isPlayFromSpeaker;
- (void)setPlayFromSpeaker:(BOOL)bPlayFromSpeaker;

- (NSString *)saveAvatarImage:(UIImage *)avatarImage;
- (void)saveLoginAccountWithLoginName:(NSString *)loginName withLoginPassword:(NSString *)loginPassword;
- (NSString *)getAccountLoginName;
- (NSString *)getAccountLoginPassword;

#define SM_UrgencyCall          @"urgency_call_cmd"
#define SM_InHospitalFollowUp   @"follow_up_in_hospital_cmd"
#define SM_OutpatientFollowUp   @"follow_up_outpatient_cmd"
#define SM_QuickQuestion        @"quickly_ask_cmd"
- (NSInteger)getSystemMessageUnreadCountWithMessageType:(NSString *)msgType;
- (void)saveSystemMessageUnreadCount:(NSInteger)msgCount withMessageType:(NSString *)msgType;

- (void)emptyCache;

@end
