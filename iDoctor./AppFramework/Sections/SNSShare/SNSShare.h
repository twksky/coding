//
//  SNSShare.h
//  AppFramework
//
//  Created by ABC on 8/4/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNSShare : NSObject

+ (SNSShare *)sharedInstance;
+ (void)registerSdk;

//分享给微信好友
- (BOOL)shareToWXFriendWithContent:(NSString *)content;

//分享到微信朋友圈
- (BOOL)shareToWXMomentsWithContent:(NSString *)content;
@end
