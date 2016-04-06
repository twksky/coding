//
//  RetrievePasswordViewController.m
//  AppFramework
//
//  Created by ABC on 8/7/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "RetrievePasswordViewController.h"
#import "SkinManager.h"
#import "UIView+AutoLayout.h"
#import "UIViewController+Util.h"
#import "AccountManager.h"
#import "MBProgressHUD.h"

@interface RetrievePasswordViewController ()
<
UITextFieldDelegate,
MBProgressHUDDelegate,
UIAlertViewDelegate
>
//{
//    NSTimer     *countTimer;
//    NSInteger   seconds;
//}

@property (nonatomic, strong) UIScrollView                  *contentScrollView;
//@property (nonatomic, strong) EXUITextField                 *mobileTextField;
@property (nonatomic, strong) EXUITextField                 *captchaTextField;
@property (nonatomic, strong) UIImageView                   *iconCapthaImageView;
//@property (nonatomic, strong) UIButton                      *onceAgainButton;
@property (nonatomic, strong) EXUITextField                 *passwordTextField;
@property (nonatomic ,strong) UIImageView                   *iconRetrievePasswordImageView;
@property (nonatomic, strong) EXUITextField                 *confirmTextField;
@property (nonatomic ,strong) UIImageView                   *iconConfrimRetrievePasswordImageView;
@property (nonatomic, strong) UIButton                      *nextButton;
@property (nonatomic, strong) MBProgressHUD                 *progressHUD;

@property (nonatomic, strong) NSString                      *mobile;

- (void)setupSubviews;
//- (void)setupConstraints;

//- (void)onceAgainButtonClicked:(UIButton *)button;
- (void)nextButtonClicked:(UIButton *)button;

//- (void)timerFireMethod:(NSTimer *)timer;

@end

@implementation RetrievePasswordViewController

- (instancetype)initWithMobile:(NSString *)mobile {
    
    self = [super init];
    if (self) {
        
        self.mobile = mobile;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarWithTitle:@"找回密码" leftBarButtonItem:nil rightBarButtonItem:nil];
    
    self.view.backgroundColor = UIColorFromRGB(0xedf2f1);
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self setupSubviews];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapGestureFired:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
//    [[SkinManager sharedInstance] navigationRootViewControllerSizeToFit:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //[DaiDodgeKeyboard addRegisterTheViewNeedDodgeKeyboard:self.contentScrollView];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChangedNotificaton:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //[DaiDodgeKeyboard removeRegisterTheViewNeedDodgeKeyboard];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
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


#pragma mark - Private Method

- (void)setupSubviews
{
    [self.view addSubview:self.contentScrollView];
//    [self.contentScrollView addSubview:self.mobileTextField];
    [self.contentScrollView addSubview:self.captchaTextField];
//    [self.contentScrollView addSubview:self.onceAgainButton];
    [self.contentScrollView addSubview:self.iconCapthaImageView];
    [self.contentScrollView addSubview:self.passwordTextField];
    [self.contentScrollView addSubview:self.iconRetrievePasswordImageView];
    [self.contentScrollView addSubview:self.confirmTextField];
    [self.contentScrollView addSubview:self.iconConfrimRetrievePasswordImageView];
    [self.contentScrollView addSubview:self.nextButton];
    
    UIView *line1 = [self generateLineView];
    UIView *line2 = [self generateLineView];
    UIView *line3 = [self generateLineView];
    UIView *line4 = [self generateLineView];
    
    [self.contentScrollView addSubview:line1];
    [self.contentScrollView addSubview:line2];
    [self.contentScrollView addSubview:line3];
    [self.contentScrollView addSubview:line4];
    
    // Status
//    [self.captchaTextField setEnabled:NO];
//    [self.onceAgainButton setEnabled:NO];
//    [self.nextButton setEnabled:NO];
    
    [self.view addConstraints:[self.contentScrollView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)]];
    
