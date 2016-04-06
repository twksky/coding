//
//  BaseViewController.h
//  iDoctor_BigBang
//
//  Created by twksky on 15/9/7.
//  Copyright (c) 2015年 twksky. All rights reserved.
//

#import "CellManger.h"

@interface BaseViewController : UIViewController


- (instancetype)initByRoot;
- (void)showWarningAlertWithTitle:(NSString *)title withMessage:(NSString *)message;
- (void)showLoading;
- (void)hideLoading;
- (void)handleError:(NSError *)error;
- (void)showTips:(NSString *)tip;

- (void)addTableView;
- (void)dismissLoading;
- (void)hidNavBarBottomLine;

- (void)showMessage:(NSString *)message;
- (void)hidMessage;


- (UIView *)tipViewWithName:(NSString *)name;



@end
