//
//  BeforeRetrievePasswordViewController.m
//  AppFramework
//
//  Created by 周世阳 on 15/6/10.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "BeforeRetrievePasswordViewController.h"
#import <PureLayout.h>
#import "AccountManager.h"
#import "EXUITextField.h"
#import "RetrievePasswordViewController.h"

@interface BeforeRetrievePasswordViewController ()
<
UITextFieldDelegate,
RetrievePasswordViewControllerDelegate
>
{
    NSTimer     *countTimer;
    NSInteger   seconds;
}


@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) EXUITextField *phoneNumTextField;
@property (nonatomic, strong) UIButton *submitBtn;

@end

@implementation BeforeRetrievePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xedf2f1);
    
    [self setNavigationBarWithTitle:@"找回密码" leftBarButtonItem:[self makeLeftReturnBarButtonItem] rightBarButtonItem:nil];
    
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.phoneNumTextField];
    [self.view addSubview:self.submitBtn];
    
    [self.view addConstraint:[self.tipLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15.0f]];
    [self.view addConstraint:[self.tipLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20.0f]];
    
    [self.view addConstraints:[self.phoneNumTextField autoSetDimensionsToSize:CGSizeMake(App_Frame_Width + 1.0f, 52.0f)]];
    [self.view addConstraint:[self.phoneNumTextField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.tipLabel withOffset:15.0f]];
    [self.view addConstraint:[self.phoneNumTextField autoPinEdgeToSuperviewEdge:ALEdgeLeft]];
    
    [self.view addConstraints:[self.submitBtn autoSetDimensionsToSize:CGSizeMake(App_Frame_Width - 30.0f, 50.0f)]];
    [self.view addConstraint:[self.submitBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15.0f]];
    [self.view addConstraint:[self.submitBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.phoneNumTextField withOffset:20.0f]];
}

#pragma mark - override parent methods

- (void)returnPreviousViewController {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - selector

- (void)submitButtonClicked:(id)sender {
    
    if (!self.phoneNumTextField.text || self.phoneNumTextField.text.length == 0) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"号码不能为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    seconds = 60;  //TODO 暂时不要计时控制
    countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    
    NSString *mobile = [self.phoneNumTextField text];
    [[AccountManager sharedInstance] asyncGetCaptchaForRetrievePasswordWithMobile:mobile withCompletionHandler:^(BOOL isSuccess) {
    
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        RetrievePasswordViewController *rvc = [[RetrievePasswordViewController alloc] initWithMobile:mobile];
        rvc.delegate = self;
        [self.navigationController pushViewController:rvc animated:YES];
        
    } withErrorHandler:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:[[error userInfo] objectForKey:NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }];
    
//    if (countTimer) {
//        [countTimer invalidate];
//        countTimer = nil;
//        
//        [self.onceAgainButton setEnabled:YES];
//        [self.onceAgainButton setTitle:@"获取验证码" forState:UIControlStateNormal];
//    }
}

#pragma mark - Private Method

- (void)timerFireMethod:(NSTimer *)timer
{
    if (seconds == 1) {
        [timer invalidate];
        countTimer = nil;
        [self.submitBtn setEnabled:YES];
        [self.submitBtn setTitle:@"提交" forState: UIControlStateNormal];
    } else {
        seconds--;
        NSString *title = [NSString stringWithFormat:@"提交(%ld)", seconds];
        [self.submitBtn setEnabled:NO];
        [self.submitBtn setTitle:title forState:UIControlStateDisabled];
    }
}

#pragma mark - UITextFieldDelegate Methods


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:kNumbers] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basic = [string isEqualToString:filtered];
    
    return basic;
}

#pragma mark - RetrievePasswordViewControllerDelegate Methods

- (void)RetrievePasswordSuccess {
    
    //TODO
}

#pragma mark - properties

- (UILabel *)tipLabel {
    
    if (!_tipLabel) {
        
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = @"请输入你注册时填写的手机号码";
        _tipLabel.textColor = UIColorFromRGB(0x8e8f94);
        _tipLabel.font = [UIFont systemFontOfSize:13.0f];
    }
    
    return _tipLabel;
}

- (EXUITextField *)phoneNumTextField {
    
    if (!_phoneNumTextField) {
        
        _phoneNumTextField = [[EXUITextField alloc] init];
        _phoneNumTextField.placeholder = @"手机号码";
        _phoneNumTextField.backgroundColor = [UIColor whiteColor];
        _phoneNumTextField.layer.borderWidth = 0.7f;
        _phoneNumTextField.layer.borderColor = [UIColorFromRGB(0xd4d4d4) CGColor];
        _phoneNumTextField.textEdgeInsets = UIEdgeInsetsMake(0.0f, 14.0f, 0.0f, 14.0f);
        _phoneNumTextField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneNumTextField.delegate = self;
    }
    
    return _phoneNumTextField;
}

- (UIButton *)submitBtn {
    
    if (!_submitBtn) {
        
        _submitBtn = [[UIButton alloc] init];
        _submitBtn.backgroundColor = UIColorFromRGB(0x33d2b4);
        _submitBtn.layer.cornerRadius = 6.0f;
        [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
        _submitBtn.titleLabel.font = [UIFont systemFontOfSize:19.0f];
        [_submitBtn addTarget:self action:@selector(submitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _submitBtn;
}

@end















