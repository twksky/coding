/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import <UIKit/UIKit.h>

@interface ChatViewController : UIViewController

- (instancetype)initWithUserID:(NSInteger)userID;
- (instancetype)initWithUserID:(NSInteger)userID withMessage:(NSString *)message;
- (instancetype)initWithChatter:(NSString *)chatter withChatterAvatar:(UIImage *)chatterAvatar withMyAvatar:(UIImage *)myAvatar;

- (instancetype)initWithGroup:(EMGroup *)chatGroup;

-(void)sendTextMessage:(NSString *)textMessage;

@end
