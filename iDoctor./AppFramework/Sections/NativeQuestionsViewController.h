//
//  NativeQuestionsViewController.h
//  AppFramework
//
//  Created by 周世阳 on 15/5/15.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseMainViewController.h"
#import "DFDQuickQuestionDetailViewController.h"

@class QuickQuestion;
@class Comment;

@protocol NativeQuestionsListPort <NSObject>

- (void)updateListWithQuestion:(QuickQuestion *)question Comment:(Comment *)comment;

- (void)officeTypeChanged:(NSString *)officeType;

@end

@interface NativeQuestionsViewController : BaseMainViewController <DFDQuickQuestionDetailViewControllerDelegate>

@end