//    [self.contentScrollView addConstraint:[self.mobileTextField autoSetDimension:ALDimensionWidth toSize:(App_Frame_Width - 20.0f)]];
//    [self.contentScrollView addConstraint:[self.mobileTextField autoSetDimension:ALDimensionHeight toSize:46.0f]];
    [self.contentScrollView addConstraints:[self.captchaTextField autoSetDimensionsToSize:CGSizeMake(App_Frame_Width, 52.0f)]];
    [self.contentScrollView addConstraints:[self.iconCapthaImageView autoSetDimensionsToSize:CGSizeMake(13.0f, 26.0f)]];
//    [self.contentScrollView addConstraints:[self.onceAgainButton autoSetDimensionsToSize:CGSizeMake(150.0f, 46.0f)]];
    [self.contentScrollView addConstraints:[self.passwordTextField autoSetDimensionsToSize:CGSizeMake(App_Frame_Width, 52.0f)]];
    [self.contentScrollView addConstraints:[self.iconRetrievePasswordImageView autoSetDimensionsToSize:CGSizeMake(17.0f, 26.0f)]];
    [self.contentScrollView addConstraints:[self.confirmTextField autoSetDimensionsToSize:CGSizeMake(App_Frame_Width, 52.0f)]];
    [self.contentScrollView addConstraints:[self.iconConfrimRetrievePasswordImageView autoSetDimensionsToSize:CGSizeMake(17.0f, 26.0f)]];
    [self.contentScrollView addConstraints:[self.nextButton autoSetDimensionsToSize:CGSizeMake(App_Frame_Width - 32.0f, 52.0f)]];
    
    [self.contentScrollView addConstraints:[line1 autoSetDimensionsToSize:CGSizeMake(App_Frame_Width, 0.7f)]];
    [self.contentScrollView addConstraints:[line2 autoSetDimensionsToSize:CGSizeMake(App_Frame_Width * 0.95f, 0.7f)]];
    [self.contentScrollView addConstraints:[line3 autoSetDimensionsToSize:CGSizeMake(App_Frame_Width * 0.95f, 0.7f)]];
    [self.contentScrollView addConstraints:[line4 autoSetDimensionsToSize:CGSizeMake(App_Frame_Width, 0.7f)]];
    
//    [self.contentScrollView addConstraint:[self.mobileTextField autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentScrollView withOffset:10.0f]];
//    [self.contentScrollView addConstraint:[self.mobileTextField autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentScrollView withOffset:10.0f]];
//    [self.contentScrollView addConstraint:[self.mobileTextField autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentScrollView withOffset:-10.0f]];
//    [self.contentScrollView addConstraint:[self.onceAgainButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentScrollView withOffset:-10.0f]];
    [self.contentScrollView addConstraint:[self.passwordTextField autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentScrollView]];
    [self.contentScrollView addConstraint:[self.confirmTextField autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentScrollView]];
    [self.contentScrollView addConstraint:[self.nextButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentScrollView withOffset:-16.0f]];
    [self.contentScrollView addConstraint:[self.nextButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentScrollView withOffset:16.0f]];
    [self.contentScrollView addConstraint:[self.confirmTextField autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentScrollView]];
    [self.contentScrollView addConstraint:[self.passwordTextField autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentScrollView]];
    [self.contentScrollView addConstraint:[self.captchaTextField autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentScrollView]];
    [self.contentScrollView addConstraint:[self.captchaTextField autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentScrollView]];
    [self.contentScrollView addConstraint:[self.captchaTextField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.contentScrollView withOffset:20.0f]];
    [self.contentScrollView addConstraint:[self.iconCapthaImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:16.0f]];
    [self.contentScrollView addConstraint:[self.iconCapthaImageView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.captchaTextField]];
