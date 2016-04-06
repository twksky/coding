//
//  ApiManager.h
//  AppFramework
//
//  Created by ABC on 7/15/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageHandle.h"
#import "RegionItem.h"

@interface ApiManager : NSObject

+ (ApiManager *)sharedInstance;

#pragma mark - Method

- (void)asyncUploadImage:(UIImage *)image
   withCompletionHandler:(void (^)(ImageHandle *imageHandle))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;


@end
