//
//  FollowUpItem.h
//  AppFramework
//
//  Created by DebugLife on 1/31/15.
//  Copyright (c) 2015 AppChina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FollowUpItem : NSObject

@property (nonatomic, assign) NSInteger         itemID;
@property (nonatomic, strong) NSMutableArray    *imagesURLStrings;
@property (nonatomic, assign) BOOL              isMedicationCompliance; // 服药是否正常
@property (nonatomic, strong) NSString          *woundStatus;
@property (nonatomic, assign) NSInteger         painStatus;
@property (nonatomic, strong) NSString          *urineStatus;
@property (nonatomic, strong) NSString          *foodStatus;
@property (nonatomic, strong) NSString          *symptomsStatus;
@property (nonatomic, assign) BOOL              isSetBodyTemperature;
@property (nonatomic, assign) float             bodyTemperature;
@property (nonatomic, strong) NSString          *symptomsDescription;   // 症状描述
@property (nonatomic, assign) BOOL              isSetBloodGlucose;
@property (nonatomic, assign) float             bloodGlucose;
@property (nonatomic, assign) BOOL              isSetHighBloodPressure;
@property (nonatomic, assign) NSInteger         highBloodPressure;
@property (nonatomic, assign) BOOL              isSetLowBloodPressure;
@property (nonatomic, assign) NSInteger         lowBloodPressure;
@property (nonatomic, strong) NSDate            *createTime;
@property (nonatomic, assign) BOOL              isReceived;

@end
