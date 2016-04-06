//
//  IntroductionViewController.h
//  AppFramework
//
//  Created by ABC on 7/26/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IntroductionViewController;

@protocol IntroductionViewControllerDelegate <NSObject>

- (void)introductionViewDidFinish:(IntroductionViewController *)viewController;

@end

@interface IntroductionViewController : UIViewController

@property (nonatomic, weak) id<IntroductionViewControllerDelegate> delegate;

@end
