//
//  ChangePasswordViewController.m
//  AppFramework
//
//  Created by ABC on 8/10/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "SkinManager.h"
#import "UIViewController+Util.h"
#import "UIView+AutoLayout.h"
#import "MBProgressHUD.h"
#import "AccountManager.h"

@interface ChangePasswordViewController ()
<
UITextFieldDelegate,
MBProgressHUDDelegate,
UIAlertViewDelegate
>

@property (nonatomic, strong) UIScrollView                  *contentScrollView;
@property (nonatomic, strong) EXUITextField                 *oldPasswordTextField;
@property (nonatomic, strong) EXUITextField                 *passwordTextField;
@property (nonatomic, strong) EXUITextField                 *confirmTextField;
@property (nonatomic, strong) UIButton                      *nextButton;
@property (nonatomic, strong) MBProgressHUD                 *progressHUD;

- (void)setupSubviews;
- (void)setupConstraints;

- (void)viewTapGestureFired:(UITapGestureRecognizer *)tapGestureRecognizer;
- (void)nextButtonClicked:(UIButton *)button;

@end

@implementation ChangePasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        self.title = @"设置登录密码";
        [self setHidesBottomBarWhenPushed:YES];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationBarWithTitle:@"修改密码" leftBarButtonItem:[self makeLeftReturnBarButtonItem] rightBarButtonItem:nil];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [SkinManager sharedInstance].defaultViewBackgroundColor;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self setupSubviews];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapGestureFired:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
//    [[SkinManager sharedInstance] navigationRootViewControllerSizeToFit:self];
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

#pragma mark - Property

- (UIScrollView *)contentScrollView
{
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] init];
        _contentScrollView.backgroundColor = UIColorFromRGB(0xedf2f1);
    }
    return _contentScrollView;
}

- (EXUITextField *)oldPasswordTextField
{
    if (!_oldPasswordTextField) {
        _oldPasswordTextField = [[SkinManager sharedInstance] createDefaultTextField];
        _oldPasswordTextField.layer.borderColor = [[UIColor clearColor] CGColor];
        _oldPasswordTextField.delegate = self;
        _oldPasswordTextField.secureTextEntry = YES;
        [_oldPasswordTextField setPlaceholder:@"旧密码"];
    }
    return _oldPasswordTextField;
}

- (EXUITextField *)passwordTextField
{
    if (!_passwordTextField) {
        _passwordTextField = [[SkinManager sharedInstance] createDefaultTextField];
        _passwordTextField.layer.borderColor = [[UIColor clearColor] CGColor];
        _passwordTextField.delegate = self;
        _passwordTextField.secureTextEntry = YES;
        [_passwordTextField setPlaceholder:@"新密码"];
    }
    return _passwordTextField;
}

- (EXUITextField *)confirmTextField
{
    if (!_confirmTextField) {
        _confirmTextField = [[SkinManager sharedInstance] createDefaultTextField];
        _confirmTextField.layer.borderColor = [[UIColor clearColor] CGColor];
        _confirmTextField.delegate = self;
        _confirmTextField.secureTextEntry = YES;
        [_confirmTextField setPlaceholder:@"再次输入新密码"];
    }
    return _confirmTextField;
}

