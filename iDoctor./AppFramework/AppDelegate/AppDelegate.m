//
//  AppDelegate.m
//  AppFramework
//
//  Created by ABC on 5/31/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "AppDelegate.h"
#import "SkinManager.h"
#import "IntroductionViewController.h"
#import "LoginViewController.h"
#import "MainViewController.h"
#import "LoginManager.h"
#import "ContactManager.h"
#import "LocalCacheManager.h"
#import "SNSShare.h"
#import "iVersion.h"
#import "AppNetworkManager.h"
#import "AccountManager.h"
#import "MobClick.h"
#import "MainTabBarViewController.h"

@interface AppDelegate ()
<
IntroductionViewControllerDelegate,
IChatManagerDelegate,
iVersionDelegate
>

+ (void)initiVersion;

- (void)loginstatusChanged:(NSNotification *)notification;

- (void)updateAPNSToken:(NSData *)deviceToken;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Init Manager
    //[AccountManager sharedInstance];
    //[ContactManager sharedInstance];
    [AppNetworkManager sharedInstance];
    // Init SNSShare
    [SNSShare registerSdk];
    // Init iVersion
#ifdef kCompileForEnterprise
    [AppDelegate initiVersion];   // 去掉检测升级功能
#endif
    // Init UMeng
#ifdef DEBUG
    [MobClick setCrashReportEnabled:YES]; // 如果不需要捕捉异常，注释掉此行
#endif
    [MobClick startWithAppkey:@"53cdd3c556240bbd95196815" reportPolicy:SEND_ON_EXIT channelId:@"iDoctor-iOS"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginstatusChanged:) name:kLoginStatusChangedNotification object:nil];
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // TODO:注册APNS
    //注册APNS
    //[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];

    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")) {
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        }  else {
            UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
        }
    } else {
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
    
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
    
#warning 注册为SDK的ChatManager的delegate (及时监听到申请和通知)
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [SkinManager sharedInstance].defaultViewBackgroundColor;

    UIViewController *rootViewController = nil;
    if ([[LocalCacheManager sharedInstance] isFirstLaunch]) {
        rootViewController = [self createIntroductionViewController];
    } else {
        rootViewController = [self createLoginNavigationController];
    }
    [self.window setRootViewController:rootViewController];
    [self.window makeKeyAndVisible];
    
    //TODO 去除navigationBar底部黑边
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
#warning SDK方法调用
    // 让SDK得到App目前的各种状态，以便让SDK做出对应当前场景的操作
    [[EaseMob sharedInstance] applicationWillResignActive:application];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
#warning SDK方法调用
    // 让SDK得到App目前的各种状态，以便让SDK做出对应当前场景的操作
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
#warning SDK方法调用
    // 让SDK得到App目前的各种状态，以便让SDK做出对应当前场景的操作
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    application.applicationIconBadgeNumber = 1;
    application.applicationIconBadgeNumber = 0;
    
#warning SDK方法调用
    // 让SDK得到App目前的各种状态，以便让SDK做出对应当前场景的操作
    [[EaseMob sharedInstance] applicationDidBecomeActive:application];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
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
    
    [self updateAPNSToken:deviceToken];
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


#pragma mark - Notification

- (void)loginstatusChanged:(NSNotification *)notification
{
    if ([LoginManager sharedInstance].loginStatus == LOGINSTATUS_ONLINE) {
        [self.window setRootViewController:[self createMainNavigationControllerNew]];
        [[ContactManager sharedInstance] initManager];
    } else if ([LoginManager sharedInstance].loginStatus == LOGINSTATUS_NONE) {
//        [self.window setRootViewController:[self createLoginNavigationController]];
        
        [self.window setRootViewController:[[LoginViewController alloc] init]];
        [[ContactManager sharedInstance] clearContacts];
    }
}


#pragma mark - Private Method

- (IntroductionViewController *)createIntroductionViewController
{
    IntroductionViewController *introductionViewController = [[IntroductionViewController alloc] init];
    introductionViewController.delegate = self;
    return introductionViewController;
}

- (UINavigationController *)createLoginNavigationController
{
    UIViewController *navRootViewController = [[LoginViewController alloc] init];
    UINavigationController *mainNavigationController = [[SkinManager sharedInstance] createDefaultNavigationControllerWithRootView:navRootViewController];
    [[SkinManager sharedInstance] modifyDefaultNavigationController:mainNavigationController];
    return mainNavigationController;
}

- (UINavigationController *)createMainNavigationController
{
    UIViewController *navRootViewController = [[MainViewController alloc] init];
    UINavigationController *mainNavigationController = [[SkinManager sharedInstance] createDefaultNavigationControllerWithRootView:navRootViewController];
    [[SkinManager sharedInstance] modifyDefaultNavigationController:mainNavigationController];
    return mainNavigationController;
}

- (UIViewController *)createMainNavigationControllerNew
{
    MainTabBarViewController *mainController = [[MainTabBarViewController alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mainController];
    
    return mainController;
}


#pragma mark - IntroductionViewControllerDelegate

- (void)introductionViewDidFinish:(IntroductionViewController *)viewController
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    UINavigationController *mainNavigationController = [self createLoginNavigationController];
    [UIView transitionFromView:self.window.rootViewController.view
                        toView:mainNavigationController.view
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCurlUp|UIViewAnimationOptionCurveEaseOut
                    completion:^(BOOL finished){
                        [self.window setRootViewController:mainNavigationController];
                    }];
    [[LocalCacheManager sharedInstance] setFirstLaunched];
}


#pragma mark - Register APNS

- (void)updateAPNSToken:(NSData *)deviceToken
{
    NSString *deviceTokenStr = [NSString stringWithFormat:@"%@", deviceToken];
    deviceTokenStr = [[deviceTokenStr substringWithRange:NSMakeRange(0, 72)] substringWithRange:NSMakeRange(1, 71)];
    deviceTokenStr = [deviceTokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    DLog(@"deviceToken = %@", deviceTokenStr);
}


#pragma mark - Private Method

+ (void)initiVersion
{
    [iVersion sharedInstance].remoteVersionsPlistURL = @"https://dn-ihys.qbox.me/iDoctor_versions.plist";
#ifdef kCompileForEnterprise
    [iVersion sharedInstance].updateURL = [NSURL URLWithString:@"itms-services://?action=download-manifest&url=https://dn-ihys.qbox.me/iDoctor.plist"];
#else
    [iVersion sharedInstance].appStoreID = 916087461;
    [iVersion sharedInstance].delegate = self;
#endif
    [iVersion sharedInstance].downloadButtonLabel = @"立即更新";
    [iVersion sharedInstance].ignoreButtonLabel = @"稍后更新";
    [iVersion sharedInstance].remindButtonLabel = @"不再提醒";
}

- (BOOL)iVersionShouldOpenAppStore
{
#ifdef kCompileForEnterprise
    return NO;
#else
    return YES;
#endif
}

@end
