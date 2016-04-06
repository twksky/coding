//
//  LoginManager.m
//  AppFramework
//
//  Created by ABC on 6/21/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "LoginManager.h"

@implementation LoginManager

+ (LoginManager *)sharedInstance
{
    static LoginManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LoginManager alloc] init];
    });
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.loginStatus = LOGINSTATUS_NONE;
        [self addObserver:self forKeyPath:@"loginStatus" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"loginStatus"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginStatusChangedNotification object:[NSNumber numberWithInteger:self.loginStatus]];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
@end