//    [self.contentScrollView addConstraint:[self.onceAgainButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.mobileTextField withOffset:9.0f]];
    [self.contentScrollView addConstraint:[self.passwordTextField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.captchaTextField]];
    [self.contentScrollView addConstraint:[self.iconRetrievePasswordImageView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.iconCapthaImageView]];
    [self.contentScrollView addConstraint:[self.iconRetrievePasswordImageView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.passwordTextField]];
    [self.contentScrollView addConstraint:[self.confirmTextField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.passwordTextField]];
    [self.contentScrollView addConstraint:[self.iconConfrimRetrievePasswordImageView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.iconCapthaImageView]];
    [self.contentScrollView addConstraint:[self.iconConfrimRetrievePasswordImageView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.confirmTextField]];
    [self.contentScrollView addConstraint:[self.nextButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.confirmTextField withOffset:30.0f]];
    
    [self.contentScrollView addConstraint:[line1 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.captchaTextField]];
    [self.contentScrollView addConstraint:[line2 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f]];
    [self.contentScrollView addConstraint:[line2 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.passwordTextField]];
    [self.contentScrollView addConstraint:[line3 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f]];
    [self.contentScrollView addConstraint:[line3 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.confirmTextField]];
    [self.contentScrollView addConstraint:[line4 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.confirmTextField]];
}


#pragma mark - Property

- (UIScrollView *)contentScrollView
{
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] init];
    }
    return _contentScrollView;
}

//- (EXUITextField *)mobileTextField
//{
//    if (!_mobileTextField) {
//        _mobileTextField = [[SkinManager sharedInstance] createDefaultTextField];
//        _mobileTextField.keyboardType = UIKeyboardTypeNumberPad;
//        _mobileTextField.delegate = self;
//        [_mobileTextField setPlaceholder:@"手机号码"];
//    }
//    return _mobileTextField;
//}

- (EXUITextField *)captchaTextField
{
    if (!_captchaTextField) {
        _captchaTextField = [[SkinManager sharedInstance] createDefaultEXUITextField];
        _captchaTextField.keyboardType = UIKeyboardTypeNumberPad;
        _captchaTextField.delegate = self;
        _captchaTextField.textEdgeInsets = UIEdgeInsetsMake(0.0f, 48.0f, 0.0f, 14.0f);
        _captchaTextField.layer.borderWidth = 0.0f;
        [_captchaTextField setPlaceholder:@"输入手机短信中的验证码"];
    }
    return _captchaTextField;
}

- (UIImageView *)iconCapthaImageView {
    
    if (!_iconCapthaImageView) {
        
        _iconCapthaImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_chapter@2x"]];
    }
    
    return _iconCapthaImageView;
}

//- (UIButton *)onceAgainButton
//{
//    if (!_onceAgainButton) {
//        _onceAgainButton = [[SkinManager sharedInstance] createDefaultButton];
//        _onceAgainButton.backgroundColor = UIColorFromRGB(0x9d9d9d);
//        [_onceAgainButton setTitleColor:[SkinManager sharedInstance].defaultWhiteColor forState:UIControlStateNormal];
//        [_onceAgainButton setTitle:@"获取验证码" forState:UIControlStateNormal];
//        [_onceAgainButton addTarget:self action:@selector(onceAgainButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _onceAgainButton;
//}

- (EXUITextField *)passwordTextField
{
    if (!_passwordTextField) {
        _passwordTextField = [[SkinManager sharedInstance] createDefaultEXUITextField];
        _passwordTextField.delegate = self;
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.textEdgeInsets = UIEdgeInsetsMake(0.0f, 48.0f, 0.0f, 14.0f);
        _passwordTextField.layer.borderWidth = 0.0f;
        [_passwordTextField setPlaceholder:@"新密码"];
    }
    return _passwordTextField;
}

- (UIImageView *)iconRetrievePasswordImageView {
    
    if (!_iconRetrievePasswordImageView) {
        
        _iconRetrievePasswordImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_retrieve_pwd"]];
    }
    
    return _iconRetrievePasswordImageView;
}

- (EXUITextField *)confirmTextField
{
    if (!_confirmTextField) {
        _confirmTextField = [[SkinManager sharedInstance] createDefaultEXUITextField];
        _confirmTextField.delegate = self;
        _confirmTextField.secureTextEntry = YES;
        _confirmTextField.textEdgeInsets = UIEdgeInsetsMake(0.0f, 48.0f, 0.0f, 14.0f);
        _confirmTextField.layer.borderWidth = 0.0f;
        [_confirmTextField setPlaceholder:@"再次输入新密码"];
    }
    return _confirmTextField;
}

