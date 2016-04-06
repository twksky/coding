//
//  WithDrawalCashViewController.m
//  AppFramework
//
//  Created by 周世阳 on 15/5/14.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "WithDrawalCashViewController.h"
#import "UIView+AutoLayout.h"
#import "CardListViewController.h"
#import "SkinManager.h"
#import "Bankcard.h"
#import "WithdrawalViewControllerStep3.h"
#import "AccountManager.h"

@interface WithDrawalCashViewController ()
<
CardListViewControllerDelegate
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *section1HeaderView;
@property (nonatomic, strong) UILabel *balanceValueLabel;
@property (nonatomic, strong) UITextField *cashValueTextField;
@property (nonatomic, strong) UIView *section2HeaderView;
@property (nonatomic, strong) UILabel *cashTipLabel;
@property (nonatomic, strong) UILabel *cashFinalValueLabel;
@property (nonatomic, strong) UIView *section2FooterView;
@property (nonatomic, strong) UILabel *bankLabel;

@property (nonatomic, strong) Bankcard *selectedBankCard;


@end

@implementation WithDrawalCashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarWithTitle:@"提现" leftBarButtonItem:[self makeLeftReturnBarButtonItem] rightBarButtonItem:nil];
    
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = UIColorFromRGB(0xedf2f1);
    [self.tableView setScrollEnabled: NO];
    
    //AutoLayout
    {
        [self.view addConstraints:[self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)]];
    }
    
    NSString *balanceValueStr = [NSString stringWithFormat:@"%.02f", [AccountManager sharedInstance].account.balance / 100.0f];
    [self setBalanceValue:balanceValueStr];
    [self setCashTipValue:@"0.00"];
    [self setCashFinalValue:@"0.00"];
    
}

#pragma mark - private methods

- (void)setBalanceValue:(NSString *)value {
    
    NSString *balanceTitle = [NSString stringWithFormat:@"您的账户余额 %@元", value];
    self.balanceValueLabel.text = balanceTitle;
}

- (void)setCashTipValue:(NSString *)value {
    
    NSString *cashTipText = [NSString stringWithFormat:@"此次您申请提现%@元, 我们将收取5%%作为平台管理费用(支付提现第三方平台2%%, 好医生平台3%%)", value];
    self.cashTipLabel.text = cashTipText;
}

- (void)setCashFinalValue:(NSString *)value {
    
    NSString *cashFinalValueText = [NSString stringWithFormat:@"此次您最终可提现实际金额为%@元", value];
    self.cashFinalValueLabel.text = cashFinalValueText;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.cashValueTextField) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:kNumbers] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basic = [string isEqualToString:filtered];
        if (basic) {
            NSString *moneyText = nil;
            // Handling 'delete'
            if (range.length == 1 && [string isEqualToString:@""]) {
                moneyText = self.cashValueTextField.text;
                moneyText = [moneyText substringToIndex:([moneyText length] - 1)];
            } else {
                moneyText = [self.cashValueTextField.text stringByAppendingString:string];
            }
            
            CGFloat money = [moneyText floatValue];
            money = money * 100.0f; // 换算成分
            basic = money <= [AccountManager sharedInstance].account.balance;
            if (basic) {
//                [self.stipulationLabel setAttributedText:[self formatStipulationWithMoney:[moneyText floatValue]]];
                [self setCashTipValue:moneyText];
                [self setCashFinalValue:[NSString stringWithFormat:@"%.02f", [moneyText floatValue] * 0.95f]];
            }
            
            
        }
        return basic;
    }
    return YES;
}



