//
//  BaseViewController.m
//  iDoctor_BigBang
//
//  Created by twksky on 15/9/7.
//  Copyright (c) 2015年 twksky. All rights reserved.
//

#import "BaseViewController.h"
#import "MBProgressHUD+Extension.h"
@interface BaseViewController ()
@property (nonatomic, strong) IQKeyboardReturnKeyHandler    *returnKeyHandler;
@end

@implementation BaseViewController

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
//        self.hidesBottomBarWhenPushed = YES;
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:17.0]};
        self.navigationController.navigationBar.translucent = NO;
        
        // 忽略导航栏所在的区域
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    }
    
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = kNavBarColor;
    
    NSMutableDictionary *attrsDict = [NSMutableDictionary dictionary];

    attrsDict[NSFontAttributeName] = kTitleSize;

    attrsDict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:attrsDict];
    
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0x36cacc);
    
    [self initBackBarItemBtn];
    
    self.returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    self.returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
}

#pragma mark -
- (void)initBackBarItemBtn {
    
    if (self.navigationController.childViewControllers.count > 1) {
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        backButton.frame = CGRectMake(0.0f, 0.0f, 45.0f, 44.0f);
        [backButton setImage:[UIImage imageNamed:@"backBtnImg"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"backBtnImg"] forState:UIControlStateHighlighted];
        backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
        [backButton addTarget:self action:@selector(popSelf) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        
        self.navigationItem.leftBarButtonItem = backBarButtonItem;
    }
}

- (void)popSelf {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showWarningAlertWithTitle:(NSString *)title withMessage:(NSString *)message {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)showLoading {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)dismissLoading {
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)hideLoading {
    
    [MBProgressHUD hideHUDForView:self.view];
}

- (void)handleError:(NSError *)error {
    
    [MBProgressHUD showError:[error localizedDescription] toView:self.view];
}

- (void)showTips:(NSString *)tip {
    
    [MBProgressHUD showSuccess:tip toView:self.view];
}
- (void)hidNavBarBottomLine
{
    UIImageView *iv = [self findHairlineFromView:self.navigationController.navigationBar];
    iv.hidden = YES;
}
- (UIImageView *)findHairlineFromView:(UIView *)view
{
    if ([view isKindOfClass:[UIImageView class]] && view.frame.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    
    for (UIView *subView in view.subviews) {
        UIImageView *imageView = [self findHairlineFromView:subView];
        if (imageView) {
            return imageView;
        }
    }
    
    return nil;
}

- (void)showMessage:(NSString *)message
{
    [MBProgressHUD showMessage:message toView:self.view isDimBackground:NO];
}
- (void)hidMessage
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)dealloc
{
    self.returnKeyHandler = nil;
}


- (UIView *)tipViewWithName:(NSString *)name
{
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    
    // 没有消息的图片
    UIImageView *iconImage = [[UIImageView alloc] init];
    iconImage.image = [UIImage imageNamed:@"noMessage"];
    [bgView addSubview:iconImage];
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.center.equalTo(CGPointMake(0, -100));
    }];
    
    // 文字
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:18.0f];
    label.textColor = UIColorFromRGB(0xa8a8aa);
    label.text = name;
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    [bgView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(bgView).offset(0);
        make.width.equalTo(App_Frame_Width);
        make.top.equalTo(iconImage.bottom).offset(7);
        
    }];
    return bgView;
}




@end
