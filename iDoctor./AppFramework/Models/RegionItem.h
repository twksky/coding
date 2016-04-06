//
//  RegionItem.h
//  AppFramework
//
//  Created by ABC on 7/8/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegionItem : NSObject

@property (nonatomic, strong) NSString          *name;
@property (nonatomic, strong) NSString          *pinYinName;
@property (nonatomic, assign) NSInteger         code;
@property (nonatomic, assign) NSInteger         level;
@property (nonatomic, strong) NSMutableArray    *subItemArray;

@end
