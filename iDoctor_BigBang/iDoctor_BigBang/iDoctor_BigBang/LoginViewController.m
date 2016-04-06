//
//  LoginViewController.m
//  iDoctor_BigBang
//
//  Created by 周世阳 on 15/9/24.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import "LoginViewController.h"
#import "ResetPasswodViewController.h"
#import "RegistWithOneViewController.h"
#import "IDLoginTextField.h"
#import "AccountManager.h"
#import "ContactManager.h"
#import "IDTabBarController.h"
#import "LoginManager.h"


@interface LoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) IDLoginTextField *phoneTextField;
@property (nonatomic, strong) IDLoginTextField *passowrdField;
@property (nonatomic, strong) UIButton *forgetPwdButton;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *registButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupViews];
    
    [self readNSUserDefaults];
}

// 读取相应的数据
- (void)readNSUserDefaults
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString *loginName = [userDefault stringForKey:@"loginName"];
    NSString *password = [userDefault stringForKey:@"password"];
        
    self.passowrdField.text = password?password:nil;
    self.phoneTextField.text = loginName?loginName:nil;
    
    
    if (loginName.length != 0 && loginName && password.length != 0 && password) { // 存在相应的账号 密码
        
        [self login];
        
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}


#pragma mark - 
- (void)setupViews {
    
    UIView *contentView = self.view;

    UIImageView *backgroudImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"login_bg"] stretchableImageWithLeftCapWidth:1 topCapHeight:1334]];
    [contentView addSubview:backgroudImageView];
    [backgroudImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(contentView);
    }];
    
    
    // 加上一个相应的大背景的controller
    UIControl *control = [[UIControl alloc] init];
    control.backgroundColor = [UIColor clearColor];
    [control addTarget:self action:@selector(resignResponder:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:control];
    [control mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(contentView);
        
    }];
    
    [contentView addSubview:self.logoImageView];
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(209.0f);
        make.height.equalTo(50.0f);
        make.centerX.equalTo(contentView);
        make.top.equalTo(contentView).with.offset(63.0f);
    }];
    
    UIView *authContentView = [[UIView alloc] init];
    authContentView.backgroundColor = [UIColor clearColor];
    ViewBorderRadius(authContentView, 3.0f, 0.7f, UIColorFromRGB(0x79dee0));
    
    [contentView addSubview:authContentView];
    [authContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.logoImageView.bottom).with.offset(55.0f);
        make.left.equalTo(contentView).with.offset(15.0f);
        make.right.equalTo(contentView).with.offset(-15.0f);
        make.height.equalTo(120.0f);
    }];
    
    UIImageView *phoneIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_phone_icon"]];
    [authContentView addSubview:phoneIcon];
    [phoneIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(22.0f);
        make.height.equalTo(21.0f);
        make.left.equalTo(authContentView).with.offset(15.0f);
        make.top.equalTo(authContentView).with.offset(17.0f);
    }];
    
    [authContentView addSubview:self.phoneTextField];
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(authContentView);
        make.left.equalTo(phoneIcon.right).with.offset(18.0f);
        make.height.equalTo(60.0f);
        make.right.equalTo(authContentView).with.offset(-18.0f);
    }];
    
    UIView *whiteLine = [[UIView alloc] init];
    whiteLine.backgroundColor = UIColorFromRGB(0x79dee0);
    [authContentView addSubview:whiteLine];
    [whiteLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.and.right.equalTo(authContentView);
        make.height.equalTo(0.7f);
        make.top.equalTo(authContentView).with.offset(60.0f);
    }];
    
    UIImageView *passowrdIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_pwd_icon"]];
    [authContentView addSubview:passowrdIcon];
    [passowrdIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(21.0f);
        make.height.equalTo(21.0f);
        make.top.equalTo(whiteLine).with.offset(18.0f);
        make.left.equalTo(authContentView).with.offset(15.0f);
    }];
    
    [authContentView addSubview:self.forgetPwdButton];
    [self.forgetPwdButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(authContentView).with.offset(-15.0f);
        make.centerY.equalTo(passowrdIcon);
        make.width.equalTo(65.0f);
    }];
    
    
    [authContentView addSubview:self.passowrdField];
    [self.passowrdField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(whiteLine);
        make.bottom.equalTo(authContentView);
        make.left.equalTo(passowrdIcon.right).with.offset(18.0f);
        make.height.equalTo(60.0f);
        make.right.equalTo(self.forgetPwdButton.left).with.offset(-10.0f);
    }];
    
    UILabel * mylabel = [[UILabel alloc]init];
    mylabel.text = @"如您已是好医生网站会员，请直接用好医生网站账号登录";
    mylabel.font = [UIFont systemFontOfSize:12.0f];
    mylabel.textColor = UIColorFromRGB(0xa8e1e2);
    mylabel.numberOfLines = 2;
    [contentView addSubview:mylabel];
    [mylabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passowrdField.bottom).with.offset(5.0f);
        make.left.equalTo(20.0f);
        make.right.equalTo(self.forgetPwdButton.right);
        make.height.equalTo(32.0f);
    }];
    
    [contentView addSubview:self.loginButton];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(contentView).with.offset(15.0f);
        make.right.equalTo(contentView).with.offset(-15.0f);
        make.top.equalTo(authContentView.bottom).with.offset(40.0f);
        make.height.equalTo(50.0f);
    }];
    
    [contentView addSubview:self.registButton];
    [self.registButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(contentView).with.offset(-20.0f);
        make.centerX.equalTo(contentView);
    }];
    
   
    
}

