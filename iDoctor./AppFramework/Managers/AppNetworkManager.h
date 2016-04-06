//
//  AppNetworkManager.h
//  AppFramework
//
//  Created by ABC on 8/13/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import <Foundation/Foundation.h>

enum NetworkType {
    NETWORK_NOTOK = -1,
    NETWORK_WIFI,
    NETWORK_WWAN
};

@interface AppNetworkManager : NSObject

+ (AppNetworkManager*) sharedInstance;

- (BOOL) isReachable;
- (BOOL) isReachableViaWiFi;
- (BOOL) isReachableViaWWAN;

@property (nonatomic, assign) NSInteger networkType;

@end
