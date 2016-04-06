//
//  Payments.h
//  AppFramework
//
//  Created by ABC on 8/24/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Payments : NSObject

@property (nonatomic, assign) long      balance;
@property (nonatomic, strong) NSString  *dateTimeISO;
@property (nonatomic, assign) NSInteger recordID;
@property (nonatomic, assign) long      money;
@property (nonatomic, assign) NSInteger partnerID;
@property (nonatomic, strong) NSString  *project;

@end
