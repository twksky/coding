//
//  ImageHandle.h
//  AppFramework
//
//  Created by ABC on 7/15/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageHandle : NSObject

@property (nonatomic, assign) NSInteger imageID;
@property (nonatomic, strong) NSString  *imageName;
@property (nonatomic, strong) NSString  *imageURLString;

@end
