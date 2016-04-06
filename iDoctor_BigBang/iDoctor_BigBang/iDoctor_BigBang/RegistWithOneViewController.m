//
//  RegistWithOneViewController.m
//  iDoctor_BigBang
//
//  Created by 周世阳 on 15/9/29.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import "AccountManager.h"
#import "RegistWithOneViewController.h"
#import "RegistTwoBaseInfoViewController.h"
#import "UIImage+Extension.h"
#import <Masonry.h>
#import "IDRegistFieldView.h"

@interface RegistWithOneViewController ()
<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *phoneLable;
@property (nonatomic, strong) IDRegistFieldView *phoneTextField;
@property (nonatomic, strong) UILabel *capcharLabel;
@property (nonatomic, strong) UITextField *capcharTextField;
@property (nonatomic, strong) UIButton *capcharButton;
@property (nonatomic, strong) UILabel *newPasswordLabel;
@property (nonatomic, strong) IDRegistFieldView *newPasswordField;
@property (nonatomic, strong) UILabel *rePasswordLabel;
@property (nonatomic, strong) IDRegistFieldView *rePasswordTextField;
@property (nonatomic, strong) UIButton *nextButton;

@end

@implementation RegistWithOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    
    [self setupViews];
}

#pragma mark -
// 背景的control的点击事件
- (void)resignResponder:(UIControl *)control
{
    [self.phoneTextField resignFirstResponder];
    [self.capcharTextField resignFirstResponder];
    [self.newPasswordField resignFirstResponder];
    [self.rePasswordTextField resignFirstResponder];
    
}

- (void)setupViews {
    
    self.navigationItem.title = @"注册";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *contentView = self.view;
    
    // 加上一个相应的大背景的controller
    UIControl *control = [[UIControl alloc] init];
    control.backgroundColor = [UIColor clearColor];
    [control addTarget:self action:@selector(resignResponder:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:control];
    [control mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(contentView);
        
    }];
    
    [contentView addSubview:self.phoneLable];
    [self.phoneLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(contentView).with.offset(15.0f);
        make.top.equalTo(contentView);
        make.height.equalTo(60.0f);
        make.width.equalTo(85.0f);
    }];
    
    [contentView addSubview:self.phoneTextField];
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.phoneLable.right);
        make.top.equalTo(contentView);
        make.height.equalTo(60.0f);
        make.right.equalTo(contentView).with.offset(-15.0f);
    }];
    
    UIView *lineOne = [self commonLine];
    [contentView addSubview:lineOne];
    [lineOne mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.height.equalTo(0.7f);
        make.top.equalTo(self.phoneLable.bottom);
    }];
    
    [contentView addSubview:self.capcharLabel];
    [self.capcharLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(lineOne.bottom);
        make.left.equalTo(contentView).with.offset(15.0f);
        make.width.equalTo(85.0f);
        make.height.equalTo(60.0f);
    }];
    
    [contentView addSubview:self.capcharButton];
    [self.capcharButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(lineOne.bottom);
        make.right.equalTo(contentView);
        make.width.equalTo(100.0f);
        make.height.equalTo(60.0f);
    }];
    
    [contentView addSubview:self.capcharTextField];
    [self.capcharTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(lineOne.bottom);
        make.left.equalTo(self.capcharLabel.right);
        make.right.equalTo(self.capcharButton.left);
        make.height.equalTo(60.0f);
    }];
    
    UIView *lineTwo = [self commonLine];
    [contentView addSubview:lineTwo];
    [lineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.capcharLabel.bottom);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.height.equalTo(0.5f);
    }];
    
    [contentView addSubview:self.newPasswordLabel];
    [self.newPasswordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(contentView).with.offset(15.0f);
        make.top.equalTo(self.capcharLabel.bottom);
        make.height.equalTo(60.0f);
        make.width.equalTo(85.0f);
    }];
    
    [contentView addSubview:self.newPasswordField];
    [self.newPasswordField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.newPasswordLabel.right);
        make.top.equalTo(lineTwo.bottom);
        make.height.equalTo(60.0f);
        make.right.equalTo(contentView);
    }];
    
    UIView *lineThree = [self commonLine];
    [contentView addSubview:lineThree];
    [lineThree mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.newPasswordLabel.bottom);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.height.equalTo(0.5f);
    }];
    
    [contentView addSubview:self.rePasswordLabel];
    [self.rePasswordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(contentView).with.offset(15.0f);
        make.top.equalTo(lineThree.bottom);
        make.height.equalTo(60.0f);
        make.width.equalTo(85.0f);
    }];
    
    [contentView addSubview:self.rePasswordTextField];
    [self.rePasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.rePasswordLabel.right);
        make.top.equalTo(lineThree.bottom);
        make.height.equalTo(60.0f);
        make.right.equalTo(contentView);
    }];
    
    UIView *lineFour = [self commonLine];
    [contentView addSubview:lineFour];
    [lineFour mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.rePasswordLabel.bottom);
        make.left.equalTo(contentView);
        make.right.equalTo(contentView);
        make.height.equalTo(0.5f);
    }];
    
    [contentView addSubview:self.nextButton];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(contentView).with.offset(15.0f);
        make.right.equalTo(contentView).with.offset(-15.0f);
        make.bottom.equalTo(contentView).with.offset(-15.0f);
        make.height.equalTo(50.0f);
    }];
}