- (UIImageView *)iconConfrimRetrievePasswordImageView {
    
    if (!_iconConfrimRetrievePasswordImageView) {
        
        _iconConfrimRetrievePasswordImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_retrieve_pwd"]];
    }
    
    return _iconConfrimRetrievePasswordImageView;
}

- (UIButton *)nextButton
{
    if (!_nextButton) {
        _nextButton = [[UIButton alloc] init];
        _nextButton.backgroundColor = UIColorFromRGB(0x33d2b4);
        [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextButton setTitle:@"确定" forState:UIControlStateNormal];
        _nextButton.layer.cornerRadius = 6.0f;
        _nextButton.titleLabel.font = [UIFont boldSystemFontOfSize:21.0f];
        [_nextButton addTarget:self action:@selector(nextButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
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


#pragma mark - Selector

//- (void)onceAgainButtonClicked:(UIButton *)button
//{
//    seconds = 60;
//    countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
//    
//    NSString *mobile = [self.mobileTextField text];
//    [[AccountManager sharedInstance] asyncGetCaptchaForRetrievePasswordWithMobile:mobile withCompletionHandler:^(BOOL isSuccess) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码已下发，请注意查收短信。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alertView show];
//    } withErrorHandler:^(NSError *error) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:[[error userInfo] objectForKey:NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alertView show];
//    }];
//}

- (void)nextButtonClicked:(UIButton *)button
{
//    if (countTimer) {
//        [countTimer invalidate];
//        countTimer = nil;
//        
////        [self.onceAgainButton setEnabled:YES];
////        [self.onceAgainButton setTitle:@"获取验证码" forState:UIControlStateNormal];
//    }
    
    NSString *captcha = [self.captchaTextField text];
    NSString *password = [self.passwordTextField text];
    NSString *confirmPassword = [self.confirmTextField text];
    
    if ([captcha length] == 0 || [password length] == 0 || [confirmPassword length] == 0) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码或密码不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return ;
    }
    
    if (![password isEqualToString:confirmPassword]) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码不一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return ;
    }
    
    [self.progressHUD show:YES];
    [[AccountManager sharedInstance] asyncRetrievePassword:confirmPassword withMobile:self.mobile withCaptcha:captcha withCompletionHandler:^(BOOL isSuccess) {
        [self.progressHUD hide:YES];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码修改成功，请重新登录" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        
    } withErrorHandler:^(NSError *error) {
        [self.progressHUD hide:YES];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:[[error userInfo] objectForKey:NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }];
}

- (void)viewTapGestureFired:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self.view endEditing:NO];
}

//- (void)textDidChangedNotificaton:(NSNotification *)notification
//{
//
//    BOOL isEnable;
//    isEnable = isEnable ? ([self.captchaTextField.text length] > 0) : NO;
//    isEnable = isEnable ? ([self.passwordTextField.text length] > 0) : NO;
//    isEnable = isEnable ? ([self.confirmTextField.text length] > 0) : NO;
//    [self.nextButton setEnabled:isEnable];
//}


#pragma mark - Private Method

- (UIView *)generateLineView {
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = UIColorFromRGB(0xd4d4d4);
    return line;
}

//- (void)timerFireMethod:(NSTimer *)timer
//{
//    if (seconds == 1) {
//        [timer invalidate];
//        countTimer = nil;
//        [self.onceAgainButton setEnabled:YES];
//        [self.onceAgainButton setTitle:@"获取验证码" forState: UIControlStateNormal];
//    } else {
//        seconds--;
//        NSString *title = [NSString stringWithFormat:@"获取验证码(%d)", seconds];
//        [self.onceAgainButton setEnabled:NO];
//        [self.onceAgainButton setTitle:title forState:UIControlStateDisabled];
//    }
//}


#pragma mark - UITextFieldDelegate

//TODO how to 处理
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    if (textField == self.mobileTextField) {
//        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:kNumbers] invertedSet];
//        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
//        BOOL basic = [string isEqualToString:filtered];
//        return basic;
//    }
//    return YES;
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.captchaTextField == textField ||
        self.passwordTextField == textField || self.confirmTextField == textField) {
        [textField resignFirstResponder];
        return YES;
    }
    return NO;
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
