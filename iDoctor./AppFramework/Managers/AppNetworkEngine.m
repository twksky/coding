//
//  AppNetworkEngine.m
//  AppFramework
//
//  Created by ABC on 7/1/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "AppNetworkEngine.h"
#import <Reachability/Reachability.h>

@interface AppNetworkEngine ()

@property (nonatomic,strong) Reachability               *reachability;

//- (void)initEngine;

@end

@implementation AppNetworkEngine
/*
+ (AppNetworkEngine *)sharedInstance
{
    static AppNetworkEngine *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AppNetworkEngine alloc] initWithHostName:kHostName];
        [instance initEngine];
    });
    return instance;
}

- (void)initEngine
{
    [self useCache];
}
*/

- (id)init
{
    self = [super init];
    if (self) {
        self.reachability = [Reachability reachabilityWithHostname:kHostName];
        [self.reachability startNotifier];
    }
    return self;
}

- (NSString*)cacheDirectoryName
{
    static NSString *cacheDirectoryName = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = paths[0];
        cacheDirectoryName = [documentsDirectory stringByAppendingPathComponent:@"images"];
    });
    
    return cacheDirectoryName;
}

- (int)cacheMemoryCost
{
    return 0;
}

@end
