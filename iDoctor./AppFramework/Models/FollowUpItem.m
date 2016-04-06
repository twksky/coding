//
//  FollowUpItem.m
//  AppFramework
//
//  Created by DebugLife on 1/31/15.
//  Copyright (c) 2015 AppChina. All rights reserved.
//

#import "FollowUpItem.h"

@implementation FollowUpItem

- (id)init
{
    self = [super init];
    if (self) {
        self.bodyTemperature = 37.5f;
        self.bloodGlucose = 0.0f;
        self.highBloodPressure = 90;
        self.lowBloodPressure = 90;
        self.painStatus = 0;
    }
    return self;
}

@end