#pragma mark - Selectors

// 背景的control的点击事件
- (void)resignResponder:(UIControl *)control
{
    [self.phoneTextField resignFirstResponder];
    [self.passowrdField resignFirstResponder];
}



- (void)login {
    
    NSString *phone = self.phoneTextField.text;
    NSString *password = self.passowrdField.text;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    if (phone == nil || phone.length == 0) { // 没有填写相应的账户

        alert.message = @"手机号或密码不能为空";
        [alert show];

        return;
    } else if (password == nil || password.length == 0) {
        
        alert.message = @"手机号或密码不能为空";
        [alert show];
        
        return;
    }
    
    [MBProgressHUD showMessage:@"正在登陆..." toView:self.view isDimBackground:NO];
    
    //自己服务器登录
    [[AccountManager sharedInstance] loginWithLoginName:phone withPassword:password withCompletionHandler:^(Account *account) {
        //自己服务器登录成功
        [self saveNSUserDefaultsWithLoginName:phone password:password];//存储信息
        [AccountManager sharedInstance].account = account;
        [[AccountManager sharedInstance] cacheAccount];//存储信息
        //登录环信
        [self EaseMobLoginwithCompletionHandler:^(NSDictionary *loginInfo, EMError *error) {
                //环信也登录成功
                ContactManager *manager = [ContactManager sharedInstance];
                //获取联系人和最近联系人
                [manager getPatientsInformationWithDoctorID:KContactViewRefresh withCompletionHandelr:^(BOOL bSuccess, NSInteger contactCount) {
                    [MBProgressHUD hideHUDForView:self.view];
                    // 进入首页
//                    UIWindow *windown = [UIApplication sharedApplication].keyWindow;
//                    
//                    IDTabBarController *tabBar = [[IDTabBarController alloc] init];
//                    windown.rootViewController = tabBar;
                    [LoginManager sharedInstance].loginStatus = LOGINSTATUS_LOGIN;
                    
                } withErrorHandler:^(NSError *error) {
//                    [MBProgressHUD hideHUD];
                    
                    
                    // 报错
                    [MBProgressHUD hideHUDForView:self.view];
                    [MBProgressHUD showError:error.localizedDescription toView:self.view];
                }];
        } withErrorHandler:^(EMError *error){
            NSString *errorText = @"";
            
            switch (error.errorCode) {
                case EMErrorServerNotReachable:
                    errorText = @"环信:连接服务器失败!";
                    break;
                case EMErrorServerAuthenticationFailure:
                    errorText = @"环信:用户名或密码错误";
                    break;
                case EMErrorServerTimeout:
                    errorText = @"环信:连接服务器超时!";
                    break;
                default:
                    errorText = @"环信:登录失败";
                    break;
            }
            // 报错
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showError:errorText toView:self.view];
        }];
    } withErrorHandler:^(NSError *error) {
        // 报错
        [MBProgressHUD hideHUDForView:self.view];
        [self handleError:error];
        
    }];
    
}

