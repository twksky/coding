//
//  AppNetworkManager.m
//  AppFramework
//
//  Created by ABC on 8/13/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "AppNetworkManager.h"
#import "AppNetworkEngine.h"
#import <Reachability/Reachability.h>

@interface AppNetworkManager ()
@property (nonatomic, strong) Reachability               *reachability;
@end

@implementation AppNetworkManager

+ (AppNetworkManager*) sharedInstance
{
    static AppNetworkManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AppNetworkManager alloc] init];
        [instance initManager];
    });
    return instance;
}

- (void)initManager
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    self.reachability = [Reachability reachabilityWithHostname:kHostName];
    [self.reachability startNotifier];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)reachabilityChanged:(NSNotification *) _notification
{
    Reachability *reach = _notification.object;
    if (![reach isReachable]) {
        DLog(@"当前网络不可用");
        self.networkType = NETWORK_NOTOK;
    } else if(reach.isReachableViaWiFi){
        DLog(@"当前网络通过WIFI连接");
        self.networkType = NETWORK_WIFI;
    } else if(reach.isReachableViaWWAN){
        DLog(@"当前网络通过2g/3g连接");
        self.networkType = NETWORK_WWAN;
    }
}

- (BOOL) isReachable
{
    return [self.reachability isReachable];
}

- (BOOL) isReachableViaWiFi
{
    return [self.reachability isReachableViaWiFi];
}

- (BOOL) isReachableViaWWAN
{
    return [self.reachability isReachableViaWWAN];
}

@end
