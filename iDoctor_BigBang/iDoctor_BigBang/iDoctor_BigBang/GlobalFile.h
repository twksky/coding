//
//  GlobalFile.h
//  iDoctor_BigBang
//
//  Created by twksky on 15/9/7.
//  Copyright (c) 2015年 twksky. All rights reserved.
//

#ifndef iDoctor_BigBang_GlobalFile_h
#define iDoctor_BigBang_GlobalFile_h

#define kHostName @"http://m.ihaoyisheng.com/"

#define kUrl @"http://m.ihaoyisheng.com:80/"

#define kAppVerison @"4.0.0"
#define kPlatform @"IOS"

#pragma mark - debug Token
#define kToken @"Panmax"


#pragma mark - 沙盒路径
#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

#pragma mark - 自定义调试log
#ifdef DEBUG

#pragma mark - Debug Log
#define GDLog(...) NSLog(@"%s Line %d: \n %@ \n\n", __func__, __LINE__, [NSString stringWithFormat:__VA_ARGS__])
#else
#define GDLog(...)
#endif

#pragma mark - 定义沙盒Documents目录下文件的路径
#define GDDocumentsDir(filename) [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:(filename)]

#pragma mark - Library/Caches目录
#define GDCachesDir(filename) [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:filename]

#pragma mark - 下载课件的目录
#define GDCoursesDir(md5url) [GDCachesDir(@"courses") stringByAppendingPathComponent:md5url]

#pragma mark - 定义UserDefaultsd对象
#define GDUserDefaults [NSUserDefaults standardUserDefaults]

#pragma mark - RGB颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0f \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0f blue:((float)(rgbValue & 0xFF))/255.0f \
alpha:1.0f]

#pragma mark - App Frame Height&Width
#define App_Frame_X             [[UIScreen mainScreen] applicationFrame].origin.x
#define App_Frame_Y             [[UIScreen mainScreen] applicationFrame].origin.y
#define App_Frame_Height        [[UIScreen mainScreen] applicationFrame].size.height
#define App_Frame_Width         [[UIScreen mainScreen] applicationFrame].size.width

#pragma mark - MainScreen Height&Width
#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width

#pragma mark - System Version
#define IOS_VERSION ([[[UIDevice currentDevice] systemVersion] floatValue])
#define IS_IOS5     ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0f && [[[UIDevice currentDevice] systemVersion] floatValue] < 6.0f)
#define IS_IOS6     ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0f && [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0f)
#define IS_IOS7     ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f && [[[UIDevice currentDevice] systemVersion] floatValue] < 8.0f)
#define IS_IOS8     ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f && [[[UIDevice currentDevice] systemVersion] floatValue] < 9.0f)
#define IS_IOS9     ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0f && [[[UIDevice currentDevice] systemVersion] floatValue] < 10.0f)

#pragma mark - System Versioning Preprocessor Macros
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#pragma mark - View 圆角和加边框
#define ViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

#pragma mark - View 圆角
#define ViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

#pragma mark - View 坐标(x,y)和宽高(width,height)
#define WIDTH(view) view.frame.size.width
#define HEIGHT(view) view.frame.size.height
#define X(view) view.frame.origin.x
#define Y(view) view.frame.origin.y

#pragma mark - 输入过滤相关
#define kAlphaNum           @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#define kAlpha              @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
#define kNumbers            @"0123456789"
#define kNumbersPeriod      @"0123456789."

#pragma mark - IphoneModel
#define IS_IPHONE4  ([UIScreen mainScreen].bounds.size.height == 480)
#define IS_IPHONE5  ([UIScreen mainScreen].bounds.size.height == 568)
#define IS_IPHONE6andLater  ([UIScreen mainScreen].bounds


// RGB颜色
#define GDColorRGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// RGBA颜色
#define GDColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

// 随机色
#define GDRandomColor GDColorRGB(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

// 通知中心
#define GDNotificationCenter [NSNotificationCenter defaultCenter]

// 数字的特殊字体
#define GDFont(sizea) [UIFont fontWithName:@"Avenir-Book" size:(sizea)]

#define GDNotificationCenter [NSNotificationCenter defaultCenter]
#define GDAppTopView [UIApplication sharedApplication].delegate.window.rootViewController.view

// 导航栏颜色
#define kNavBarColor UIColorFromRGB(0x36cacc)
// 导航题字体大小
#define kTitleSize GDFont(17)

#define kDefaultFontColor UIColorFromRGB(0x353d3f)

// 用户模型
#define kAccount [AccountManager sharedInstance].account

// 增加 / 移除一个用户
#define KaddOrRemoveAPatient  @"addOrRemoveAPatientNotification"


#endif

