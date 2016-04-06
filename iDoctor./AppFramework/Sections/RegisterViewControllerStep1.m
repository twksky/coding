//
//  RegisterViewControllerStep1.m
//  AppFramework
//
//  Created by ABC on 6/2/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "RegisterViewControllerStep1.h"
#import "RegisterViewControllerStep2.h"
#import "SkinManager.h"
#import "UIView+AutoLayout.h"
#import "AccountManager.h"
#import "DDAlertPrompt.h"
#import "MBProgressHUD.h"

@interface RegisterViewControllerStep1 () <UITextFieldDelegate, MBProgressHUDDelegate>
{
    NSTimer     *countTimer;
    NSInteger   seconds;
}

@property (nonatomic, strong) UIScrollView                  *contentScrollView;
@property (nonatomic, strong) EXUITextField                 *mobileTextField;
@property (nonatomic, strong) EXUITextField                 *captchaTextField;
@property (nonatomic, strong) UIButton                      *onceAgainButton;
@property (nonatomic, strong) EXUITextField                 *nameTextField;
@property (nonatomic, strong) EXUITextField                 *passwordTextField;
@property (nonatomic, strong) EXUITextField                 *confirmTextField;
@property (nonatomic, strong) UIButton                      *nextButton;
@property (nonatomic, strong) MBProgressHUD                 *progressHUD;

@property (nonatomic, strong) Account                       *accountCache;

- (void)navBarBackItemClicked:(UIBarButtonItem *)item;
- (void)onceAgainButtonClicked:(UIButton *)button;
- (void)nextButtonClicked:(UIButton *)button;
- (void)viewTapGestureFired:(UITapGestureRecognizer *)tapGestureRecognizer;
- (void)textDidChangedNotificaton:(NSNotification *)notification;
- (void)timerFireMethod:(NSTimer *)timer;

- (void)setupSubviews;
- (void)setupConstraints;

@end

@implementation RegisterViewControllerStep1

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
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(0xeef1f2);
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self setNavigationBarWithTitle:@"注册1/2" leftBarButtonItem:[self makeLeftReturnBarButtonItem] rightBarButtonItem:nil];
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"icon_back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(navBarBackItemClicked:)];
    
    [self setupSubviews];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapGestureFired:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //[DaiDodgeKeyboard addRegisterTheViewNeedDodgeKeyboard:self.contentScrollView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChangedNotificaton:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //[DaiDodgeKeyboard removeRegisterTheViewNeedDodgeKeyboard];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [[SkinManager sharedInstance] navigationRootViewControllerSizeToFit:self];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
}

#pragma mark - override parent methods

- (void)returnPreviousViewController {
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
    }
    return _contentScrollView;
}

- (EXUITextField *)mobileTextField
{
    if (!_mobileTextField) {
        _mobileTextField = [[EXUITextField alloc] init];
        _mobileTextField.backgroundColor = [UIColor whiteColor];
        _mobileTextField.textEdgeInsets = UIEdgeInsetsMake(0.0f, 14.0f, 0.0f, 14.0f);
        _mobileTextField.keyboardType = UIKeyboardTypeNumberPad;
        _mobileTextField.font = [UIFont systemFontOfSize:18.0f];
        _mobileTextField.delegate = self;
        [_mobileTextField setPlaceholder:@"手机号码"];
#ifdef DEBUG_TEST
        [_mobileTextField setText:@"15801645376"];
#endif
    }
    return _mobileTextField;
}

- (EXUITextField *)captchaTextField
{
    if (!_captchaTextField) {
        _captchaTextField = [[EXUITextField alloc] init];
        _captchaTextField.backgroundColor = [UIColor whiteColor];
        _captchaTextField.textEdgeInsets = UIEdgeInsetsMake(0.0f, 14.0f, 0.0f, 14.0f);
        _captchaTextField.keyboardType = UIKeyboardTypeNumberPad;
        _mobileTextField.font = [UIFont systemFontOfSize:18.0f];
        _captchaTextField.delegate = self;
        [_captchaTextField setPlaceholder:@"请输入验证码"];
#ifdef DEBUG_TEST
        [_captchaTextField setText:@"20140712"];
#endif
    }
    return _captchaTextField;
}

