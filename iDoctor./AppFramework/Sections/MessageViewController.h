//
//  MessageViewController.h
//  AppFramework
//
//  Created by ABC on 6/2/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseMainViewController.h"

@interface MessageViewController : BaseMainViewController

@property (nonatomic, assign) NSInteger systemUnreadMessageCount;
@property (nonatomic, assign) NSInteger recentlyUnreadMessageCount;

- (void)updateUnreadCount:(NSInteger)count withUserID:(NSString *)userID;
- (void)updateUnreadCountWithCmdMessage:(EMMessage *)cmdMessage;

@end
