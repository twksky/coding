//
//  MBProgressHUD+Extension.m
//  GoodDoctor
//
//  Created by hexy on 15/7/4.
//  Copyright (c) 2015年 hexy. All rights reserved.
//

#import "MBProgressHUD+Extension.h"

@implementation MBProgressHUD (Extension)

#pragma mark - 显示HUD到(默认显示到当前视图上）
/**
 *  显示成功信息
 *
 *  @param success 提示文字
 */
+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

/**
 *  显示失败信息
 *
 *  @param error 提示文字
 */
+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}

/**
 *  显示提示信息
 *
 *  @param message 提示信息
 *
 *  @return MBProgressHUD
 */
+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil isDimBackground:YES];
}

#pragma mark - 显示HUD到指定视图上
/**
 *  显示成功HUD到指定定View上
 *
 *  @param success 提示文字
 *  @param view
 */
+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view];
}

/**
 *  显示失败HUD到指定定View上
 *
 *  @param error 提示文字
 *  @param view
 */
+ (void)showError:(NSString *)error toView:(UIView *)view
{
    [self show:error icon:@"error.png" view:view];
}

/**
 *  显示提示信息到指定视图上
 *
 *  @param message 提示文字
 *  @param view    指定View
 *  @param isDim   是否需要蒙版
 *
 *  @return MBProgressHUD
 */
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view isDimBackground:(BOOL)isDim
{
    if (!view)
    {
        view = [[UIApplication sharedApplication].windows lastObject];
    }
    
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // YES代表需要蒙版效果
    hud.dimBackground = isDim;
    
    return hud;
}

#pragma mark - 隐藏HUD
/**
 *  将某个视图上HUD隐藏
 *
 *  @param view 要隐藏HUDView
 */
+ (void)hideHUDForView:(UIView *)view
{
    [self hideHUDForView:view animated:YES];
}

/**
 *  隐藏
 */
+ (void)hideHUD
{
    [self hideHUDForView:nil];
}

/**
 *  显示文字信息和图标到指定视图上
 *
 *  @param text 提示文字
 *  @param icon 图标
 *  @param view 指定View
 */
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (!view)
    {
        view = [[UIApplication sharedApplication].windows lastObject];
    }
    
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hide:YES afterDelay:1.0];
}

@end
