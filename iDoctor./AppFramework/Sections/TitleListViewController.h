//
//  TitleListViewController.h
//  AppFramework
//
//  Created by ABC on 7/22/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TitleListViewController;

@protocol TitleListViewControllerDelegate <NSObject>

- (void)titleListViewController:(TitleListViewController *)viewController didSelectedTitle:(NSString *)title;

@end

@interface TitleListViewController : UIViewController

@property (nonatomic, weak) id<TitleListViewControllerDelegate> delegate;

@end