#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    if (0 == indexPath.section) {
        
        cell = [[UITableViewCell alloc] init];
        
        UILabel *moneyLabel = [[UILabel alloc] init];
        moneyLabel.textColor = [UIColor blackColor];
        moneyLabel.font = [UIFont systemFontOfSize:17.0f];
        moneyLabel.text = @"金额";
        
        [cell addSubview:moneyLabel];
        [cell addSubview:self.cashValueTextField];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //AutoLayout
        {
            [cell addConstraint:[moneyLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f]];
            [cell addConstraint:[moneyLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
            
            [cell addConstraint:[self.cashValueTextField autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:moneyLabel withOffset:20.0f]];
            [cell addConstraint:[self.cashValueTextField autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
        }
        
    }
    else if (1 == indexPath.section) {
        
        cell = [[UITableViewCell alloc] init];
        
        [self.bankLabel removeFromSuperview];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"see_icon"]];
        
        [cell addSubview:self.bankLabel];
        [cell addSubview:imageView];
        
        //AutoLayout
        {
            [cell addConstraint:[self.bankLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f]];
            [cell addConstraint:[self.bankLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
            
            [cell addConstraint:[imageView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f]];
            [cell addConstraint:[imageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
            [cell addConstraint:[imageView autoSetDimension:ALDimensionHeight toSize:20.0f]];
            [cell addConstraint:[imageView autoSetDimension:ALDimensionWidth toSize:20.0f]];
        }
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (0 == section) {
        
        return self.section1HeaderView;
    }
    else if (1 == section) {
        
        return self.section2HeaderView;
    }
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (1 == section) {
        
        return self.section2FooterView;
    }
    
    return nil;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (0 == section) {
        
        return 35.0f;
    }
    else if (1 == section) {
        
        return 90.0f;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (1 == section) {
        
        return 110.0f;
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (1 == indexPath.section) {
        
        CardListViewController *cvs = [[CardListViewController alloc] init];
        cvs.delegate = self;
        [self.navigationController pushViewController:cvs animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - CardListViewControllerDelegate Methods

- (void)didSelectedCard:(Bankcard *)card {
    
    self.selectedBankCard = card;
}

#pragma mark - selector

- (void)cash:(id)sender {
    
    if ([self.cashValueTextField.text length] == 0) {
        
        UIAlertView *alertVeiw = [[UIAlertView alloc] initWithTitle:@"提示" message:@"提现金额不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertVeiw show];
        return;
    }
    
    if (!self.selectedBankCard) {
        
        UIAlertView *alertVeiw = [[UIAlertView alloc] initWithTitle:@"提示" message:@"必须选择一张银行卡" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertVeiw show];
        return;
    }
    
    CGFloat money = [self.cashValueTextField.text floatValue];
    CGFloat actualMoney = money * 0.95f;
    
    WithdrawalViewControllerStep3 *wvs3 = [[WithdrawalViewControllerStep3 alloc] initWithBankcard:self.selectedBankCard withMoney:money withActualMoney:actualMoney];
    [self.navigationController pushViewController:wvs3 animated:YES];
}


#pragma mark - properties

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    return _tableView;
}

- (UITextField *)cashValueTextField {
    
    if (!_cashValueTextField ) {
        
        _cashValueTextField = [[UITextField alloc] init];
        _cashValueTextField.placeholder = @"输入您要提现的金额";
        _cashValueTextField.keyboardType = UIKeyboardTypeNumberPad;
        _cashValueTextField.delegate = self;
    }
    
    return _cashValueTextField;
}

- (UILabel *)balanceValueLabel {
    
    if (!_balanceValueLabel) {
        
        _balanceValueLabel = [[UILabel alloc] init];
        _balanceValueLabel.textColor = UIColorFromRGB(0x8f8e94);
        _balanceValueLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    
    return _balanceValueLabel;
}

- (UIView *)section1HeaderView {
    
    if (!_section1HeaderView) {
        
        _section1HeaderView = [[UIView alloc] init];
        _section1HeaderView.backgroundColor = UIColorFromRGB(0xedf2f1);
        
        [_section1HeaderView addSubview:self.balanceValueLabel];
        
        //AutoLayout
        {
            [_section1HeaderView addConstraint:[self.balanceValueLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f]];
            [_section1HeaderView addConstraint:[self.balanceValueLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
        }
    }
    
    return _section1HeaderView;
}

- (UILabel *)cashTipLabel {
    
    if (!_cashTipLabel) {
        
        _cashTipLabel = [[UILabel alloc] init];
        _cashTipLabel.textColor = UIColorFromRGB(0x8f8e94);
        _cashTipLabel.font = [UIFont systemFontOfSize:12.0f];
        _cashTipLabel.numberOfLines = 0;
        _cashTipLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    
    return _cashTipLabel;
}

- (UILabel *)cashFinalValueLabel {
    
    if (!_cashFinalValueLabel) {
        
        _cashFinalValueLabel = [[UILabel alloc] init];
        _cashFinalValueLabel.textColor = UIColorFromRGB(0xfe5c58);
        _cashFinalValueLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    
    return _cashFinalValueLabel;
}

- (UIView *)section2HeaderView {
    
    if (!_section2HeaderView) {
        
        _section2HeaderView = [[UIView alloc] init];
        _section2HeaderView.backgroundColor = UIColorFromRGB(0xedf2f1);
        [_section2HeaderView addSubview:self.cashTipLabel];
        [_section2HeaderView addSubview:self.cashFinalValueLabel];
        
        //AutoLayout
        {
            [_section2HeaderView addConstraint:[self.cashTipLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f]];
            [_section2HeaderView addConstraint:[self.cashTipLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f]];
            [_section2HeaderView addConstraint:[self.cashTipLabel autoSetDimension:ALDimensionWidth toSize:App_Frame_Width - 20]];
            
            [_section2HeaderView addConstraint:[self.cashFinalValueLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f]];
            [_section2HeaderView addConstraint:[self.cashFinalValueLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.cashTipLabel withOffset:10.0f]];
        }
    }
    
    return _section2HeaderView;
}

- (UIView *)section2FooterView {
    
    if (!_section2FooterView) {
        
        _section2FooterView = [[UIView alloc] init];
        _section2FooterView.backgroundColor = UIColorFromRGB(0xedf2f1);
        
        UILabel *adviseLabel = [[UILabel alloc] init];
        adviseLabel.textColor = UIColorFromRGB(0x8e8d94);
        adviseLabel.font = [UIFont systemFontOfSize:12.0f];
        adviseLabel.text = @"为减少相关手续费用, 建议您绑定本人交通银行卡来提现";
        
        UIButton *cashNowBtn = [[SkinManager sharedInstance] createDefaultV3GreenButton];
        
        [cashNowBtn setTitle:@"提现" forState:UIControlStateNormal];
        
        [_section2FooterView addSubview:adviseLabel];
        [_section2FooterView addSubview:cashNowBtn];
        
        //AutoLayout
        {
            [_section2FooterView addConstraint:[adviseLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f]];
            [_section2FooterView addConstraint:[adviseLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f]];
            
            [_section2FooterView addConstraint:[cashNowBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:adviseLabel withOffset:20.0f]];
            [_section2FooterView addConstraint:[cashNowBtn autoAlignAxisToSuperviewAxis:ALAxisVertical]];
            [_section2FooterView addConstraint:[cashNowBtn autoSetDimension:ALDimensionHeight toSize:50.0f]];
            [_section2FooterView addConstraint:[cashNowBtn autoSetDimension:ALDimensionWidth toSize:App_Frame_Width - 20.0f]];
        }
        
        [cashNowBtn addTarget:self action:@selector(cash:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _section2FooterView;
}

- (UILabel *)bankLabel {
    
    if (!_bankLabel) {
        
        _bankLabel = [[UILabel alloc] init];
        _bankLabel.textColor = [UIColor blackColor];
        _bankLabel.font = [UIFont systemFontOfSize:17.0f];
        _bankLabel.text = @"银行卡";
    }
    
    return _bankLabel;
}

- (void)setSelectedBankCard:(Bankcard *)selectedBankCard {
    
    if (selectedBankCard) {
        self.bankLabel.text = selectedBankCard.cardName;
    }
    else {
        self.bankLabel.text = @"银行卡";
    }
    _selectedBankCard = selectedBankCard;
}

@end













