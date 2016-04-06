//
//  SettingController.m
//  iDoctor_BigBang
//
//  Created by hexy on 印度历1937/8/7.
//  Copyright © 印度历1937年 YDHL. All rights reserved.
//

#import "SettingController.h"
#import "LoginViewController.h"
#import "ResetPasswodViewController.h"
#import "IDAppManager.h"
#import "IDResetPasswordViewController.h"

@interface SettingController ()

@end

@implementation SettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpData];
}


- (void)setUpData
{
    [self setUpSection0];
    [self setUpSection1];
    [self serUpSection2];
}

- (void)setUpSection0
{
    ArrowRowModel *fp = [ArrowRowModel arrowRowWithIcon:[UIImage imageNamed:@"changePassword"] title:@"修改密码" destVC:nil];
    
    [fp setRowSelectedBlock:^(NSIndexPath *indexPath) {
       
        IDResetPasswordViewController *reset = [[IDResetPasswordViewController alloc] init];
        [self.navigationController pushViewController:reset animated:YES];
  
    }];
    
    SectionModel *sectionModel = [SectionModel sectionModelWithRowModelArray:@[fp]];
    [self.sectionModelArray addObject:sectionModel];

}

- (void)setUpSection1
{
    BaseRowModel *logout = [BaseRowModel baseRowModelWithIcon:[UIImage imageNamed:@"logout"] title:@"安全退出"];
    
    [logout setRowSelectedBlock:^(NSIndexPath *indexPath) {
  
        
        [MBProgressHUD showMessage:@"正在退出..." toView:self.view isDimBackground:NO];
        [[AccountManager sharedInstance] resignLoginWithCompletionHandler:^() {
            
            [MBProgressHUD hideHUDForView:self.view];
            // 清除缓存
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            
//            [userDefault removeObjectForKey:@"loginName"];
            [userDefault removeObjectForKey:@"password"];
            
            [UIView animateWithDuration:3.0 animations:^{
                
                [MBProgressHUD showSuccess:@"退出成功" toView:self.view];

            } completion:^(BOOL finished) {
                
                [IDAppManager chooseRootController];
                
            }];
            
            
            
        } withErrorHandler:^(NSError *error) {
            
            [MBProgressHUD hideHUDForView:self.view];
            if ([error.localizedDescription isEqualToString:@"你的账号已在其他地方登录，请重新登录"]) {
                
                // 清除缓存
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                
//                [userDefault removeObjectForKey:@"loginName"];
                [userDefault removeObjectForKey:@"password"];
                
                [IDAppManager chooseRootController];

                [UIView animateWithDuration:3.0 animations:^{
                    
                    [MBProgressHUD showSuccess:@"退出成功" toView:self.view];
                    
                } completion:^(BOOL finished) {
                    
                    [IDAppManager chooseRootController];
                    
                }];
                
                
                
                return ;
            }
            
            [MBProgressHUD showError:error.localizedDescription toView:self.view];
            
        }];
        
        
        
    }];
    
    SectionModel *sectionModel = [SectionModel sectionModelWithRowModelArray:@[logout]];
    [self.sectionModelArray addObject:sectionModel];

}

- (void)serUpSection2
{
    UILabel *label = [[UILabel alloc] init];
    label.text = @"当前版本4.0";
    label.textColor = UIColorFromRGB(0xbfbfbf);
    label.font = [UIFont systemFontOfSize:15.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.borderColor = UIColorFromRGB(0xeaeaea).CGColor;
    label.layer.borderWidth = 1.0f;
    label.backgroundColor = [UIColor whiteColor];
    label.frame = CGRectMake(0, 140, App_Frame_Width, 60.0f);
    [self.view addSubview:label];
    
}


@end
