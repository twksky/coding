//
//  BaseMainViewController.m
//  AppFramework
//
//  Created by 周世阳 on 15/5/11.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "BaseMainViewController.h"

@interface BaseMainViewController ()

@end

@implementation BaseMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [SkinManager sharedInstance].defaultNavigationBarBackgroundColor;
    self.navigationController.navigationBar.translucent = NO;
    NSDictionary * dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
}

- (void)setNavigationBarWithTitle:(NSString *)title leftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem rightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem {

    [self.navigationItem setTitle:title];
    
    if (leftBarButtonItem) {
        
        leftBarButtonItem.tintColor = [SkinManager sharedInstance].defaultNavigationBarButtonItemTintColor;
        self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    }
    
    if (rightBarButtonItem) {
        
        rightBarButtonItem.tintColor = [SkinManager sharedInstance].defaultNavigationBarButtonItemTintColor;
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    }
}

#pragma mark - public methods

- (void)returnPreviousViewController {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIBarButtonItem *)makeLeftReturnBarButtonItem {
    
    UIButton *returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    returnButton.frame = CGRectMake(0.0f, 0.0f, 70.0f, 44.0f);
    [returnButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [returnButton setTitle:@"返回" forState:UIControlStateNormal];
    returnButton.imageEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    returnButton.titleEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    [returnButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [returnButton setTitleColor:UIColorFromRGB(0x888888) forState:UIControlStateHighlighted];
    [returnButton addTarget:self action:@selector(returnPreviousViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *returnBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:returnButton];
    return returnBarButtonItem;
}



- (UIBarButtonItem *)makeMiniLeftReturnBarButtonItem {
    
    UIButton *returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    returnButton.frame = CGRectMake(0.0f, 0.0f, 44.0f, 44.0f);
    [returnButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    returnButton.imageEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    [returnButton addTarget:self action:@selector(returnPreviousViewController) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *returnBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:returnButton];
    return returnBarButtonItem;
}

- (void)showSimpleAlertWithTitle:(NSString *)title msg:(NSString *)msg {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)showHint:(NSString *)hint {
    
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = hint;
    hud.margin = 10.f;
    hud.yOffset = IS_IPHONE_5?200.f:150.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

- (void)showLoading {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)dismissLoading {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

@end
