//
//  ChatViewController.h
//  iDoctor_BigBang
//
//  Created by twksky on 15/10/13.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import "BaseViewController.h"

@interface ChatViewController : BaseViewController

- (instancetype)initWithUserID:(NSString *)userID;//貌似给消息页用的
- (instancetype)initWithUserID:(NSString *)userID withMessage:(NSString *)message;
- (instancetype)initWithChatter:(NSString *)chatter withChatterAvatar:(UIImage *)chatterAvatar withMyAvatarURL:(NSString *)myAvatarURL;

//- (instancetype)initWithGroup:(EMGroup *)chatGroup;

-(void)sendTextMessage:(NSString *)textMessage;

@end