- (UIButton *)nextButton
{
    if (!_nextButton) {
        _nextButton = [[SkinManager sharedInstance] createDefaultButton];
        _nextButton.backgroundColor = UIColorFromRGB(0x34d2b4);
        [_nextButton setTitleColor:[SkinManager sharedInstance].defaultWhiteColor forState:UIControlStateNormal];
        [_nextButton setTitle:@"确定" forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(nextButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _nextButton.layer.cornerRadius = 6.0f;
    }
    return _nextButton;
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


#pragma mark - Private Method

//- (void)setupSubviews
//{
//    [self.view addSubview:self.contentScrollView];
//    
//    [self.contentScrollView addSubview:self.oldPasswordTextField];
//    [self.contentScrollView addSubview:self.passwordTextField];
//    [self.contentScrollView addSubview:self.confirmTextField];
//    [self.contentScrollView addSubview:self.nextButton];
//    
//    [self setupConstraints];
//}

- (void)setupSubviews
{
    self.view.backgroundColor = UIColorFromRGB(0xedf2f1);
    [self.view addSubview:self.contentScrollView];
    
    [self.view addConstraints:[self.contentScrollView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)]];
    
    
    
    UIView *oldPasswordContainer = [[UIView alloc] init];
    UIView *newPasswordContainer = [[UIView alloc] init];
    UIView *confirmContainer = [[UIView alloc] init];
    
    oldPasswordContainer.backgroundColor = [UIColor whiteColor];
    oldPasswordContainer.layer.cornerRadius = 6.0f;
    oldPasswordContainer.layer.borderColor = [UIColorFromRGB(0xbfbfbf) CGColor];
    oldPasswordContainer.layer.borderWidth = 0.5f;
    
    newPasswordContainer.backgroundColor = [UIColor whiteColor];
    newPasswordContainer.layer.cornerRadius = 6.0f;
    newPasswordContainer.layer.cornerRadius = 6.0f;
    newPasswordContainer.layer.borderColor = [UIColorFromRGB(0xbfbfbf) CGColor];
    newPasswordContainer.layer.borderWidth = 0.5f;
    
    confirmContainer.backgroundColor = [UIColor whiteColor];
    confirmContainer.layer.cornerRadius = 6.0f;
    confirmContainer.layer.cornerRadius = 6.0f;
    confirmContainer.layer.borderColor = [UIColorFromRGB(0xbfbfbf) CGColor];
    confirmContainer.layer.borderWidth = 0.5f;
    
    
    UIImageView *iconOldPassword = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_oldpwd"]];
    UIImageView *iconNewPassword = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_newpwd"]];
    UIImageView *iconConfirmPassword = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_newpwd"]];
    
    [oldPasswordContainer addSubview:self.oldPasswordTextField];
    [oldPasswordContainer addSubview:iconOldPassword];
//    oldPasswordContainer.backgroundColor = [UIColor greenColor];
    
    [newPasswordContainer addSubview:self.passwordTextField];
    [newPasswordContainer addSubview:iconNewPassword];
    
    [confirmContainer addSubview:self.confirmTextField];
    [confirmContainer addSubview:iconConfirmPassword];

    [self.contentScrollView addSubview:oldPasswordContainer];
    [self.contentScrollView addSubview:newPasswordContainer];
    [self.contentScrollView addSubview:confirmContainer];
    [self.contentScrollView addSubview:self.nextButton];
    
    [self.contentScrollView addConstraints:[oldPasswordContainer autoSetDimensionsToSize:CGSizeMake(App_Frame_Width - 20.0f, 46.0f)]];
    [self.contentScrollView addConstraints:[newPasswordContainer autoSetDimensionsToSize:CGSizeMake(App_Frame_Width - 20.0f, 46.0f)]];
    [self.contentScrollView addConstraints:[confirmContainer autoSetDimensionsToSize:CGSizeMake(App_Frame_Width - 20.0f, 46.0f)]];
    [self.contentScrollView addConstraints:[self.nextButton autoSetDimensionsToSize:CGSizeMake(App_Frame_Width - 20.0f, 45.0f)]];
    
    
    [self.contentScrollView addConstraint:[oldPasswordContainer autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentScrollView withOffset:10.0f]];
    [self.contentScrollView addConstraint:[oldPasswordContainer autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentScrollView withOffset:10.0f]];
    [self.contentScrollView addConstraint:[oldPasswordContainer autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentScrollView withOffset:-10.0f]];
    [self.contentScrollView addConstraint:[oldPasswordContainer autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentScrollView withOffset:-10.0f]];
    
    [oldPasswordContainer addConstraint:[iconOldPassword autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f]];
    [oldPasswordContainer addConstraint:[iconOldPassword autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
    [oldPasswordContainer addConstraints:[iconOldPassword autoSetDimensionsToSize:CGSizeMake(15.0f, 21.0f)]];
    
    [oldPasswordContainer addConstraint:[self.oldPasswordTextField autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:iconOldPassword]];
    [oldPasswordContainer addConstraint:[self.oldPasswordTextField autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
    [oldPasswordContainer addConstraint:[self.oldPasswordTextField autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f]];
    [oldPasswordContainer addConstraint:[self.oldPasswordTextField autoSetDimension:ALDimensionHeight toSize:46.0f]];
    
    
    [self.contentScrollView addConstraint:[newPasswordContainer autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentScrollView withOffset:10.0f]];
    [self.contentScrollView addConstraint:[newPasswordContainer autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:oldPasswordContainer withOffset:10.0f]];
    [self.contentScrollView addConstraint:[newPasswordContainer autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentScrollView withOffset:-10.0f]];
    [self.contentScrollView addConstraint:[newPasswordContainer autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentScrollView withOffset:-10.0f]];
    
    [newPasswordContainer addConstraint:[iconNewPassword autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f]];
    [newPasswordContainer addConstraint:[iconNewPassword autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
    [newPasswordContainer addConstraints:[iconNewPassword autoSetDimensionsToSize:CGSizeMake(15.0f, 21.0f)]];
    
    [newPasswordContainer addConstraint:[self.passwordTextField autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:iconNewPassword]];
    [newPasswordContainer addConstraint:[self.passwordTextField autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
    [newPasswordContainer addConstraint:[self.passwordTextField autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f]];
    [newPasswordContainer addConstraint:[self.passwordTextField autoSetDimension:ALDimensionHeight toSize:46.0f]];
    
    
    [self.contentScrollView addConstraint:[confirmContainer autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentScrollView withOffset:10.0f]];
    [self.contentScrollView addConstraint:[confirmContainer autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:newPasswordContainer withOffset:10.0f]];
    [self.contentScrollView addConstraint:[confirmContainer autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentScrollView withOffset:-10.0f]];
    [self.contentScrollView addConstraint:[confirmContainer autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentScrollView withOffset:-10.0f]];
    
    [confirmContainer addConstraint:[iconConfirmPassword autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f]];
    [confirmContainer addConstraint:[iconConfirmPassword autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
    [confirmContainer addConstraints:[iconConfirmPassword autoSetDimensionsToSize:CGSizeMake(15.0f, 21.0f)]];
    
    [confirmContainer addConstraint:[self.confirmTextField autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:iconConfirmPassword]];
    [confirmContainer addConstraint:[self.confirmTextField autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
    [confirmContainer addConstraint:[self.confirmTextField autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f]];
    [confirmContainer addConstraint:[self.confirmTextField autoSetDimension:ALDimensionHeight toSize:46.0f]];
    
    [self.contentScrollView addConstraint:[self.nextButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentScrollView withOffset:-10.0f]];
    [self.contentScrollView addConstraint:[self.nextButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentScrollView withOffset:-10.0f]];
    [self.contentScrollView addConstraint:[self.nextButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentScrollView withOffset:10.0f]];
    [self.contentScrollView addConstraint:[self.nextButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:confirmContainer withOffset:10.0f]];
}


#pragma mark - Selector

- (void)viewTapGestureFired:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self.view endEditing:NO];
}

- (void)nextButtonClicked:(UIButton *)button
{
    [self.view endEditing:NO];
    
    NSString *password = [self.passwordTextField text];
    NSString *confirmPassword = [self.confirmTextField text];
    if (![password isEqualToString:confirmPassword]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码不一致" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        return ;
    }
    // TODO:修改密码
    [self.progressHUD show:YES];
    NSString *oldPassword = [self.oldPasswordTextField text];
    [[AccountManager sharedInstance] asyncChangeLoginPassword:confirmPassword withOldPassword:oldPassword withCompletionHandler:^(BOOL isSuccess) {
        [self.progressHUD hide:YES];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    } withErrorHandler:^(NSError *error) {
        [self.progressHUD hide:YES];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:@"原密码输入错误" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.oldPasswordTextField == textField || self.passwordTextField == textField || self.confirmTextField == textField) {
        [textField resignFirstResponder];
        return YES;
    }
    return NO;
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
