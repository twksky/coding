//
//  Comment.h
//  AppFramework
//
//  Created by DebugLife on 1/24/15.
//  Copyright (c) 2015 AppChina. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Account;

@interface Comment : NSObject

@property (nonatomic, assign) NSInteger     commentID;
@property (nonatomic, strong) NSString      *commentDescription;
@property (nonatomic, assign) NSInteger     commentCount;
@property (nonatomic, strong) Account       *doctor;
@property (nonatomic, strong) NSString      *ctimeISO;

@end