-(void)EaseMobLoginwithCompletionHandler:(void (^)(NSDictionary *loginInfo, EMError *error))completionHandler withErrorHandler:(void (^)(EMError *error))errorHandler{
    //TODO 环信
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:[NSString stringWithFormat:@"%ld",(long)[AccountManager sharedInstance].account.doctor_id] password:[AccountManager sharedInstance].account.easemob_passwd completion:^(NSDictionary *loginInfo, EMError *error) {
        if (loginInfo && !error) {
            completionHandler(loginInfo,error);
        }else{
            errorHandler(error);
        }
    } onQueue:nil];
}


// 将数据存储到相应的地方
- (void)saveNSUserDefaultsWithLoginName:(NSString *)loginName password:(NSString *)password
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    [userDefault setObject:loginName forKey:@"loginName"];
    [userDefault setObject:password forKey:@"password"];
    
    // 同步到磁盘
    [userDefault synchronize];
}

- (void)toRegistVC {
    
    RegistWithOneViewController *registOneVC = [[RegistWithOneViewController alloc] init];
    [self.navigationController pushViewController:registOneVC animated:YES];
}

- (void)toForgetPwdVC {
    
    ResetPasswodViewController *resetPwdVC = [[ResetPasswodViewController alloc] init];
    resetPwdVC.title = @"忘记密码";
    [self.navigationController pushViewController:resetPwdVC animated:YES];
}

#pragma mark - Properties
- (UIImageView *)logoImageView {
    
	if(_logoImageView == nil) {
        
		_logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_logo"]];
	}
    
	return _logoImageView;
}

- (IDLoginTextField *)phoneTextField {
    
	if(_phoneTextField == nil) {
        
		_phoneTextField = [[IDLoginTextField alloc] init];
        _phoneTextField.textColor = [UIColor whiteColor];
        _phoneTextField.font = [UIFont systemFontOfSize:15.0f];
        _phoneTextField.placeholder = @"输入手机号";
//        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//        if([userDefault objectForKey:@"loginName"]){
//            _phoneTextField.text = [userDefault objectForKey:@"loginName"];
//        }
        _phoneTextField.delegate = self;
	}
    
	return _phoneTextField;
}

- (IDLoginTextField *)passowrdField {
    
	if(_passowrdField == nil) {
        
		_passowrdField = [[IDLoginTextField alloc] init];
        _passowrdField.textColor = [UIColor whiteColor];
        _passowrdField.font = [UIFont systemFontOfSize:15.0f];
        _passowrdField.placeholder = @"输入密码";
//        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//        if([userDefault objectForKey:@"password"]){
//            _passowrdField.text = [userDefault objectForKey:@"password"];
//        }
        _passowrdField.secureTextEntry = YES;
        _passowrdField.delegate = self;
	}
    
	return _passowrdField;
}

// 按下相应的return键
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (UIButton *)forgetPwdButton {
    
    if(_forgetPwdButton == nil) {
        
        _forgetPwdButton = [[UIButton alloc] init];
        [_forgetPwdButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
        [_forgetPwdButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _forgetPwdButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [_forgetPwdButton setBackgroundColor:[UIColor clearColor]];
        [_forgetPwdButton addTarget:self action:@selector(toForgetPwdVC) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _forgetPwdButton;
}


- (UIButton *)loginButton {
    
	if(_loginButton == nil) {
        
		_loginButton = [[UIButton alloc] init];
        [_loginButton setBackgroundColor:UIColorFromRGB(0x11aeb1)];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        ViewRadius(_loginButton, 3.0f);
        [_loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
	}
    
	return _loginButton;
}

- (UIButton *)registButton {
    
	if(_registButton == nil) {
        
		_registButton = [[UIButton alloc] init];
        [_registButton setBackgroundColor:[UIColor clearColor]];
        [_registButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _registButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [_registButton setTitle:@"注册新用户" forState:UIControlStateNormal];
        [_registButton addTarget:self action:@selector(toRegistVC) forControlEvents:UIControlEventTouchUpInside];
	}
    
	return _registButton;
}

@end
