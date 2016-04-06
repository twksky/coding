//
//  ChargeController.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/27/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "ChargeController.h"
#import "HeaderManger.h"
#import "ChargeHeaderView.h"
#import "BankCardController.h"



@interface ChargeController ()
{
    UIImage *_icon;
    NSString *_title;
    NSString *_subtitle;
    NSString *_back_account;
}

@property(nonatomic, strong) UIButton *applyChargeBtn;
@property(nonatomic, strong) ChargeHeaderView *headerView;

@property (nonatomic, strong) NSMutableDictionary *diction;



@end

@implementation ChargeController

- (void)viewDidLoad {
    
    self.diction = [NSMutableDictionary dictionary];
    
    
    [super viewDidLoad];
    [self setUpHeaderView];
    [self setUpFooterView];
    [self setUpData];
    

}
- (void)setUpData
{
    [self setUpSection0];
    [self setUpSection1];
    [self setUpSection2];
}
- (void)setUpSection0
{
    TextFieldRowModel *sum = [TextFieldRowModel textFieldRowModelWithText:self.diction[@"money"] placeholder:@"请输入提现金额" keyboardType:UIKeyboardTypeNumberPad];
    
    [sum setTextFieldDidEndEditingBlock:^(NSString *text) {
       
        [self.diction setObject:text forKey:@"money"];
        // [self.tbv reloadData];
        
    }];
    
    SectionModel *sectionModel = [SectionModel sectionModelWithRowModelArray:@[sum]];
    [self.sectionModelArray addObject:sectionModel];
}

- (void)setUpSection1
{
    
    
    TextFieldRowModel *name = [TextFieldRowModel textFieldRowModelWithText:self.diction[@"payee"] placeholder:@"请输入收款人姓名" keyboardType:UIKeyboardTypeDefault];
    [name setTextFieldDidEndEditingBlock:^(NSString *text) {
       
        [self.diction setObject:text forKey:@"payee"];
       //  [self.tbv reloadData];
    }];
    
    TextFieldRowModel *card = [TextFieldRowModel textFieldRowModelWithText:self.diction[@"id_card"] placeholder:@"请输入收款人身份证号码" keyboardType:UIKeyboardTypeNumberPad];
    [card setTextFieldDidEndEditingBlock:^(NSString *text) {
      
        [self.diction setObject:text forKey:@"id_card"];
       //  [self.tbv reloadData];
    }];
    
    
    
    TextFieldRowModel *phone = [TextFieldRowModel textFieldRowModelWithText:self.diction[@"phone"] placeholder:@"请输入到账提醒号码" keyboardType:UIKeyboardTypeNumberPad];
    [phone setTextFieldDidEndEditingBlock:^(NSString *text) {
       
        [self.diction setObject:text forKey:@"phone"];
        // [self.tbv reloadData];
    }];
    
    
    SectionModel *sectionModel = [SectionModel sectionModelWithRowModelArray:@[name, card, phone]];
    [self.sectionModelArray addObject:sectionModel];
    
    
}
- (void)setUpSection2
{
    BankCardRowModel *bankCard = [BankCardRowModel bankCardRowModelWithIcon:(_icon)?_icon:[UIImage imageNamed:@"template"] title:(_title)?_title:@"请选择银行卡" subtitle:_subtitle destVC:nil];
    
    [bankCard setRowSelectedBlock:^(NSIndexPath *indexPath) {
        
        BankCardController *bk = [[BankCardController alloc] init];
        bk.title = @"选择银行卡";
        
        [bk setTtblock:^(UIImage *icon, NSString *title, NSString *subtitle, NSString *back_account) {
            
            _icon = icon;
            _title = title;
            _subtitle = subtitle;
            _back_account = back_account;
            
        }];
        [self.navigationController pushViewController:bk animated:YES];
    }];
    
    SectionModel *sectionModel = [SectionModel sectionModelWithRowModelArray:@[bankCard]];
    [self.sectionModelArray addObject:sectionModel];
}

- (void)setUpHeaderView
{
    self.headerView = [[ChargeHeaderView alloc] init];
    self.tbv.tableHeaderView = self.headerView;
}
- (void)setUpFooterView
{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 100)];
    
    self.applyChargeBtn = [[UIButton alloc] init];
    [_applyChargeBtn addTarget:self action:@selector(applyChargeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_applyChargeBtn setTitle:@"申请提现" forState:UIControlStateNormal];
//    [_applyChargeBtn setTitleColor:GDRandomColor forState:UIControlStateNormal];
    
    [_applyChargeBtn setBackgroundImage:[UIImage createImageWithColor:kNavBarColor] forState:UIControlStateNormal];
    [_applyChargeBtn setBackgroundImage:[UIImage createImageWithColor:GDRandomColor] forState:UIControlStateDisabled];
    
    [footer addSubview:_applyChargeBtn];
    [_applyChargeBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(UIEdgeInsetsMake(25, 15, 25, 15));
    }];
    self.tbv.tableFooterView = footer;
}


- (void)applyChargeBtnClick
{
    ChargeRequest *req = [[ChargeRequest alloc] init];
 
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    NSInteger money = [self.diction[@"money"] integerValue];
    
    NSLog(@"%ld",kAccount.balance);
    
    if (self.diction[@"money"] == nil  || [self.diction[@"money"] length] == 0 || self.diction[@"payee"] == nil || [self.diction[@"payee"] length] == 0 || self.diction[@"phone"] == nil || [self.diction[@"phone"] length] == 0 || self.diction[@"id_card"] == nil || [self.diction[@"id_card"] length] == 0 || _back_account == nil) {
        alert.message = @"信息填写不全，不能提现";
       
        [alert show];
        return;
        
    } else if ([self.diction[@"money"] integerValue] == 0) {
    
        alert.message = @"提现不能为0 或 输入有误";
        [alert show];
        return;
    
    } else if ([self.diction[@"money"] integerValue] > kAccount.balance/100) {
    
        alert.message = @"余额不足";
        [alert show];
        return;
    
    }

    
    
    req.money = @(money);
    req.bank_account = _back_account;
    req.payee = self.diction[@"payee"];
    req.phone = self.diction[@"phone"];
    req.id_card = self.diction[@"id_card"];
    
    [MBProgressHUD showMessage:@"申请中..." toView:self.view isDimBackground:NO];
    [GlideManger chargeWithAccount:kAccount.doctor_id chargeRequest:req success:^(NSInteger balance) {
        
        [MBProgressHUD hideHUDForView:self.view];
        [self showTips:[NSString stringWithFormat:@"%ld",balance]];
        kAccount.balance -= [self.diction[@"money"] integerValue];

        [self.navigationController popToRootViewControllerAnimated:YES];
        
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:error.localizedDescription toView:self.view];
    
    }];
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return (section == 0) ? @"我爱好医生平台将收取5%的手续费 (其中第3方支付平台2%，好医生平台3%)" : nil;;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return (section == 0) ? 50 : 5;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateData];
}
- (void)updateData
{
    [self.sectionModelArray removeAllObjects];
    [self setUpData];
    [self.tbv reloadData];
}
@end
