//
//  LoginManager.h
//  AppFramework
//
//  Created by ABC on 6/21/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kLoginStatusChangedNotification     @"0F37A994-9651-4046-94C6-4195383A5B32"

enum ELoginStatus
{
    LOGINSTATUS_NONE = 0,
    LOGINSTATUS_LOGING,
    LOGINSTATUS_ONLINE,
    LOGINSTATUS_AWAY,
    LOGINSTATUS_DISCONNECT
};

@interface LoginManager : NSObject

+ (LoginManager *)sharedInstance;

@property (nonatomic, assign) NSInteger loginStatus;

@end
