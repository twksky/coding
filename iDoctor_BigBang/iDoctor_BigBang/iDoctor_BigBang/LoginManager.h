//
//  LoginManager.h
//  iDoctor_Bigbang
//
//  Created by tianxiewuhua on 15/7/15.
//  Copyright (c) 2015年 iDoctor_Bigbang. All rights reserved.
//

#define kLoginStatusChangedNotification     @"e8332085-0b88-4aa8-83dc-b201272592fb"

enum ELoginStatus
{
    LOGINSTATUS_NONE = 0,
    LOGINSTATUS_LOGIN,
    LOGINSTATUS_CACHED
};

@interface LoginManager : NSObject

+ (LoginManager *)sharedInstance;

@property (nonatomic, assign) NSInteger loginStatus;


@end
