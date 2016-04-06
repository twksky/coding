//
//  NativeQuestionReplyViewController.h
//  AppFramework
//
//  Created by 周世阳 on 15/7/9.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseMainViewController.h"

@protocol NativeQuestionReplyViewControllerDelegate <NSObject>

- (void)replyWithText:(NSString *)text;

@end

@interface NativeQuestionReplyViewController : BaseMainViewController

@property (nonatomic, weak) id<NativeQuestionReplyViewControllerDelegate> delegate;

@end
