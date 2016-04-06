//
//  DFDQuickQuestionDetailViewController.h
//  AppFramework
//
//  Created by DebugLife on 2/8/15.
//  Copyright (c) 2015 AppChina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseMainViewController.h"

@class QuickQuestion;
@class Comment;
@class DFDQuickQuestionDetailViewController;

@protocol DFDQuickQuestionDetailViewControllerDelegate <NSObject>

- (void)quickQuestionDetailViewController:(DFDQuickQuestionDetailViewController *)viewController didAddComment:(Comment *)comment forQuickQuestion:(QuickQuestion *)quickQuestion;

@end

@interface DFDQuickQuestionDetailViewController : BaseMainViewController

@property (nonatomic, weak) id<DFDQuickQuestionDetailViewControllerDelegate> delegate;

@property (nonatomic, strong) QuickQuestion *quickQuestion;

@end
