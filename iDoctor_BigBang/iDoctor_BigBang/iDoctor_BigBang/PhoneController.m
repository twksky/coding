//
//  PhoneController.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/20/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "PhoneController.h"

@interface PhoneController ()
{
    NSString *_officePhone;
}
@end

@implementation PhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNav];
    // 设置数据
    [self setUpData];
}

- (void)setUpData
{
    [self setUpSection0];
    
}

- (void)setUpSection0
{
    TextFieldRowModel *phone = [TextFieldRowModel textFieldRowModelWithText:kAccount.office_phone placeholder:nil keyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [phone setTextFieldDidEndEditingBlock:^(NSString *text) {
        
        _officePhone = text;
    }];
    SectionModel *sectionModel = [SectionModel sectionModelWithRowModelArray:@[phone]];
    
    [self.sectionModelArray addObject:sectionModel];
    
}

- (void)leftItemClick
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightItemClick
{
    [self.view endEditing:YES];

    InfoChangeRequest *request = [InfoChangeRequest request];
    request.office_phone = _officePhone;
    
    [self showMessage:@"修改中..."];
    [ChangeInfoManger changeInfoWithInfoChangeRequest:request accountId:kAccount.doctor_id success:^(Account *account) {
        
        [AccountManager saveAccount:account];
        [self hidMessage];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } failure:^(NSError *error) {
        
        [self hidMessage];
        [MBProgressHUD showError:error.localizedDescription];
        
        [self.view endEditing:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}



@end
