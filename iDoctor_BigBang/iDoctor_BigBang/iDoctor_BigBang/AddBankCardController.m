//
//  AddBankCardController.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/28/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "AddBankCardController.h"
@interface AddBankCardController ()
{
    NSString *_cardNum;
    BOOL _isDefault;
}

@property(nonatomic, strong) UIButton *addCardBtn;
@end

@implementation AddBankCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
    [self setUpSection0];

}
- (void)setUpTableView
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 120)];
    self.addCardBtn = [[UIButton alloc] init];

    [_addCardBtn setBackgroundImage:[UIImage createImageWithColor:kNavBarColor] forState:UIControlStateNormal];
    [_addCardBtn setBackgroundImage:[UIImage createImageWithColor:GDRandomColor] forState:UIControlStateDisabled];
    
    [_addCardBtn setTitle:@"确定添加" forState:UIControlStateNormal];
    
    [_addCardBtn addTarget:self action:@selector(addCardBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [footerView addSubview:_addCardBtn];
    [_addCardBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(footerView);
        make.left.equalTo(footerView).offset(20);
        make.right.equalTo(footerView).offset(-20);
        make.height.equalTo(50);
    }];
    self.tbv.tableFooterView = footerView;
}
- (void)setUpSection0
{
    RecruitTitleRowModel *bc = [RecruitTitleRowModel recruitTitleRowModelWithTitle:@"卡号" placeholder:@"填写银行卡号" keyboardType:UIKeyboardTypeNumberPad];
    [bc setTextFieldDidEndEditingBlock:^(NSString *text) {
        
        _cardNum = text;
    }];
    SectionModel *sectionModel = [SectionModel sectionModelWithRowModelArray:@[bc]];
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
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *foot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 30)];
    
    UIButton *btn = [[UIButton alloc] init];
    btn.titleLabel.font = GDFont(12);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [btn setTitle:@"选此卡为常用银行卡" forState:UIControlStateNormal];
    [btn setTitleColor:UIColorFromRGB(0x353d3f) forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"check_card_normal"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"check_card_selected"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(checkDefaultBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [foot addSubview:btn];
    [btn makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.equalTo(foot);
        make.right.equalTo(foot).offset(-15);
        make.width.equalTo(130);
    }];
    
    return foot;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30;
}

- (void)checkDefaultBtnClick:(UIButton *)btn
{
    
    btn.selected = !btn.selected;
    _isDefault = btn.selected;
    
}
- (void)addCardBtnClick:(UIButton *)btn
{
    [self.view endEditing:YES];
    GDLog(@"%@ %d",_cardNum, _isDefault);
    
    [GlideManger addBankCardWithCardNum:_cardNum AccountId:kAccount.doctor_id isDefault:_isDefault success:^(NSString *msg) {
        
        [self showTips:msg];
        [self.navigationController popViewControllerAnimated:YES];
        
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD showError:error.localizedDescription toView:self.view];
        
    }];
}
@end
