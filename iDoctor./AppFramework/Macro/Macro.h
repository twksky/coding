//
//  Macro.h
//  AppFramework
//
//  Created by ABC on 6/3/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#ifndef AppFramework_Macro_h
#define AppFramework_Macro_h

// Debug Log
#ifdef DEBUG
#define DLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DLog( s, ... )
#endif

// RGB颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0f \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0f blue:((float)(rgbValue & 0xFF))/255.0f \
alpha:1.0f]

#define UIColorFromRGBA(rgbaValue) [UIColor colorWithRed:((float)((rgbaValue & 0xFF000000) >> 24)) / 255.0f \
green:((float)((rgbaValue & 0xFF0000) >> 16)) / 255.0f \
blue:((float)((rgbaValue & 0xFF00) >> 8)) / 255.0f \
alpha:((float)((rgbaValue & 0xFF))) / 255.0f]

#pragma mark - Frame

#define kStatusBarHeight        (20.0f)
#define kTabBarHeight           (49.0f)
#define kPickerViewMinHeight    (162.0f)
#define kPickerViewMaxHeight    (217.0f)
#define kCellDefaultHeight      (44.0f)

// App Frame
#define Application_Frame       [[UIScreen mainScreen] applicationFrame]

// App Frame Height&Width
#define App_Frame_X             [[UIScreen mainScreen] applicationFrame].origin.x
#define App_Frame_Y             [[UIScreen mainScreen] applicationFrame].origin.y
#define App_Frame_Height        [[UIScreen mainScreen] applicationFrame].size.height
#define App_Frame_Width         [[UIScreen mainScreen] applicationFrame].size.width

// MainScreen Height&Width
#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width


#pragma mark - System Version

#define IOS_VERSION ([[[UIDevice currentDevice] systemVersion] floatValue])
#define IS_IOS5     ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0f && [[[UIDevice currentDevice] systemVersion] floatValue] < 6.0f)
#define IS_IOS6     ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0f && [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0f)
#define IS_IOS7     ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f && [[[UIDevice currentDevice] systemVersion] floatValue] < 8.0f)
#define IS_IOS8     ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f && [[[UIDevice currentDevice] systemVersion] floatValue] < 9.0f)

// System Versioning Preprocessor Macros
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

// Device
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#endif