- (UIButton *)onceAgainButton
{
    if (!_onceAgainButton) {
        _onceAgainButton = [[UIButton alloc] init];
        _onceAgainButton.layer.cornerRadius = 6.0f;
        _onceAgainButton.backgroundColor = UIColorFromRGB(0xff6767);
        [_onceAgainButton setTitleColor:[SkinManager sharedInstance].defaultWhiteColor forState:UIControlStateNormal];
        [_onceAgainButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_onceAgainButton addTarget:self action:@selector(onceAgainButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _onceAgainButton;
}

- (EXUITextField *)nameTextField
{
    if (!_nameTextField) {
        _nameTextField = [[EXUITextField alloc] init];
        _nameTextField.backgroundColor = [UIColor whiteColor];
        _nameTextField.textEdgeInsets = UIEdgeInsetsMake(0.0f, 14.0f, 0.0f, 14.0f);
        _nameTextField.delegate = self;
        [_nameTextField setPlaceholder:@"真实姓名"];
#ifdef DEBUG_TEST
        [_nameTextField setText:@"Kevin"];
#endif
    }
    return _nameTextField;
}

- (EXUITextField *)passwordTextField
{
    if (!_passwordTextField) {
        _passwordTextField = [[EXUITextField alloc] init];
        _passwordTextField.backgroundColor = [UIColor whiteColor];
        _passwordTextField.textEdgeInsets = UIEdgeInsetsMake(0.0f, 14.0f, 0.0f, 14.0f);
        _passwordTextField.delegate = self;
        _passwordTextField.secureTextEntry = YES;
        [_passwordTextField setPlaceholder:@"密码"];
#ifdef DEBUG_TEST
        [_passwordTextField setText:@"15801645376"];
#endif
    }
    return _passwordTextField;
}

- (EXUITextField *)confirmTextField
{
    if (!_confirmTextField) {
        _confirmTextField = [[EXUITextField alloc] init];
        _confirmTextField.backgroundColor = [UIColor whiteColor];
        _confirmTextField.textEdgeInsets = UIEdgeInsetsMake(0.0f, 14.0f, 0.0f, 14.0f);
        _confirmTextField.delegate = self;
        _confirmTextField.secureTextEntry = YES;
        [_confirmTextField setPlaceholder:@"再次输入密码"];
#ifdef DEBUG_TEST
        [_confirmTextField setText:@"15801645376"];
#endif
    }
    return _confirmTextField;
}

- (UIButton *)nextButton
{
    if (!_nextButton) {
        _nextButton = [[UIButton alloc] init];
        _nextButton.layer.cornerRadius = 6.0f;
        _nextButton.backgroundColor = UIColorFromRGB(0x34d2b4);
        [_nextButton setTitleColor:[SkinManager sharedInstance].defaultWhiteColor forState:UIControlStateNormal];
        [_nextButton setTitle:@"还有两步完成注册" forState:UIControlStateNormal];
        _nextButton.titleLabel.font = [UIFont systemFontOfSize:19.0f];
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

- (Account *)accountCache
{
    if (!_accountCache) {
        _accountCache = [[Account alloc] init];
    }
    return _accountCache;
}


#pragma mark - Selector

- (void)navBarBackItemClicked:(UIBarButtonItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onceAgainButtonClicked:(UIButton *)button
{
    
    NSLog(@"sadfsafsaf");
    
    seconds = 60;
    countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    
    NSString *mobile = [self.mobileTextField text];
    [[AccountManager sharedInstance] asyncGetCaptchaWithMobile:mobile withCompletionHandler:^(BOOL isSuccess) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码已下发，请注意查收短信。" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    } withErrorHandler:^(NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:[[error userInfo] objectForKey:NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }];
}

- (void)nextButtonClicked:(UIButton *)button
{
    if (countTimer) {
        [countTimer invalidate];
        countTimer = nil;
        
        [self.onceAgainButton setEnabled:YES];
        [self.onceAgainButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
	[self.progressHUD show:YES];
    self.accountCache.mobile = [self.mobileTextField text];
    NSString *captcha = [self.captchaTextField text];
    NSString *password = [self.passwordTextField text];
    NSString *confirmPassword = [self.confirmTextField text];
    self.accountCache.realName = [self.nameTextField text];
    
    if (![password isEqualToString:confirmPassword]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码不一致" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        return ;
    }
    
    //TODO 处理注册逻辑
    [[AccountManager sharedInstance] asyncRegisterAccountWithMobile:self.accountCache.mobile withPassword:password withConfirmPassword:confirmPassword withRealName:self.accountCache.realName withCaptcha:captcha withCompletionHandler:^(Account *account) {
        [self.progressHUD hide:YES];
        
        self.accountCache.easemobPassword   = account.easemobPassword;
        self.accountCache.accountID         = account.accountID;
        self.accountCache.loginName         = account.loginName;
        self.accountCache.isOnline          = account.isOnline;
        self.accountCache.token             = account.token;
        
        RegisterViewControllerStep2 *registerViewControllerStep2 = [[RegisterViewControllerStep2 alloc] initWithAccount:self.accountCache];
        [self.navigationController pushViewController:registerViewControllerStep2 animated:YES];
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

- (void)textDidChangedNotificaton:(NSNotification *)notification
{
    BOOL isEnable = [self.mobileTextField.text length] > 0;
    if ([notification object] == self.mobileTextField) {
        // 检测电话号码
        [self.captchaTextField setEnabled:isEnable];
        [self.onceAgainButton setEnabled:isEnable];
    }
    isEnable = isEnable ? ([self.captchaTextField.text length] > 0) : NO;
    isEnable = isEnable ? ([self.nameTextField.text length] > 0) : NO;
    isEnable = isEnable ? ([self.passwordTextField.text length] > 0) : NO;
    isEnable = isEnable ? ([self.confirmTextField.text length] > 0) : NO;
    [self.nextButton setEnabled:isEnable];
}

- (void)timerFireMethod:(NSTimer *)timer
{
    if (seconds == 1) {
        [timer invalidate];
        countTimer = nil;
        [self.onceAgainButton setEnabled:YES];
        [self.onceAgainButton setTitle:@"获取验证码" forState: UIControlStateNormal];
    } else {
        seconds--;
        NSString *title = [NSString stringWithFormat:@"获取验证码(%ld)", seconds];
        [self.onceAgainButton setEnabled:NO];
        [self.onceAgainButton setTitle:title forState:UIControlStateDisabled];
    }
}


#pragma mark - Private Method

- (void)setupSubviews
{
    [self.view addSubview:self.contentScrollView];
    
    UIView *line1 = [self generateLineView];
    UIView *line2 = [self generateLineView];
    UIView *line3 = [self generateLineView];
    UIView *line4 = [self generateLineView];
    UIView *line5 = [self generateLineView];
    UIView *line6 = [self generateLineView];
    UIView *line7 = [self generateLineView];
    UIView *line8 = [self generateLineView];
    
    [self.contentScrollView addSubview:line1];
    [self.contentScrollView addSubview:self.mobileTextField];
    [self.contentScrollView addSubview:line2];
    [self.contentScrollView addSubview:self.captchaTextField];
    [self.contentScrollView addSubview:line3];
    [self.contentScrollView addSubview:self.onceAgainButton];
    [self.contentScrollView addSubview:line4];
    [self.contentScrollView addSubview:self.nameTextField];
    [self.contentScrollView addSubview:line5];
    [self.contentScrollView addSubview:line6];
    [self.contentScrollView addSubview:self.passwordTextField];
    [self.contentScrollView addSubview:line7];
    [self.contentScrollView addSubview:self.confirmTextField];
    [self.contentScrollView addSubview:line8];
    [self.contentScrollView addSubview:self.nextButton];
    
    [self.contentScrollView bringSubviewToFront:line2];
    [self.contentScrollView bringSubviewToFront:line3];
    [self.contentScrollView bringSubviewToFront:line4];
    [self.contentScrollView bringSubviewToFront:line5];
    [self.contentScrollView bringSubviewToFront:line6];
    [self.contentScrollView bringSubviewToFront:line7];
    [self.contentScrollView bringSubviewToFront:line8];
    
    // Status
    [self.captchaTextField setEnabled:NO];
    [self.onceAgainButton setEnabled:NO];
    [self.nextButton setEnabled:NO];
    
    [self.contentScrollView bringSubviewToFront:self.onceAgainButton];
    
//    setupConstraints
    
    [self.view addConstraints:[self.contentScrollView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)]];
    
    [self.contentScrollView addConstraints:[line1 autoSetDimensionsToSize:CGSizeMake(App_Frame_Width, 0.7f)]];
    [self.contentScrollView addConstraints:[line2 autoSetDimensionsToSize:CGSizeMake(App_Frame_Width * 0.95f, 0.7f)]];
    [self.contentScrollView addConstraints:[line3 autoSetDimensionsToSize:CGSizeMake(App_Frame_Width, 0.7f)]];
    [self.contentScrollView addConstraints:[line4 autoSetDimensionsToSize:CGSizeMake(App_Frame_Width, 0.7f)]];
    [self.contentScrollView addConstraints:[line5 autoSetDimensionsToSize:CGSizeMake(App_Frame_Width, 0.7f)]];
    [self.contentScrollView addConstraints:[line6 autoSetDimensionsToSize:CGSizeMake(App_Frame_Width, 0.7f)]];
    [self.contentScrollView addConstraints:[line7 autoSetDimensionsToSize:CGSizeMake(App_Frame_Width * 0.95f, 0.7f)]];
    [self.contentScrollView addConstraints:[line8 autoSetDimensionsToSize:CGSizeMake(App_Frame_Width, 0.7f)]];
    [self.contentScrollView addConstraints:[self.mobileTextField autoSetDimensionsToSize:CGSizeMake(App_Frame_Width, 52.0f)]];
    [self.contentScrollView addConstraint:[self.captchaTextField autoSetDimension:ALDimensionHeight toSize:52.0f]];
    [self.contentScrollView addConstraint:[self.onceAgainButton autoSetDimension:ALDimensionWidth toSize:130.0f]];
    [self.contentScrollView addConstraint:[self.onceAgainButton autoSetDimension:ALDimensionHeight toSize:40.0f]];
    [self.contentScrollView addConstraint:[self.nameTextField autoSetDimension:ALDimensionHeight toSize:52.0f]];
    [self.contentScrollView addConstraint:[self.passwordTextField autoSetDimension:ALDimensionHeight toSize:52.0f]];
    [self.contentScrollView addConstraint:[self.confirmTextField autoSetDimension:ALDimensionHeight toSize:52.0f]];
    [self.contentScrollView addConstraint:[self.nextButton autoSetDimension:ALDimensionHeight toSize:50.0f]];
    
    [self.contentScrollView addConstraint:[line1 autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:25.0f]];
    [self.contentScrollView addConstraint:[self.mobileTextField autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentScrollView withOffset:0.0f]];
    [self.contentScrollView addConstraint:[self.mobileTextField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:line1]];
    [self.contentScrollView addConstraint:[self.mobileTextField autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentScrollView withOffset:0.0f]];
    [self.contentScrollView addConstraint:[line2 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.mobileTextField]];
    [self.contentScrollView addConstraint:[line2 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f]];
    [self.contentScrollView addConstraint:[self.onceAgainButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.mobileTextField withOffset:-10.0f]];
    [self.contentScrollView addConstraint:[self.nameTextField autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.mobileTextField withOffset:0.0f]];
    [self.contentScrollView addConstraint:[self.passwordTextField autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.mobileTextField withOffset:0.0f]];
    [self.contentScrollView addConstraint:[self.confirmTextField autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.mobileTextField withOffset:0.0f]];
    [self.contentScrollView addConstraint:[self.nextButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.mobileTextField withOffset:-10.0f]];
    [self.contentScrollView addConstraint:[self.nextButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentScrollView withOffset:10.0f]];
    [self.contentScrollView addConstraint:[self.confirmTextField autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentScrollView withOffset:0.0f]];
    [self.contentScrollView addConstraint:[self.passwordTextField autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentScrollView withOffset:0.0f]];
    [self.contentScrollView addConstraint:[self.nameTextField autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentScrollView withOffset:0.0f]];
    [self.contentScrollView addConstraint:[self.captchaTextField autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentScrollView withOffset:0.0f]];
    [self.contentScrollView addConstraint:[self.captchaTextField autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentScrollView withOffset:0.0f]];
    [self.contentScrollView addConstraint:[self.captchaTextField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.mobileTextField withOffset:0.0f]];
    [self.contentScrollView addConstraint:[self.onceAgainButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.mobileTextField withOffset:6.0f]];
    [self.contentScrollView addConstraint:[self.nameTextField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.captchaTextField withOffset:15.0f]];
    [self.contentScrollView addConstraint:[self.passwordTextField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.nameTextField withOffset:15.0f]];
    [self.contentScrollView addConstraint:[self.confirmTextField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.passwordTextField withOffset:0.0f]];
    [self.contentScrollView addConstraint:[self.nextButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.confirmTextField withOffset:20.0f]];
    
    [self.contentScrollView addConstraint:[line3 autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.captchaTextField]];
    [self.contentScrollView addConstraint:[line4 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.nameTextField]];
    [self.contentScrollView addConstraint:[line5  autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.nameTextField]];
    [self.contentScrollView addConstraint:[line6  autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.passwordTextField]];
    [self.contentScrollView addConstraint:[line7  autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.passwordTextField]];
    [self.contentScrollView addConstraint:[line7 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f]];
    [self.contentScrollView addConstraint:[line8  autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.confirmTextField]];
}

- (UIView *)generateLineView {
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = UIColorFromRGB(0xd4d4d4);
    return line;
}


#pragma mark - MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    if (hud) {

    }
}


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.mobileTextField) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:kNumbers] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basic = [string isEqualToString:filtered];
        return basic;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.mobileTextField == textField || self.captchaTextField == textField || self.nameTextField == textField ||
        self.passwordTextField == textField || self.confirmTextField == textField) {
        [textField resignFirstResponder];
        return YES;
    }
    return NO;
}

@end
