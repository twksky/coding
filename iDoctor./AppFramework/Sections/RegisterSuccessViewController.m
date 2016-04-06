//
//  RegisterSuccessViewController.m
//  AppFramework
//
//  Created by 周世阳 on 15/6/12.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "RegisterSuccessViewController.h"
#import "SkinManager.h"
#import <PureLayout.h>
#import "Account.h"
#import "RegisterViewControllerStep3.h"
#import <EaseMob.h>
#import "LoginManager.h"
#import <MBProgressHUD.h>

@interface RegisterSuccessViewController ()

@property (nonatomic, strong) UILabel *successLabel;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UILabel *subTipLabel;

@property (nonatomic, strong) UIButton *finishBtn;
@property (nonatomic, strong) UIButton *registerMoreButton;

@property (nonatomic, strong) Account *accountCache;

@end

@implementation RegisterSuccessViewController

- (instancetype)initWithAccountCache:(Account *)accountCache {
    
    self = [super init];
    if (self) {
        
        self.accountCache = accountCache;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xeef1f2);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [self.view addSubview:self.successLabel];
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.subTipLabel];
    [self.view addSubview:self.finishBtn];
    [self.view addSubview:self.registerMoreButton];
    
    UIView *clearLine = [[UIView alloc] init];
    clearLine.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:clearLine];
    
    [self.view addConstraints:[clearLine autoSetDimensionsToSize:CGSizeMake(App_Frame_Width, 0.1f)]];
    [self.view addConstraint:[clearLine autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
    
    [self.view addConstraint:[self.finishBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:clearLine withOffset:20.0f]];
    [self.view addConstraints:[self.finishBtn autoSetDimensionsToSize:CGSizeMake(App_Frame_Width * 0.6f, 50.0f)]];
    [self.view addConstraint:[self.finishBtn autoAlignAxisToSuperviewAxis:ALAxisVertical]];
    
    [self.view addConstraint:[self.registerMoreButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.finishBtn withOffset:20.0f]];
    [self.view addConstraints:[self.registerMoreButton autoSetDimensionsToSize:CGSizeMake(App_Frame_Width * 0.6f, 50.0f)]];
    [self.view addConstraint:[self.registerMoreButton autoAlignAxisToSuperviewAxis:ALAxisVertical]];
    
    [self.view addConstraint:[self.subTipLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:clearLine withOffset: -40.0f]];
    [self.view addConstraint:[self.subTipLabel autoAlignAxisToSuperviewAxis:ALAxisVertical]];
    [self.view addConstraint:[self.subTipLabel autoSetDimension:ALDimensionWidth toSize:App_Frame_Width - 20.0f]];
    
    [self.view addConstraint:[self.tipLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.subTipLabel withOffset:- 15.0f]];
    [self.view addConstraint:[self.tipLabel autoAlignAxisToSuperviewAxis:ALAxisVertical]];
    [self.view addConstraint:[self.tipLabel autoSetDimension:ALDimensionWidth toSize:App_Frame_Width - 20.0f]];
    
    [self.view addConstraint:[self.successLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.tipLabel withOffset: -20.0f]];
    [self.view addConstraint:[self.successLabel autoAlignAxisToSuperviewAxis:ALAxisVertical]];
    [self.view addConstraint:[self.successLabel autoSetDimension:ALDimensionWidth toSize:App_Frame_Width - 20.0f]];
}


#pragma mark - selectors

- (void)toRegisterViewControllerStep3:(id)sender {
    
    RegisterViewControllerStep3 *registerViewControllerStep3 = [[RegisterViewControllerStep3 alloc] initWithAccount:self.accountCache];
    [self.navigationController pushViewController:registerViewControllerStep3 animated:YES];
}

- (void)toMainPage:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *easemobLoginName = [NSString stringWithFormat:@"%ld", self.accountCache.accountID];
    NSString *easemobPassword = [self.accountCache.easemobPassword uppercaseString];
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:easemobLoginName password:easemobPassword completion:^(NSDictionary *loginInfo, EMError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (loginInfo && !error) {
            DLog(@"%@ %@ 成功登录环信服务器!", easemobLoginName, easemobPassword);
            //[[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
            [LoginManager sharedInstance].loginStatus = LOGINSTATUS_ONLINE;
        }else {
            NSString *errorText = @"";
            switch (error.errorCode) {
                case EMErrorServerNotReachable:
                    errorText = @"连接服务器失败!";
                    break;
                case EMErrorServerAuthenticationFailure:
                    errorText = @"用户名或密码错误";
                    break;
                case EMErrorServerTimeout:
                    errorText = @"连接服务器超时!";
                    break;
                default:
                    errorText = @"登录失败";
                    break;
            }
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:errorText delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }
    } onQueue:nil];
}


#pragma mark - properties

- (UILabel *)successLabel {
    
    if (!_successLabel) {
        
        _successLabel = [[UILabel alloc] init];
        _successLabel.textAlignment = NSTextAlignmentCenter;
        _successLabel.font = [UIFont boldSystemFontOfSize:39.0f];
        _successLabel.textColor = UIColorFromRGB(0x8e8e91);
        _successLabel.text = @"注册成功";
    }
    
    return _successLabel;
}

- (UILabel *)tipLabel {
    
    if (!_tipLabel) {
        
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.font = [UIFont systemFontOfSize:22.0f];
        _tipLabel.textColor = UIColorFromRGB(0x8e8e91);
        _tipLabel.text = @"完善资料获得更多积分";
    }
    
    return _tipLabel;
}

- (UILabel *)subTipLabel {
    
    if (!_subTipLabel) {
        
        _subTipLabel = [[UILabel alloc] init];
        _subTipLabel.textAlignment = NSTextAlignmentCenter;
        _subTipLabel.font = [UIFont systemFontOfSize:22.0f];
        _subTipLabel.textColor = UIColorFromRGB(0x8e8e91);
        _subTipLabel.text = @"成为星级医生享有更多特权";
    }
    
    return _subTipLabel;
}

- (UIButton *)finishBtn {
    
    if (!_finishBtn) {
        
        _finishBtn = [[SkinManager sharedInstance] createDefaultV3GreenButton];
        [_finishBtn addTarget:self action:@selector(toMainPage:) forControlEvents:UIControlEventTouchUpInside];
        [_finishBtn setTitle:@"直接登录" forState:UIControlStateNormal];
    }
    
    return _finishBtn;
}

- (UIButton *)registerMoreButton {
    
    if (!_registerMoreButton) {
        
        _registerMoreButton = [[SkinManager sharedInstance] createDefaultV3GreenButton];
        [_registerMoreButton addTarget:self action:@selector(toRegisterViewControllerStep3:) forControlEvents:UIControlEventTouchUpInside];
        [_registerMoreButton setTitle:@"完善资料" forState:UIControlStateNormal];
    }
    
    return _registerMoreButton;
}

@end
