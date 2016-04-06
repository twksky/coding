//
//  IDAppManager.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/11/2.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDAppManager.h"
#import "LoginManager.h"
#import "LoginViewController.h"
#import "IDTabBarController.h"
#import "IDNewFeatureController.h"

@implementation IDAppManager

NSString * const kVersionKey = @"CFBundleVersion";
NSString * const kLoginKey   = @"loginKey";

+ (void)chooseRootController
{
    // 1.取出沙盒中存储的上次使用软件的版本号
    NSString *lastVersion = [GDUserDefaults stringForKey:kVersionKey];
    
    // 获得当前软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[kVersionKey];
    
    if ([currentVersion isEqualToString:lastVersion]) // 不是新版本
    {
        if ([GDUserDefaults boolForKey:kLoginKey]) {
            
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:[[LoginViewController alloc]init]];
            nav.navigationBarHidden = YES;
            [UIApplication sharedApplication].keyWindow.rootViewController = nav;
//            [LoginManager sharedInstance].loginStatus = LOGINSTATUS_NONE;
        }
        else
        {
            [UIApplication sharedApplication].statusBarHidden = NO;
            [LoginManager sharedInstance].loginStatus =LOGINSTATUS_LOGIN;
        }
    }
    else // 新版本
    {
        [UIApplication sharedApplication].keyWindow.rootViewController = [[IDNewFeatureController alloc] init];
        
        // 存储新版本
        [GDUserDefaults setObject:currentVersion forKey:kVersionKey];
        [GDUserDefaults setBool:YES forKey:kLoginKey];
        
        [GDUserDefaults synchronize];
    }


}

@end
