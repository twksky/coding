//
//  SupplementViewController.m
//  AppFramework
//
//  Created by ABC on 8/10/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "SupplementViewController.h"
#import "SkinManager.h"
#import "UIView+AutoLayout.h"
#import "UIViewController+Util.h"
#import "AccountManager.h"
#import "MBProgressHUD.h"

@interface SupplementViewController ()
<
UITextFieldDelegate,
MBProgressHUDDelegate,
UIAlertViewDelegate
>
{
    NSTimer     *countTimer;
    NSInteger   seconds;
}

@property (nonatomic, strong) UIScrollView                  *contentScrollView;
@property (nonatomic, strong) EXUITextField                 *mobileTextField;
@property (nonatomic, strong) EXUITextField                 *captchaTextField;
@property (nonatomic, strong) UIButton                      *onceAgainButton;
@property (nonatomic, strong) UIButton                      *nextButton;
@property (nonatomic, strong) MBProgressHUD                 *progressHUD;

- (void)setupSubviews;
- (void)setupConstraints;

- (void)onceAgainButtonClicked:(UIButton *)button;
- (void)nextButtonClicked:(UIButton *)button;
- (void)leftBarButtonItemClicked:(id)sender;

- (void)timerFireMethod:(NSTimer *)timer;

@end

@implementation SupplementViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"好医生账户资料";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [SkinManager sharedInstance].defaultViewBackgroundColor;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self setupSubviews];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapGestureFired:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClicked:)];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [[SkinManager sharedInstance] navigationRootViewControllerSizeToFit:self];
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
    [self.contentScrollView addSubview:self.mobileTextField];
    [self.contentScrollView addSubview:self.captchaTextField];
    [self.contentScrollView addSubview:self.onceAgainButton];
    [self.contentScrollView addSubview:self.nextButton];
    
    // Status
    [self.captchaTextField setEnabled:NO];
    [self.onceAgainButton setEnabled:NO];
    [self.nextButton setEnabled:NO];
    
    [self setupConstraints];
}

- (void)setupConstraints
{
    [self.view addConstraints:[self.contentScrollView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)]];
    
    [self.contentScrollView addConstraint:[self.mobileTextField autoSetDimension:ALDimensionHeight toSize:46.0f]];
    [self.contentScrollView addConstraint:[self.captchaTextField autoSetDimension:ALDimensionHeight toSize:46.0f]];
    [self.contentScrollView addConstraint:[self.onceAgainButton autoSetDimension:ALDimensionWidth toSize:150.0f]];
    [self.contentScrollView addConstraint:[self.onceAgainButton autoSetDimension:ALDimensionHeight toSize:46.0f]];
    [self.contentScrollView addConstraint:[self.nextButton autoSetDimension:ALDimensionHeight toSize:45.0f]];
    
    [self.contentScrollView addConstraint:[self.mobileTextField autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentScrollView withOffset:10.0f]];
    [self.contentScrollView addConstraint:[self.mobileTextField autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentScrollView withOffset:10.0f]];
    [self.contentScrollView addConstraint:[self.mobileTextField autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentScrollView withOffset:-10.0f]];
    [self.contentScrollView addConstraint:[self.onceAgainButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentScrollView withOffset:-10.0f]];
    [self.contentScrollView addConstraint:[self.nextButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentScrollView withOffset:-10.0f]];
    [self.contentScrollView addConstraint:[self.nextButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentScrollView withOffset:10.0f]];
    [self.contentScrollView addConstraint:[self.captchaTextField autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentScrollView withOffset:10.0f]];
    [self.contentScrollView addConstraint:[self.captchaTextField autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.onceAgainButton withOffset:-10.0f]];
    [self.contentScrollView addConstraint:[self.captchaTextField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.mobileTextField withOffset:9.0f]];
    [self.contentScrollView addConstraint:[self.onceAgainButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.mobileTextField withOffset:9.0f]];
    [self.contentScrollView addConstraint:[self.nextButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.captchaTextField withOffset:9.0f]];
}


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
        _mobileTextField = [[SkinManager sharedInstance] createDefaultTextField];
        _mobileTextField.keyboardType = UIKeyboardTypeNumberPad;
        _mobileTextField.delegate = self;
        [_mobileTextField setPlaceholder:@"手机号码"];
    }
    return _mobileTextField;
}

- (EXUITextField *)captchaTextField
{
    if (!_captchaTextField) {
        _captchaTextField = [[SkinManager sharedInstance] createDefaultTextField];
        _captchaTextField.keyboardType = UIKeyboardTypeNumberPad;
        _captchaTextField.delegate = self;
        [_captchaTextField setPlaceholder:@"请输入验证码"];
    }
    return _captchaTextField;
}

- (UIButton *)onceAgainButton
{
    if (!_onceAgainButton) {
        _onceAgainButton = [[SkinManager sharedInstance] createDefaultButton];
        _onceAgainButton.backgroundColor = UIColorFromRGB(0x9d9d9d);
        [_onceAgainButton setTitleColor:[SkinManager sharedInstance].defaultWhiteColor forState:UIControlStateNormal];
        [_onceAgainButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_onceAgainButton addTarget:self action:@selector(onceAgainButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _onceAgainButton;
}

- (UIButton *)nextButton
{
    if (!_nextButton) {
        _nextButton = [[SkinManager sharedInstance] createDefaultButton];
        _nextButton.backgroundColor = [SkinManager sharedInstance].defaultHighlightBackgroundColor;
        [_nextButton setTitleColor:[SkinManager sharedInstance].defaultWhiteColor forState:UIControlStateNormal];
        [_nextButton setTitle:@"确定" forState:UIControlStateNormal];
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
        _progressHUD.detailsLabelText = @"首次登录，正在验证并生成您的账户资料，大概需要10-20秒左右时间，请耐心等待...";
    }
    return _progressHUD;
}


#pragma mark - Selector

- (void)onceAgainButtonClicked:(UIButton *)button
{
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
    
    NSString *mobile = [self.mobileTextField text];
    NSString *captcha = [self.captchaTextField text];
    [self.progressHUD show:YES];
    [[AccountManager sharedInstance] asyncUploadHaoyishengMobile:mobile withCaptcha:captcha withCompletionHandler:^(Account *account) {
        [self.progressHUD hide:YES];
        
        if ([self.delegate respondsToSelector:@selector(supplementViewControllerDidSuccessSupplement:)]) {
            [self.delegate supplementViewControllerDidSuccessSupplement:self];
        }
    } withErrorHandler:^(NSError *error) {
        [self.progressHUD hide:YES];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:[[error userInfo] objectForKey:NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }];
}

- (void)leftBarButtonItemClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
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
    [self.nextButton setEnabled:isEnable];
}


#pragma mark - Private Method

- (void)timerFireMethod:(NSTimer *)timer
{
    if (seconds == 1) {
        [timer invalidate];
        countTimer = nil;
        [self.onceAgainButton setEnabled:YES];
        [self.onceAgainButton setTitle:@"获取验证码" forState: UIControlStateNormal];
    } else {
        seconds--;
        NSString *title = [NSString stringWithFormat:@"获取验证码(%ld)", (long)seconds];
        [self.onceAgainButton setEnabled:NO];
        [self.onceAgainButton setTitle:title forState:UIControlStateDisabled];
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
    if (self.mobileTextField == textField || self.captchaTextField == textField) {
        [textField resignFirstResponder];
        return YES;
    }
    return NO;
}
@end
