//
//  IDResetPasswordViewController.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/11/5.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDResetPasswordViewController.h"
#import "AccountManager.h"

@interface IDResetPasswordViewController ()

@property (nonatomic, strong) UITextField *oldTextField;

@property (nonatomic, strong) UITextField *newpasswordTextField;

@property (nonatomic, strong) UITextField *reNewTextField;

@end

@implementation IDResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    self.view.backgroundColor = UIColorFromRGB(0xf8f8f8);
    [self setupUI];
}

- (void)setupUI
{
    // 旧密码
    [self.view addSubview:self.oldTextField];
    [self.oldTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(0);
        make.size.equalTo(CGSizeMake(App_Frame_Width, 60));
        
    }];
    
    // 分割线
    UIView *segment1 = [self segmentView];
    [self.view addSubview:segment1];
    [segment1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(self.oldTextField.bottom).offset(1);
        make.size.equalTo(CGSizeMake(App_Frame_Width, 1));
    }];
    
    // 新密码
    [self.view addSubview:self.newpasswordTextField];
    [self.newpasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(segment1.bottom).offset(0);
        make.size.equalTo(CGSizeMake(App_Frame_Width, 60));
        
    }];
    
    // 分割线
    UIView *segment2 = [self segmentView];
    [self.view addSubview:segment2];
    [segment2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(self.newpasswordTextField.bottom).offset(1);
        make.size.equalTo(CGSizeMake(App_Frame_Width, 1));
    }];
    
    // 重复新密码
    [self.view addSubview:self.reNewTextField];
    [self.reNewTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(segment2.bottom).offset(0);
        make.size.equalTo(CGSizeMake(App_Frame_Width, 60));
        
    }];
    
    // 分割线
    UIView *segment3 = [self segmentView];
    [self.view addSubview:segment3];
    [segment3 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(self.reNewTextField.bottom).offset(1);
        make.size.equalTo(CGSizeMake(App_Frame_Width, 1));
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = UIColorFromRGB(0x36cacc);
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(segment3.bottom).offset(60);
        make.size.equalTo(CGSizeMake(App_Frame_Width - 30, 50));
        
    }];
    
}


// 确定按钮被点击了
- (void)buttonClicked:(UIButton *)button
{
    // 旧密码
    NSString *oldPassword = self.oldTextField.text;
    
    // 新密码
    NSString *newPassword = self.newpasswordTextField.text;
    
    // 重复的新密码
    NSString *reNewPassword = self.reNewTextField.text;
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    if ((oldPassword == nil && oldPassword.length == 0 ) || (newPassword == nil && newPassword.length == 0 ) || (reNewPassword == nil && reNewPassword.length == 0 )) {
        
        alert.message = @"密码不能为空";
        [alert show];
        return;
        
    } else if (oldPassword.length < 6 || oldPassword.length > 12 || newPassword.length < 6 || newPassword.length > 12) {
        
        alert.message = @"密码不能小于6位或超过12位";
        [alert show];
        return;
    } else if (![newPassword isEqualToString:reNewPassword]) {
    
        alert.message = @"两次密码不一致，请重新输入";
        [alert show];
        return;
    
    }

    
    [MBProgressHUD showMessage:@"正在修改..." toView:self.view isDimBackground:NO];
    [[AccountManager sharedInstance] changePasswordWithOldPassword:oldPassword newPassword:newPassword withCompletionHandler:^() {
        
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showSuccess:@"修改成功"];
        [self.navigationController popViewControllerAnimated:YES];
        
    } withErrorHandler:^(NSError *error) {
        
        
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:error.localizedDescription toView:self.view];
        
    }];
    
    
}



// 旧密码
- (UITextField *)oldTextField
{
    if (_oldTextField == nil) {
        
        _oldTextField = [self creatTextFieldWithPla:@"旧密码" image:@"old_password"];
    }
    
    return _oldTextField;
}

// 新密码
- (UITextField *)newpasswordTextField
{
    if (_newpasswordTextField == nil) {
        
        _newpasswordTextField = [self creatTextFieldWithPla:@"新密码" image:@"new_password"];
        
    }
    
    return _newpasswordTextField;
}

// 重复密码
- (UITextField *)reNewTextField
{
    if (_reNewTextField == nil) {
        
        _reNewTextField = [self creatTextFieldWithPla:@"再次输入新密码" image:@"new_password"];
    }
    
    return _reNewTextField;
}



- (UITextField *)creatTextFieldWithPla:(NSString *)pla image:(NSString *)leftImageName
{
    UITextField *textfield = [[UITextField alloc] init];
    textfield.placeholder = pla;
    
    textfield.font = [UIFont systemFontOfSize:15.0f];
    textfield.textColor = UIColorFromRGB(0x353d3f);
    textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    textfield.secureTextEntry = YES;
    
    // 左边的图片
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    view.frame = CGRectMake(0, 0, 15 + 22 + 16, 60);
    
    UIImageView *iconImage = [[UIImageView alloc] init];
    iconImage.image = [UIImage imageNamed:leftImageName];
    [view addSubview:iconImage];
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(view);
        make.left.equalTo(view).offset(15);
        make.size.equalTo(CGSizeMake(16, 24));
        
    }];
    textfield.leftView = view;
    textfield.leftViewMode = UITextFieldViewModeAlways;
    
    
    return textfield;
}

- (UIView *)segmentView
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = UIColorFromRGB(0xeaeaea);
    
    return view;
    
}


@end