#pragma mark - Selectors
- (void)toNextVC {
   
    NSString *mobile = self.phoneTextField.text;
    if (![self isValidMobile:mobile]) {
        
        [self showWarningAlertWithTitle:@"提示" withMessage:@"手机号非法, 请重新输入"];
        
        return;
    }
    
    NSString *captcha = self.capcharTextField.text;
    if (!captcha || captcha.length == 0) {
        
        [self showWarningAlertWithTitle:@"提示" withMessage:@"验证码不能为空"];
        return;
    }
    
    NSString *newPassword = self.newPasswordField.text;
    NSString *rePassoword = self.rePasswordTextField.text;
    if (!newPassword ||
        newPassword.length == 0||
        !rePassoword ||
        rePassoword.length == 0) {
        
        [self showWarningAlertWithTitle:@"提示" withMessage:@"密码不能为空"];
        return;
    }
    
    if (newPassword.length < 6 || rePassoword.length < 6) {
        
        [self showWarningAlertWithTitle:@"提示" withMessage:@"密码不能小于6位"];
        return;
    } else if (newPassword.length > 12 || rePassoword.length > 12) {
        [self showWarningAlertWithTitle:@"提示" withMessage:@"密码不能大于12位"];
        return;
    }
    
    if (![newPassword isEqualToString:rePassoword]) {
        
        [self showWarningAlertWithTitle:@"提示" withMessage:@"两次密码不一致"];
        return;
    }
    
    
    NSDictionary *diction = @{@"mobile":mobile, @"captcha":captcha, @"password":newPassword.md5String};
    
    
    [self showLoading];
    
    [[AccountManager sharedInstance] registOneWithMobile:mobile captcha:captcha withCompletionHandler:^(BOOL isSuccess) {
        
        [self hideLoading];
       
        RegistTwoBaseInfoViewController *twoBaseInfo = [[RegistTwoBaseInfoViewController alloc] init];
        twoBaseInfo.oneDiction = diction;
        
        [self.navigationController pushViewController:twoBaseInfo animated:YES];

    } withErrorHandler:^(NSError *error) {
        
        [self hideLoading];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:error.localizedDescription delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
    }];

}

