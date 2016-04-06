//
//  LoginViewController.m
//  AppFramework
//
//  Created by ABC on 6/2/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewControllerStep1.h"
#import "SkinManager.h"
#import <PureLayout.h>
#import "UIViewController+Util.h"
//#import "IChatManager.h"
#import "LoginManager.h"
#import "AccountManager.h"
#import "MBProgressHUD.h"
#import "Account.h"
#import "BeforeRetrievePasswordViewController.h"
#import "UserAgreementViewController.h"
#import "LocalCacheManager.h"
#import "MF_Base64Additions.h"
#import "SupplementViewController.h"

@interface LoginViewController () <MBProgressHUDDelegate, SupplementViewControllerDelegate>

@property (nonatomic, strong) UIScrollView                  *contentScrollView;
@property (nonatomic, strong) UIImageView                   *logoImageView;
@property (nonatomic, strong) UIButton                      *forgotPasswordButton;
@property (nonatomic, strong) UIView                        *inputView;
@property (nonatomic, strong) UIImageView                       *userIconImageView;
@property (nonatomic, strong) UITextField                       *userNameTextField;
@property (nonatomic, strong) UIView                            *horizontalLine;
@property (nonatomic, strong) UIImageView                       *passwordIconImageView;
@property (nonatomic, strong) UITextField                       *passwordTextField;
@property (nonatomic, strong) UIButton                      *registerButton;
@property (nonatomic, strong) UIButton                      *loginButton;
@property (nonatomic, strong) UILabel                       *infoLabel;
@property (nonatomic, strong) UIButton                      *userAgreementCheckButton;
@property (nonatomic, strong) UIButton                      *userAgreementInfoButton;
@property (nonatomic, strong) MBProgressHUD                 *progressHUD;

- (void)registerButtonClicked:(UIButton *)button;
- (void)loginButtonClicked:(UIButton *)button;
- (void)retrievePasswordClicked:(UIButton *)button;
- (void)viewTapGestureFired:(UITapGestureRecognizer *)tapGestureRecognizer;
- (void)userAgreementCheckButtonClicked:(UIButton *)button;
- (void)userAgreementButtonClicked:(id)sender;

- (void)setupSubviews;
- (void)setupConstraints;

@end
CGFloat iPhone4;
@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    iPhone4 = [UIScreen mainScreen].bounds.size.height;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"img_login_bg"]];
    
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }
    
    [self setupSubviews];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapGestureFired:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    NSString *userName = [self.userNameTextField text];
    NSString *password = [self.passwordTextField text];
    
    if (nil != userName && [userName length] != 0 && nil != password && [password length] != 0) {
        
        [self login];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
//    [[SkinManager sharedInstance] navigationRootViewControllerSizeToFit:self];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //[self.view endEditing:YES];
}


#pragma mark - Property

- (UIScrollView *)contentScrollView
{
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] init];
    }
    return _contentScrollView;
}

- (UIImageView *)logoImageView
{
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_login_logo.png"]];
    }
    return _logoImageView;
}

