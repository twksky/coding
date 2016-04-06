//
//  MBProgressHUD+Extension.h
//  GoodDoctor
//
//  Created by hexy on 15/7/4.
//  Copyright (c) 2015年 hexy. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Extension)

#pragma mark - 显示HUD到(默认显示到当前视图上）
/**
 *  显示成功信息
 *
 *  @param success 提示文字
 */
+ (void)showSuccess:(NSString *)success;

/**
 *  显示失败信息
 *
 *  @param error 提示文字
 */
+ (void)showError:(NSString *)error;

/**
 *  显示提示信息
 *
 *  @param message 提示信息
 *
 *  @return MBProgressHUD
 */
+ (MBProgressHUD *)showMessage:(NSString *)message;

#pragma mark - 显示HUD到指定视图上
/**
 *  显示成功HUD到指定定View上
 *
 *  @param success 提示文字
 *  @param view
 */
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

/**
 *  显示失败HUD到指定定View上
 *
 *  @param error 提示文字
 *  @param view
 */
+ (void)showError:(NSString *)error toView:(UIView *)view;

/**
 *  显示提示信息到指定视图上
 *
 *  @param message 提示文字
 *  @param view    指定View
 *  @param isDim   是否需要蒙版
 *
 *  @return MBProgressHUD
 */
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view isDimBackground:(BOOL)isDim;

#pragma mark - 隐藏HUD
/**
 *  将某个视图上HUD隐藏
 *
 *  @param view 要隐藏HUDView
 */
+ (void)hideHUDForView:(UIView *)view;

/**
 *  隐藏
 */
+ (void)hideHUD;
@end