- (void)requestCaptchar {
    
    NSString *mobile = self.phoneTextField.text;
    if (![self isValidMobile:mobile]) {
        
        [self showWarningAlertWithTitle:@"提示" withMessage:@"非法手机号"];
        return;
    }
    
    [self showLoading];
    [[AccountManager sharedInstance] requestChapterWithMobile:mobile withCompletionHandler:^{
        
        [self hideLoading];
        [self showTips:@"验证码已发送"];
        [self verifyTime];
        
    } withErrorHandler:^(NSError *error) {
        
        [self hideLoading];
        [self handleError:error];
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *mobile = self.phoneTextField.text;
    NSString *capchar = self.capcharTextField.text;
    NSString *newPassword = self.newPasswordField.text;
    NSString *rePassword = self.rePasswordTextField.text;
    
    if (string.length > 0 &&
        ((mobile && mobile.length != 0) || textField == self.phoneTextField) &&
        ((capchar && capchar.length != 0) || textField == self.capcharTextField) &&
        ((newPassword && newPassword.length != 0) || textField == self.newPasswordField) &&
        ((rePassword && rePassword.length != 0) || textField == self.rePasswordTextField)) {
        
        self.nextButton.enabled = YES;
    } else if (
        (!mobile || mobile.length == 0 || (textField == self.phoneTextField && mobile.length == range.length)) ||
        (!capchar || capchar.length == 0 || (textField == self.capcharTextField && capchar.length == range.length)) ||
        (!newPassword || newPassword.length == 0 || (textField == self.newPasswordField && newPassword.length == range.length)) ||
        (!rePassword || rePassword.length == 0 || (textField == self.rePasswordTextField && rePassword.length == range.length))
        ) {
        
        self.nextButton.enabled = NO;
    }
    
    return YES;
}


#pragma mark -
//验证倒计时60秒
-(void)verifyTime{
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.capcharButton setTitle:@"发送验证码" forState:UIControlStateNormal];
                self.capcharButton.enabled = YES;
                //                self.verifyBtn.alpha = 1.f;
            });
        }else{
            int seconds = timeout % 61;
            NSString *strTime = [NSString stringWithFormat:@"重新发送(%d)",seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.capcharButton setTitle:strTime forState:UIControlStateNormal];
                self.capcharButton.enabled = NO;
                //                self.verifyBtn.titleLabel.alpha = 0.4f;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}



#pragma mark -
- (BOOL)isValidMobile:(NSString *)moblie {
    
    NSString *pattern = @"^1+\\d{10}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL phoneMatch = [pred evaluateWithObject:moblie];
    
    if (moblie.length != 11 || !phoneMatch) {
        
        return NO;
    }
    
    return YES;
}

#pragma mark -
- (UILabel *)commonLabel {
    
    UILabel *label = [[UILabel alloc] init];
    [label setTextColor:UIColorFromRGB(0xa8a8aa)];
    label.font = [UIFont systemFontOfSize:15.0f];
    
    return label;
}

- (UITextField *)commonFiled {
    
    UITextField *field = [[UITextField alloc] init];
    field.font = [UIFont systemFontOfSize:12.0f];
    field.textColor = UIColorFromRGB(0x353d3f);
    
    return field;
}

- (UIView *)commonLine {
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = UIColorFromRGB(0xeaeaea);
    return view;
}


#pragma mark - Properties
- (UILabel *)phoneLable {
    
    if(_phoneLable == nil) {
        
        _phoneLable = [self commonLabel];
        _phoneLable.text = @"手机号";
    }
    return _phoneLable;
}

- (IDRegistFieldView *)phoneTextField {
    
    if(_phoneTextField == nil) {
        
        _phoneTextField = [[IDRegistFieldView alloc] init];
        _phoneTextField.textColor = UIColorFromRGB(0x353d3f);
        _phoneTextField.font = [UIFont systemFontOfSize:15.0f];
        _phoneTextField.placeholder = @"11位数字";
        _phoneTextField.keyboardType = UIKeyboardTypePhonePad;
        _phoneTextField.delegate = self;
    }
    return _phoneTextField;
}

- (UILabel *)capcharLabel {
    
    if(_capcharLabel == nil) {
        
        _capcharLabel = [self commonLabel];
        _capcharLabel.text = @"验证码";
    }
    return _capcharLabel;
}

- (UITextField *)capcharTextField {
    
    if(_capcharTextField == nil) {
        
        _capcharTextField = [self commonFiled];
        _capcharTextField.placeholder = @"";
        _capcharTextField.delegate = self;
    }
    return _capcharTextField;
}

- (UIButton *)capcharButton {
    
    if(_capcharButton == nil) {
        
        _capcharButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_capcharButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        _capcharButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_capcharButton setTitleColor:UIColorFromRGB(0x36cacc) forState:UIControlStateNormal];
        [_capcharButton setTitleColor:UIColorFromRGB(0xcdcdce) forState:UIControlStateDisabled];
        [_capcharButton addTarget:self action:@selector(requestCaptchar) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _capcharButton;
}

- (UILabel *)newPasswordLabel {
    
    if(_newPasswordLabel == nil) {
        
        _newPasswordLabel = [self commonLabel];
        _newPasswordLabel.text = @"新的密码";
    }
    return _newPasswordLabel;
}

- (UITextField *)newPasswordField {
    
    if(_newPasswordField == nil) {
        
        _newPasswordField = [[IDRegistFieldView alloc] init];
        _newPasswordField.textColor = UIColorFromRGB(0x353d3f);
        _newPasswordField.font = [UIFont systemFontOfSize:15.0f];
        _newPasswordField.placeholder = @"6到12位数字或英文";
        _newPasswordField.secureTextEntry = YES;
        _newPasswordField.delegate = self;
    }
    return _newPasswordField;
}

- (UILabel *)rePasswordLabel {
    
    if(_rePasswordLabel == nil) {
        
        _rePasswordLabel = [self commonLabel];
        _rePasswordLabel.text = @"重复密码";
    }
    return _rePasswordLabel;
}

- (UITextField *)rePasswordTextField {
    if(_rePasswordTextField == nil) {
        
        _rePasswordTextField = [[IDRegistFieldView alloc] init];
        _rePasswordTextField.textColor = UIColorFromRGB(0x353d3f);
        _rePasswordTextField.font = [UIFont systemFontOfSize:15.0f];
        _rePasswordTextField.placeholder = @"6到12位数字或英文";
        _rePasswordTextField.secureTextEntry = YES;
        _rePasswordTextField.delegate = self;
    }
    return _rePasswordTextField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}



- (UIButton *)nextButton {
    
    if(_nextButton == nil) {
        
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setBackgroundImage:[UIImage createImageWithColor:UIColorFromRGB(0xcdcdce)] forState:UIControlStateDisabled];
        [_nextButton setBackgroundImage:[UIImage createImageWithColor:UIColorFromRGB(0x36cacc)] forState:UIControlStateNormal];
        [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        ViewRadius(_nextButton, 3.0f);
        _nextButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [_nextButton addTarget:self action:@selector(toNextVC) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}


@end
