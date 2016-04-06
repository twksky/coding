//
//  AppDelegate.m
//  iDoctor_BigBang
//
//  Created by twksky on 15/9/6.
//  Copyright (c) 2015年 twksky. All rights reserved.
//

#import "AppDelegate.h"
#import "IDTabBarController.h"
#import "AccountManager.h"
#import <Bugtags/Bugtags.h>
#import "LoginManager.h"

//Test
#import "LoginViewController.h"

#import "IDAppManager.h"

#import "IDPatientCaseDetailViewController.h"

@interface AppDelegate ()<IChatManagerDelegate>

@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //twk
    //白色状态栏
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //环信
#warning SDK注册 APNS文件的名字, 需要与后台上传证书时的名字一一对应
    NSString *apnsCertName = nil;
#if DEBUG
    apnsCertName = @"iDoctorPushDevCertificates";
#else
    //    apnsCertName = @"iDoctorPushProductionAppStoreCertificates";   //生产环境下, 上传AppStore的用这个证书
    apnsCertName = @"iDoctorPushProductionEntCertificates"; //企业版用这个证书
#endif
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"haoyisheng#haoyishengdoctor" apnsCertName:apnsCertName];
#if DEBUG
    [[EaseMob sharedInstance] enableUncaughtExceptionHandler];
#endif
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
//LoginManger
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStatusChanged:) name:kLoginStatusChangedNotification object:nil];

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [IDAppManager chooseRootController];

//    IDTabBarController *tabBarC = [IDTabBarController new];
//    
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
//    nav.navigationBar.translucent = NO;
////    self.window.rootViewController = nav;
//    
//    IDPatientCaseDetailViewController *xx = [[IDPatientCaseDetailViewController alloc] init];
//    
//    self.window.rootViewController = nav;
    
//    BugTags Init
     [Bugtags startWithAppKey:@"b7a98f146008eedfad4e0563bb199347" invocationEvent:BTGInvocationEventNone];

    
   /*
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {                [application setStatusBarStyle:UIStatusBarStyleLightContent];                self.window.clipsToBounds =YES;
        self.window.frame =  CGRectMake(0,20,self.window.frame.size.width,self.window.frame.size.height-20);
        //added on 19th Sep
        //self.window.bounds = CGRectMake(0, 20, self.window.frame.size.width, self.window.frame.size.height);
    }
    */
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
#warning SDK方法调用
    // 让SDK得到App目前的各种状态，以便让SDK做出对应当前场景的操作
    [[EaseMob sharedInstance] applicationWillResignActive:application];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [[AccountManager sharedInstance] cacheAccount];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
#warning SDK方法调用
    // 让SDK得到App目前的各种状态，以便让SDK做出对应当前场景的操作
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
    
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
#warning SDK方法调用
    // 让SDK得到App目前的各种状态，以便让SDK做出对应当前场景的操作
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    application.applicationIconBadgeNumber = 0;//如果有消息点进去之后图标上的数字就消失了
#warning SDK方法调用
    // 让SDK得到App目前的各种状态，以便让SDK做出对应当前场景的操作
    [[EaseMob sharedInstance] applicationDidBecomeActive:application];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#warning SDK方法调用
    // 让SDK得到App目前的各种状态，以便让SDK做出对应当前场景的操作
    [[EaseMob sharedInstance] applicationWillTerminate:application];
    

}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
#warning SDK方法调用
    // 让SDK得到App目前的各种状态，以便让SDK做出对应当前场景的操作
    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    
//    [self updateAPNSToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
#warning SDK方法调用
    [[EaseMob sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
    NSString *error_str = [NSString stringWithFormat: @"%@", error];
    NSLog(@"Failed to get token, error:%@", error_str);
}

//获取远程通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //当用户打开程序时候收到远程通知后执行
    application.applicationIconBadgeNumber = 0;
    if (application.applicationState == UIApplicationStateActive) {
        
    } else {
        
    }
    
#warning SDK方法调用
    [[EaseMob sharedInstance] application:application didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
#warning SDK方法调用
    [[EaseMob sharedInstance] application:application didReceiveLocalNotification:notification];
}

#pragma mark - LoginMangerNotification
- (void)loginStatusChanged:(NSNotification *)notification
{
    if ([LoginManager sharedInstance].loginStatus == LOGINSTATUS_NONE) {
        
        

        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        
//        [userDefault removeObjectForKey:@"loginName"];
        [userDefault removeObjectForKey:@"password"];
        [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES];
        UINavigationController *loginNav = [[UINavigationController alloc]initWithRootViewController:[[LoginViewController alloc] init]];
        loginNav.navigationBarHidden = YES;
        self.window.rootViewController = loginNav;
    } else if ([LoginManager sharedInstance].loginStatus == LOGINSTATUS_LOGIN) {
        
        self.window.rootViewController = [[IDTabBarController alloc] init];
    }
}

@end
