//
//  SkinManager.m
//  AppFramework
//
//  Created by ABC on 6/3/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "SkinManager.h"
#import "UIViewController+Util.h"
#import "ImageUtils.h"

@implementation SkinManager

+ (SkinManager *)sharedInstance
{
    static SkinManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SkinManager alloc] init];
    });
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
//        _defaultNavigationBarBackgroundColor    = UIColorFromRGB(0x63c5c6);
//        _defaultNavigationBarBackgroundColor    = UIColorFromRGB(0x4b5e76);
        _defaultNavigationBarBackgroundColor    = UIColorFromRGB(0x34d2b4);
        _defaultNavigationBarButtonItemTintColor= [UIColor whiteColor];
        _defaultTabBarTintColor                 = UIColorFromRGB(0xEDF2F1);
        _defaultTabBarTitleTintColor            = UIColorFromRGB(0x40B49C);
        _defaultViewBackgroundColor             = UIColorFromRGB(0xefeef3);
        _defaultBlackColor                      = UIColorFromRGBA(0x000000ff);
        _defaultWhiteColor                      = UIColorFromRGB(0xffffff);
        _defaultBorderColor                     = UIColorFromRGB(0xd4d5d7);
        _defaultHighlightBackgroundColor        = UIColorFromRGB(0xfc5d3a);
        _defaultLightGrayColor                  = UIColorFromRGB(0xdadada);
        _defaultGrayColor                       = UIColorFromRGB(0x808080);
        _defaultClearColor                      = [UIColor clearColor];
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
            _defaultNavigationBarBackIcon           = [[UIImage imageNamed:@"icon_back_.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            _defaultImg           = [[UIImage imageNamed:@"img_default_pic.jpg"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            _defaultAddImageIconImage               = [[UIImage imageNamed:@"icon_addImage.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
            _defaultMainPageTabBarNormalIcon        = [[UIImage imageNamed:@"icon_mainpage_normal"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
            _defaultMainPageTabBarHighlightedIcon   = [[UIImage imageNamed:@"icon_mainpage_highlighted"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
            _defaultNativeQuestionTabBarNormalIcon  = [[UIImage imageNamed:@"icon_nativequestion_normal"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
            _defaultNativeQuestionTabBarHighlightedIcon  = [[UIImage imageNamed:@"icon_nativequestion_highlighted"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
            _defaultContactTabBarNormalIcon         = [[UIImage imageNamed:@"icon_contact2_normal.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
            _defaultContactTabBarHighlightedIcon    = [[UIImage imageNamed:@"icon_contact2_highlighted.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
            _defaultMessageTabBarNormalIcon         = [[UIImage imageNamed:@"icon_message2_normal.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
            _defaultMessageTabBarHighlightedIcon    = [[UIImage imageNamed:@"icon_message2_highlighted.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
            _defaultGiftTabBarNormalIcon            = [[UIImage imageNamed:@"icon_gift_normal.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
            _defaultGiftTabBarHighlightedIcon       = [[UIImage imageNamed:@"icon_gift_highlighted.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
            _defaultSettingTabBarNormalIcon         = [[UIImage imageNamed:@"icon_userinfo_normal.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
            _defaultSettingTabBarHighlightedIcon    = [[UIImage imageNamed:@"icon_userinfo_highlighted.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
            _defaultChatMoreButtonIcon              = [[UIImage imageNamed:@"icon_more.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
            _defaultChatKeyboardButtonIcon          = [[UIImage imageNamed:@"icon_keyboard.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
            _defaultChatAudioButtonIcon             = [[UIImage imageNamed:@"icon_audio.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
            _defaultChatTextButtonIcon              = [[UIImage imageNamed:@"icon_text.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
            _defaultNameCardIcon                    = [[UIImage imageNamed:@"icon_namecard.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
            _defaultUserInfoIcon                    = [[UIImage imageNamed:@"icon_userInfo.jpg"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
            _defaultSettingIcon                     = [[UIImage imageNamed:@"icon_setting.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
            _defaultUpdatingIcon                    = [[UIImage imageNamed:@"icon_updating.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
            _defaultFeedbackIcon                    = [[UIImage imageNamed:@"icon_feedback.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
            _defaultChatPhotoIcon                   = [[UIImage imageNamed:@"icon_photo.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
            _defaultChatShootIcon                   = [[UIImage imageNamed:@"icon_shoot.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
            _defaultContactAvatarIcon               = [[UIImage imageNamed:@"icon_chat_default_avatar.jpg"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
            _defaultDoctorInfoAvatar               = [[UIImage imageNamed:@"img_default_doctor_avatar.jpg"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
            _defaultStarIcon                        = [[UIImage imageNamed:@"icon_star.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
            _defaultBlockIcon                       = [[UIImage imageNamed:@"icon_block.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
        } else {
            _defaultNavigationBarBackIcon           = [UIImage imageNamed:@"icon_back.png"];
            _defaultAddImageIconImage               = [UIImage imageNamed:@"icon_addImage.png"];
            _defaultMainPageTabBarNormalIcon        = [UIImage imageNamed:@"icon_mainpage_normal"];
            _defaultMainPageTabBarHighlightedIcon   = [UIImage imageNamed:@"icon_mainpage_highlighted"];
            _defaultNativeQuestionTabBarNormalIcon  = [UIImage imageNamed:@"icon_nativequestion_normal"];
            _defaultNativeQuestionTabBarHighlightedIcon  = [UIImage imageNamed:@"icon_nativequestion_highlighted"];
            _defaultContactTabBarNormalIcon         = [UIImage imageNamed:@"icon_contact2_normal.png"];
            _defaultContactTabBarHighlightedIcon    = [UIImage imageNamed:@"icon_contact2_highlighted.png"];
            _defaultMessageTabBarNormalIcon         = [UIImage imageNamed:@"icon_message2_normal.png"];
            _defaultMessageTabBarHighlightedIcon    = [UIImage imageNamed:@"icon_message2_highlighted.png"];
            _defaultGiftTabBarNormalIcon            = [UIImage imageNamed:@"icon_gift_normal.png"];
            _defaultGiftTabBarHighlightedIcon       = [UIImage imageNamed:@"icon_gift_highlighted.png"];
            _defaultSettingTabBarNormalIcon         = [UIImage imageNamed:@"icon_userinfo_normal.png"];
            _defaultSettingTabBarHighlightedIcon    = [UIImage imageNamed:@"icon_userinfo_highlighted.png"];
            _defaultChatMoreButtonIcon              = [UIImage imageNamed:@"icon_more.png"];
            _defaultChatKeyboardButtonIcon          = [UIImage imageNamed:@"icon_keyboard.png"];
            _defaultChatAudioButtonIcon             = [UIImage imageNamed:@"icon_audio.png"];
            _defaultChatTextButtonIcon              = [UIImage imageNamed:@"icon_text.png"];
            _defaultNameCardIcon                    = [UIImage imageNamed:@"icon_namecard.png"];
            _defaultUserInfoIcon                    = [UIImage imageNamed:@"icon_userInfo.jpg"];
            _defaultSettingIcon                     = [UIImage imageNamed:@"icon_setting.png"];
            _defaultUpdatingIcon                    = [UIImage imageNamed:@"icon_updating.png"];
            _defaultFeedbackIcon                    = [UIImage imageNamed:@"icon_feedback.png"];
            _defaultChatPhotoIcon                   = [UIImage imageNamed:@"icon_photo.png"];
            _defaultChatShootIcon                   = [UIImage imageNamed:@"icon_shoot.png"];
            _defaultContactAvatarIcon               = [UIImage imageNamed:@"icon_chat_default_avatar.jpg"];
            _defaultStarIcon                        = [UIImage imageNamed:@"icon_star.png"];
            _defaultBlockIcon                       = [UIImage imageNamed:@"icon_block.png"];
        }
        
        _defaultNormalButtonBackground = [[UIImage imageNamed:@"img_button_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(18.0f, 18.0f, 2.0f, 2.0f) resizingMode:UIImageResizingModeStretch];
        _defaultSelectedButtonBackground = [[UIImage imageNamed:@"img_button_selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(18.0f, 18.0f, 2.0f, 2.0f) resizingMode:UIImageResizingModeStretch];
        
        _defaultLineImage = [ImageUtils createImageWithColor:UIColorFromRGB(0xd4d4d4)];
    }
    return self;
}

- (EXUITextField *)createDefaultTextField
{
    EXUITextField *textField = [[EXUITextField alloc] init];
    textField.backgroundColor = self.defaultWhiteColor;
    textField.textEdgeInsets = UIEdgeInsetsMake(0.0f, 14.0f, 0.0f, 14.0f);
    textField.layer.cornerRadius = 3.0f;
    textField.layer.borderColor = [self.defaultBorderColor CGColor];
    textField.layer.borderWidth = 0.5f;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    return textField;
}

- (EXUITextField *)createDefaultEXUITextField {
    
    EXUITextField *textField = [[EXUITextField alloc] init];
    textField.backgroundColor = [UIColor whiteColor];
    textField.textEdgeInsets = UIEdgeInsetsMake(0.0f, 14.0f, 0.0f, 14.0f);
    textField.layer.borderColor = [UIColorFromRGB(0xd4d4d4) CGColor];
    textField.layer.borderWidth = 0.7f;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    return textField;
}

- (UIButton *)createDefaultButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = self.defaultWhiteColor;
    [button setTitleColor:UIColorFromRGB(0x030303) forState:UIControlStateNormal];
    button.layer.cornerRadius = 3.0f;
    [button setContentEdgeInsets:UIEdgeInsetsMake(0.0f, 14.0f, 0.0f, 14.0f)];
    return button;
}

- (UIButton *)createDefaultV3GreenButton {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = UIColorFromRGB(0x34d2b4);
    button.titleLabel.font = [UIFont boldSystemFontOfSize:19.0f];
    button.layer.cornerRadius = 6.0f;
    
    return button;
}

- (void)navigationRootViewControllerSizeToFit:(UIViewController *)viewController;
{
    if (IOS_VERSION >= 7.0f) {
        [viewController.view setFrame:CGRectMake(0.0f, App_Frame_Y + viewController.navigationBarHeight, App_Frame_Width, App_Frame_Height - viewController.navigationBarHeight)];
    }
}

- (UINavigationController *)createDefaultNavigationControllerWithRootView:(UIViewController *)rootViewController
{
    if (IOS_VERSION >= 7.0f) {
        [[UINavigationBar appearance] setBackIndicatorImage:self.defaultNavigationBarBackIcon];
        [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:self.defaultNavigationBarBackIcon];
    }
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    navigationController.navigationBar.backgroundColor = [SkinManager sharedInstance].defaultNavigationBarBackgroundColor;
    if (IOS_VERSION >= 7.0f) {
        navigationController.navigationBar.barTintColor = [SkinManager sharedInstance].defaultNavigationBarBackgroundColor;
    }
    
    [navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : self.defaultWhiteColor}];
    //set back button color
    NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentNatural;
    style.lineSpacing = -10.0f;
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    return navigationController;
}

- (void)modifyDefaultNavigationController:(UINavigationController *)navigationController
{
    if (IOS_VERSION >= 7.0f) {
        navigationController.navigationBar.barTintColor = [SkinManager sharedInstance].defaultNavigationBarBackgroundColor;
    }
}

@end
