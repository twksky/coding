//
//  Bankcard.h
//  AppFramework
//
//  Created by ABC on 7/18/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bankcard : NSObject

@property (nonatomic, strong) NSString  *cardID;
@property (nonatomic, strong) NSString  *cardName;
@property (nonatomic, strong) NSString  *cardType;
@property (nonatomic, assign) BOOL      isDefault;

@end
