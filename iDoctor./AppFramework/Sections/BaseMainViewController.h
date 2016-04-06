//
//  BaseMainViewController.h
//  AppFramework
//
//  Created by 周世阳 on 15/5/11.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkinManager.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface BaseMainViewController : UIViewController

- (void)setNavigationBarWithTitle:(NSString *)title leftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem rightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem;

- (void)showLoading;

- (void)dismissLoading;

- (void)returnPreviousViewController;

- (UIBarButtonItem *)makeLeftReturnBarButtonItem;

- (UIBarButtonItem *)makeMiniLeftReturnBarButtonItem;

- (void)showSimpleAlertWithTitle:(NSString *)title msg:(NSString *)msg;

@end