- (UIButton *)forgotPasswordButton
{
    if (!_forgotPasswordButton) {
        _forgotPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        NSDictionary *textAttributesDic = [NSDictionary dictionaryWithObjectsAndKeys:
//                                           [UIFont systemFontOfSize:17.0f], NSFontAttributeName,
//                                           UIColorFromRGB(0x485e77), NSForegroundColorAttributeName,
//                                           [NSNumber numberWithInteger:1], NSUnderlineStyleAttributeName, nil];
        
        //很挫的做法  后期会加入对各类机型的判断
        UIFont *font = nil;
        if ([[UIScreen mainScreen] bounds].size.width > 400) {
            
            font = [UIFont systemFontOfSize:17.0f];
        }
        else {
            
            font = [UIFont systemFontOfSize:15.0f];
        }
        
        NSDictionary *textAttributesDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                           font, NSFontAttributeName,
                                           UIColorFromRGB(0x485e77), NSForegroundColorAttributeName, nil];

        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:@"找回密码" attributes:textAttributesDic];
        [_forgotPasswordButton setAttributedTitle:attributedText forState:UIControlStateNormal];
        [_forgotPasswordButton addTarget:self action:@selector(retrievePasswordClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgotPasswordButton;
}

- (UIView *)inputView
{
    if (!_inputView) {
        _inputView = [[UIView alloc] init];
        _inputView.backgroundColor = [SkinManager sharedInstance].defaultWhiteColor;
        _inputView.layer.cornerRadius = 6.0f;
        _inputView.layer.borderColor = [UIColorFromRGB(0x33d2b4) CGColor];
        _inputView.layer.borderWidth = 0.5f;
        
        [_inputView addSubview:self.userIconImageView];
        [_inputView addSubview:self.userNameTextField];
        [_inputView addSubview:self.horizontalLine];
        [_inputView addSubview:self.passwordIconImageView];
        [_inputView addSubview:self.passwordTextField];
    }
    return _inputView;
}

- (UIImageView *)userIconImageView
{
    if (!_userIconImageView) {
        _userIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_login_username"]];
    }
    return _userIconImageView;
}

- (UITextField *)userNameTextField
{
    if (!_userNameTextField) {
        _userNameTextField = [[UITextField alloc] init];
        [_userNameTextField setPlaceholder:@"手机号"];
        _userNameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;

        NSString *loginName = [[LocalCacheManager sharedInstance] getAccountLoginName];
        if (loginName) {
            [_userNameTextField setText:loginName];
        }
    }
    return _userNameTextField;
}

- (UIView *)horizontalLine
{
    if (!_horizontalLine) {
        _horizontalLine = [[UIView alloc] init];
//        _horizontalLine.backgroundColor = UIColorFromRGB(0xd4d5d7);
        _horizontalLine.backgroundColor = UIColorFromRGB(0x33d2b4);
    }
    return _horizontalLine;
}

- (UIImageView *)passwordIconImageView
{
    if (!_passwordIconImageView) {
        _passwordIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_login_pwd"]];
    }
    return _passwordIconImageView;
}

- (UITextField *)passwordTextField
{
    if (!_passwordTextField) {
        _passwordTextField = [[UITextField alloc] init];
        _passwordTextField.secureTextEntry = YES;
        [_passwordTextField setPlaceholder:@"输入密码"];
        _passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;

        NSString *loginPassword = [[LocalCacheManager sharedInstance] getAccountLoginPassword];
        if (loginPassword) {
            loginPassword = [NSString stringFromBase64String:loginPassword];
            [_passwordTextField setText:loginPassword];
        }
    }
    return _passwordTextField;
}

- (UIButton *)registerButton
{
    if (!_registerButton) {
        _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _registerButton.backgroundColor = UIColorFromRGB(0x9d9d9d);
        _registerButton.backgroundColor = UIColorFromRGB(0xecfafb);
        _registerButton.layer.borderColor = [UIColorFromRGB(0x33d2b4) CGColor];
        _registerButton.layer.borderWidth = 2.0f;
        _registerButton.layer.cornerRadius = 6.0f;
        [_registerButton setTitleColor:UIColorFromRGB(0x33d2b4) forState:UIControlStateNormal];
        [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
        [_registerButton addTarget:self action:@selector(registerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerButton;
}

- (UIButton *)loginButton
{
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.backgroundColor = UIColorFromRGB(0x33d2b4);
        _loginButton.layer.cornerRadius = 6.0f;
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

- (UILabel *)infoLabel
{
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
        
        //很搓的做法 后期会加入对各类机型的判断
        if ([[UIScreen mainScreen] bounds].size.width > 400) {
            
            _infoLabel.font = [UIFont systemFontOfSize:13.0f];
        }
        else {
            
            _infoLabel.font = [UIFont systemFontOfSize:11.0f];
        }
        
        _infoLabel.textColor = UIColorFromRGB(0x768ea7);
        [_infoLabel setText:@"如果您是好医生网站会员,请用其用户名登录"];
    }
    return _infoLabel;
}

- (UIButton *)userAgreementCheckButton
{
    if (!_userAgreementCheckButton) {
        _userAgreementCheckButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_userAgreementCheckButton setTitle:@"已阅读并同意" forState:UIControlStateNormal];
        _userAgreementCheckButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_userAgreementCheckButton setTitleColor:UIColorFromRGB(0x4a5f75) forState:UIControlStateNormal];
        [_userAgreementCheckButton setImage:[UIImage imageNamed:@"icon_pay_unchecked.png"] forState:UIControlStateNormal];
        [_userAgreementCheckButton setImage:[UIImage imageNamed:@"icon_card_default_selected"] forState:UIControlStateSelected];
        [_userAgreementCheckButton addTarget:self action:@selector(userAgreementCheckButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_userAgreementCheckButton setSelected:YES];
    }
    return _userAgreementCheckButton;
}

- (UIButton *)userAgreementInfoButton
{
    if (!_userAgreementInfoButton) {
        _userAgreementInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        NSDictionary *textAttributesDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                           [UIFont systemFontOfSize:14.0f], NSFontAttributeName,
                                           UIColorFromRGB(0x40b490), NSForegroundColorAttributeName,
                                           [NSNumber numberWithInteger:1], NSUnderlineStyleAttributeName, nil];
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:@"好医生用户隐私与用户协议" attributes:textAttributesDic];
        [_userAgreementInfoButton setAttributedTitle:attributedText forState:UIControlStateNormal];
        [_userAgreementInfoButton addTarget:self action:@selector(userAgreementButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _userAgreementInfoButton;
}

- (MBProgressHUD *)progressHUD
{
    if (!_progressHUD) {
        _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_progressHUD];
        [self.view bringSubviewToFront:_progressHUD];
        _progressHUD.delegate = self;
        _progressHUD.labelText = @"请稍候...";
    }
    return _progressHUD;
}


#pragma mark - Selector

- (void)registerButtonClicked:(UIButton *)button
{
    if (!self.userAgreementCheckButton.isSelected) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您必须同意协议条款才能登录" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }
    
    RegisterViewControllerStep1 *registerViewControllerStep1 = [[RegisterViewControllerStep1 alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:registerViewControllerStep1];
    [self presentViewController:nav animated:YES completion:nil];
//    [self.navigationController pushViewController:nav animated:YES];
}

- (void)loginButtonClicked:(UIButton *)button
{
    [self login];
}

- (void)login {
    
    if (!self.userAgreementCheckButton.isSelected) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您必须同意协议条款才能登录" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
        
    }
    
    
    NSString *userName = [self.userNameTextField text];
    NSString *password = [self.passwordTextField text];
    
    if ([userName length] == 0 || [password length] == 0) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名或密码不能为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        
        return;
    }
    
    [self.progressHUD show:YES];
    
    // Login Server
    [[AccountManager sharedInstance] asyncLoginWithLoginName:userName withPassword:password withCompletionHandler:^(Account *account, NSInteger statusCode) {
        if (0 == statusCode) {
            [[LocalCacheManager sharedInstance] saveLoginAccountWithLoginName:userName withLoginPassword:[password base64String]];
            // Login EaseMob
            NSString *easemobLoginName = [NSString stringWithFormat:@"%ld", account.accountID];
            NSString *easemobPassword = [account.easemobPassword uppercaseString];
            [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:easemobLoginName password:easemobPassword completion:^(NSDictionary *loginInfo, EMError *error) {
                [self.progressHUD hide:YES];
                if (loginInfo && !error) {
                    // DLog(@"%@ %@ 成功登录环信服务器!", easemobLoginName, easemobPassword);
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
        } else if (206 == statusCode) {
            [self.progressHUD hide:YES];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的资料正在审核中" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        } else if (302 == statusCode) {
            [self.progressHUD hide:YES];
            // 好医生用户第一次登录
            [[LocalCacheManager sharedInstance] saveLoginAccountWithLoginName:userName withLoginPassword:[password base64String]];
            SupplementViewController *supplementViewController = [[SupplementViewController alloc] init];
            supplementViewController.delegate = self;
            UINavigationController *navigationController = [[SkinManager sharedInstance] createDefaultNavigationControllerWithRootView:supplementViewController];
            [self.navigationController presentViewController:navigationController animated:YES completion:^{
                
            }];
        } else if (301 == statusCode) {
            [self.progressHUD hide:YES];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的资料审核不通过，需要补充填写资料" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }
    } withErrorHandler:^(NSError *error) {
        [self.progressHUD hide:YES];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:[[error userInfo] objectForKey:NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }];
}

- (void)retrievePasswordClicked:(UIButton *)button
{
    BeforeRetrievePasswordViewController *beforeRetrievePasswordViewController = [[BeforeRetrievePasswordViewController alloc] init];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:beforeRetrievePasswordViewController];
    
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)viewTapGestureFired:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self.view endEditing:NO];
}

- (void)userAgreementCheckButtonClicked:(UIButton *)button
{
    [self.userAgreementCheckButton setSelected:!self.userAgreementCheckButton.isSelected];
}

- (void)userAgreementButtonClicked:(id)sender;
{
    UserAgreementViewController *userAgreementViewController = [[UserAgreementViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:userAgreementViewController];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - Private Method

- (void)setupSubviews
{
    // 将滚动视图添加到视图中
    [self.view addSubview:self.contentScrollView];
    
    // 将同意协议和查看协议都放入一个view中
    UIView *userAgreementContainerView = [[UIView alloc] init];
//    userAgreementContainerView.backgroundColor = [UIColor blueColor];
    // 同意协议
    [userAgreementContainerView addSubview:self.userAgreementCheckButton];
    // 协议
    [userAgreementContainerView addSubview:self.userAgreementInfoButton];
    
    
    // 添加图标
    [self.contentScrollView addSubview:self.logoImageView];
    
    // 输入的view(包含账号和密码)
    [self.contentScrollView addSubview:self.inputView];
    
    // 信息文本框
    [self.contentScrollView addSubview:self.infoLabel];
    
    // 添加忘记密码的按钮
    [self.contentScrollView addSubview:self.forgotPasswordButton];
    // 登陆按钮
    [self.contentScrollView addSubview:self.loginButton];
    
    // 注册按钮
    [self.contentScrollView addSubview:self.registerButton];
    
    // 用户同意协议和协议的view
    [self.contentScrollView addSubview:userAgreementContainerView];
    
    // 将滚动视图充满全屏
    [self.view addConstraints:[self.contentScrollView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero]];
    
    // 图标垂直对齐
    [self.contentScrollView addConstraint:[self.logoImageView autoAlignAxisToSuperviewAxis:ALAxisVertical]];
    if (iPhone4 == 480.0) {
        // 图标的高度和滚动视图的高度相差80
        [self.contentScrollView addConstraint:[self.logoImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentScrollView withOffset:20.0f]];
    }
    else
    {
        [self.contentScrollView addConstraint:[self.logoImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentScrollView withOffset:60.0f]];
    }
    
    
    
    // 输入view的宽度是 屏幕宽度 - 46
    [self.contentScrollView addConstraint:[self.inputView autoSetDimension:ALDimensionWidth toSize:(App_Frame_Width - 46.0f)]];
    
    // 输入view的高度是91
    [self.contentScrollView addConstraint:[self.inputView autoSetDimension:ALDimensionHeight toSize:91.0f]];
    
    // 输入view的高度和图标的高度之间相差121
    [self.contentScrollView addConstraint:[self.inputView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.logoImageView withOffset:121.0f]];
    
    // 输入view和父view垂直对齐
    [self.contentScrollView addConstraint:[self.inputView autoAlignAxisToSuperviewAxis:ALAxisVertical]];
    { // view中的视图进行布局
        
        [self.inputView addConstraint:[self.userNameTextField autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.inputView withOffset:45.0f]];
        [self.inputView addConstraint:[self.userNameTextField autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.inputView withOffset:3.0f]];
        [self.inputView addConstraint:[self.userNameTextField autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.inputView withOffset:0.0f]];
        [self.inputView addConstraint:[self.userNameTextField autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.horizontalLine withOffset:-3.0f]];
        
        [self.inputView addConstraint:[self.userIconImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.inputView withOffset:13.0f]];
        [self.inputView addConstraint:[self.userIconImageView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.userNameTextField]];
        [self.inputView addConstraint:[self.userIconImageView autoSetDimension:ALDimensionWidth toSize:22.0f]];
        [self.inputView addConstraint:[self.userIconImageView autoSetDimension:ALDimensionHeight toSize:25.0f]];
        
        [self.inputView addConstraint:[self.horizontalLine autoSetDimension:ALDimensionHeight toSize:0.5f]];
        [self.inputView addConstraint:[self.horizontalLine autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
        [self.inputView addConstraint:[self.horizontalLine autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.inputView]];
        [self.inputView addConstraint:[self.horizontalLine autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.inputView]];
        
        [self.inputView addConstraint:[self.passwordIconImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.inputView withOffset:13.0f]];
        [self.inputView addConstraint:[self.passwordIconImageView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.passwordTextField]];
        [self.inputView addConstraint:[self.passwordIconImageView autoSetDimension:ALDimensionWidth toSize:20.0f]];
        [self.inputView addConstraint:[self.passwordIconImageView autoSetDimension:ALDimensionHeight toSize:25.0f]];
        
        [self.inputView addConstraint:[self.passwordTextField autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.inputView withOffset:45.0f]];
        [self.inputView addConstraint:[self.passwordTextField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.horizontalLine withOffset:3.0f]];
        [self.inputView addConstraint:[self.passwordTextField autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.inputView withOffset:0.0f]];
        [self.inputView addConstraint:[self.passwordTextField autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.inputView withOffset:-3.0f]];
        
    }
    
    // 信息文本的高度是15
    [self.contentScrollView addConstraint:[self.infoLabel autoSetDimension:ALDimensionHeight toSize:15.0f]];
    
    // 信息文本的高度和输入view的底部相差20
    [self.contentScrollView addConstraint:[self.infoLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.inputView withOffset:20.0f]];
    
    // 信息文本的左边和滚动视图的左边相差23
    [self.contentScrollView addConstraint:[self.infoLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentScrollView withOffset:23.0f]];
    
    // 忘记密码的按钮与信息文本的水平
    [self.contentScrollView addConstraint:[self.forgotPasswordButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.infoLabel]];
    
    // 忘记密码按钮的右边和输入view的右边相同
    [self.contentScrollView addConstraint:[self.forgotPasswordButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.inputView]];
    
    // 登陆按钮的上边和信息文本的下面相差25
    [self.contentScrollView addConstraint:[self.loginButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.infoLabel withOffset:25.0f]];
    
    // 登陆按钮和父类垂直对齐
    [self.contentScrollView addConstraint:[self.loginButton autoAlignAxisToSuperviewAxis:ALAxisVertical]];
    
    // 登陆按钮的高度是50
    [self.contentScrollView addConstraint:[self.loginButton autoSetDimension:ALDimensionHeight toSize:50.0f]];
    
    // 登陆按钮的宽度  屏幕宽度 - 46
    [self.contentScrollView addConstraint:[self.loginButton autoSetDimension:ALDimensionWidth toSize:App_Frame_Width - 46.0f]];
    
    // 注册按钮的顶部和登陆按钮的底部相差20
    [self.contentScrollView addConstraint:[self.registerButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.loginButton withOffset:20.0f]];
    
    // 注册按钮和父类垂直对齐
    [self.contentScrollView addConstraint:[self.registerButton autoAlignAxisToSuperviewAxis:ALAxisVertical]];
    
    // 注册按钮的高度是50
    [self.contentScrollView addConstraint:[self.registerButton autoSetDimension:ALDimensionHeight toSize:50.0f]];
    
    // 注册按钮的宽度是 屏幕宽度 - 46
    [self.contentScrollView addConstraint:[self.registerButton autoSetDimension:ALDimensionWidth toSize:App_Frame_Width - 46.0f]];
    
    
    // 设置宽度和高度为  278 X 27
    [self.contentScrollView addConstraints:[userAgreementContainerView autoSetDimensionsToSize:CGSizeMake(330.0f, 27.0f)]];
    
    // 同意view的顶部和注册按钮的底部相差20
    [self.contentScrollView addConstraint:[userAgreementContainerView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.registerButton withOffset:30.0f]];
    
    [self.contentScrollView addConstraint:[userAgreementContainerView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentScrollView withOffset:23.0f]];
    
    // 同意view和父类垂直对齐
    [self.contentScrollView addConstraint:[userAgreementContainerView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.registerButton]];
    
    {
        // 同意协议按钮和父类的左边进行了约束
        [userAgreementContainerView addConstraint:[self.userAgreementCheckButton autoPinEdgeToSuperviewEdge:ALEdgeLeft]];
        
        // 和父类进行水平对齐
        [userAgreementContainerView addConstraint:[self.userAgreementCheckButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
        
        // 协议的左边和同意协议的右边进行相应的约束
        [userAgreementContainerView addConstraint:[self.userAgreementInfoButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.userAgreementCheckButton]];
        
        // 和父类进行相应的水平对齐
        [userAgreementContainerView addConstraint:[self.userAgreementInfoButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
        
        // 和输入进行右边的关联为0？？？？
        // [self.contentScrollView addConstraint:[self.userAgreementInfoButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.inputView]];
        
        // 配置两个按钮的水平宽度是相同的
        [self.contentScrollView addConstraint:[self.userAgreementCheckButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.userAgreementInfoButton]];
        
        // 同意协议的右边和协议的左边进行相应的约束
        [self.contentScrollView addConstraint:[self.userAgreementCheckButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.userAgreementInfoButton]];
        
    }
    
    
}


#pragma mark - MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    if (hud) {

    }
}

#pragma mark - SupplementViewControllerDelegate

- (void)supplementViewControllerDidSuccessSupplement:(SupplementViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:^{
        [self.progressHUD show:YES];
        // Login EaseMob
        Account *account = [AccountManager sharedInstance].account;
        NSString *easemobLoginName = [NSString stringWithFormat:@"%ld", account.accountID];
        NSString *easemobPassword = [account.easemobPassword uppercaseString];
        [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:easemobLoginName password:easemobPassword completion:^(NSDictionary *loginInfo, EMError *error) {
            [self.progressHUD hide:YES];
            if (loginInfo && !error) {
                DLog(@"%@ %@ 成功登录环信服务器!", easemobLoginName, easemobPassword);
                //[[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
                [LoginManager sharedInstance].loginStatus = LOGINSTATUS_ONLINE;
            }else {
                switch (error.errorCode) {
                    case EMErrorServerNotReachable:
                        DLog(@"连接服务器失败!");
                        break;
                    case EMErrorServerAuthenticationFailure:
                        DLog(@"用户名或密码错误");
                        break;
                    case EMErrorServerTimeout:
                        DLog(@"连接服务器超时!");
                        break;
                    default:
                        DLog(@"登录失败");
                        break;
                }
            }
        } onQueue:nil];
    }];
}

@end
