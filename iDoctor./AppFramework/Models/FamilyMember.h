//
//  FamilyMember.h
//  AppFramework
//
//  Created by DebugLife on 11/6/14.
//  Copyright (c) 2014 AppChina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FamilyMember : NSObject

@property (nonatomic, assign) NSInteger familyMemberID;
@property (nonatomic, strong) NSString  *name;
@property (nonatomic, strong) NSString  *allergies;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, strong) NSString  *gender;
@property (nonatomic, strong) NSString  *avatarURLString;

@end
