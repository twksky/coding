//
//  HospitalItem.h
//  AppFramework
//
//  Created by ABC on 7/19/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HospitalItem : NSObject

@property (nonatomic, assign) NSInteger hospitalID;
@property (nonatomic, assign) NSInteger regionID;
@property (nonatomic, strong) NSString  *name;
@property (nonatomic, strong) NSString  *grade;
@property (nonatomic, strong) NSString  *pinYinName;

@end
