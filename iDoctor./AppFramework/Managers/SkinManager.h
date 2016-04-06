//
//  SkinManager.h
//  AppFramework
//
//  Created by ABC on 6/3/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EXUITextField.h"

@interface SkinManager : NSObject

+ (SkinManager *)sharedInstance;

@property (nonatomic, strong) UIColor *defaultNavigationBarBackgroundColor;
@property (nonatomic, strong) UIColor *defaultNavigationBarButtonItemTintColor;
@property (nonatomic, strong) UIColor *defaultTabBarTintColor;
@property (nonatomic, strong) UIColor *defaultTabBarTitleTintColor;
@property (nonatomic, strong) UIColor *defaultViewBackgroundColor;
@property (nonatomic, strong) UIColor *defaultBlackColor;
@property (nonatomic, strong) UIColor *defaultWhiteColor;
@property (nonatomic, strong) UIColor *defaultBorderColor;
@property (nonatomic, strong) UIColor *defaultHighlightBackgroundColor;
@property (nonatomic, strong) UIColor *defaultLightGrayColor;
@property (nonatomic, strong) UIColor *defaultGrayColor;
@property (nonatomic, strong) UIColor *defaultClearColor;

@property (nonatomic, strong) UIImage *defaultNavigationBarBackIcon;
@property (nonatomic, strong) UIImage *defaultImg;
@property (nonatomic, strong) UIImage *defaultAddImageIconImage;
@property (nonatomic, strong) UIImage *defaultMainPageTabBarNormalIcon;
@property (nonatomic, strong) UIImage *defaultMainPageTabBarHighlightedIcon;
@property (nonatomic, strong) UIImage *defaultNativeQuestionTabBarNormalIcon;
@property (nonatomic, strong) UIImage *defaultNativeQuestionTabBarHighlightedIcon;
@property (nonatomic, strong) UIImage *defaultContactTabBarNormalIcon;
@property (nonatomic, strong) UIImage *defaultContactTabBarHighlightedIcon;
@property (nonatomic, strong) UIImage *defaultMessageTabBarNormalIcon;
@property (nonatomic, strong) UIImage *defaultMessageTabBarHighlightedIcon;
@property (nonatomic, strong) UIImage *defaultGiftTabBarNormalIcon;
@property (nonatomic, strong) UIImage *defaultGiftTabBarHighlightedIcon;
@property (nonatomic, strong) UIImage *defaultSettingTabBarNormalIcon;
@property (nonatomic, strong) UIImage *defaultSettingTabBarHighlightedIcon;
@property (nonatomic, strong) UIImage *defaultChatMoreButtonIcon;
@property (nonatomic, strong) UIImage *defaultChatKeyboardButtonIcon;
@property (nonatomic, strong) UIImage *defaultChatAudioButtonIcon;
@property (nonatomic, strong) UIImage *defaultChatTextButtonIcon;
@property (nonatomic, strong) UIImage *defaultNameCardIcon;
@property (nonatomic, strong) UIImage *defaultUserInfoIcon;
@property (nonatomic, strong) UIImage *defaultSettingIcon;
@property (nonatomic, strong) UIImage *defaultUpdatingIcon;
@property (nonatomic, strong) UIImage *defaultFeedbackIcon;
@property (nonatomic, strong) UIImage *defaultChatPhotoIcon;
@property (nonatomic, strong) UIImage *defaultChatShootIcon;
@property (nonatomic, strong) UIImage *defaultContactAvatarIcon;
@property (nonatomic, strong) UIImage *defaultDoctorInfoAvatar;
@property (nonatomic, strong) UIImage *defaultStarIcon;
@property (nonatomic, strong) UIImage *defaultBlockIcon;
@property (nonatomic, strong) UIImage *defaultNormalButtonBackground;
@property (nonatomic, strong) UIImage *defaultSelectedButtonBackground;
@property (nonatomic, strong) UIImage *defaultLineImage;

- (EXUITextField *)createDefaultTextField;
- (EXUITextField *)createDefaultEXUITextField;
- (UIButton *)createDefaultButton;
- (UIButton *)createDefaultV3GreenButton;
- (void)navigationRootViewControllerSizeToFit:(UIViewController *)viewController;
- (UINavigationController *)createDefaultNavigationControllerWithRootView:(UIViewController *)rootViewController;
- (void)modifyDefaultNavigationController:(UINavigationController *)navigationController;

@end
