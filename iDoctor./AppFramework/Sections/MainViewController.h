//
//  MainViewController.h
//  AppFramework
//
//  Created by ABC on 6/2/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;

@protocol MainViewControllerDelegate <NSObject>

- (void)mainViewController:(MainViewController *)mainViewController didActivedViewController:(UIViewController *)activedViewController;

@end

@interface MainViewController : UIViewController

@property (nonatomic, weak) id<MainViewControllerDelegate> delegate;

@end
