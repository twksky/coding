//
//  BalanceHeaderView.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/27/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "BalanceHeaderView.h"

@interface BalanceHeaderView ()
@property(nonatomic, strong) UILabel *balanceLabel;
@end
@implementation BalanceHeaderView

- (void)setChargeBtnClickBlock:(ChargeBtnClickBlock)chargeBtnClickBlock
{
    _chargeBtnClickBlock = chargeBtnClickBlock;
}
- (instancetype)init
{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, App_Frame_Width, 136);
        self.backgroundColor = kNavBarColor;
        [self setupAllViews];
    }
    return self;
}
- (void)setupAllViews
{
    self.balanceLabel = [[UILabel alloc] init];
    _balanceLabel.font = GDFont(55);
    _balanceLabel.text = [NSString stringWithFormat:@"%ld",kAccount.balance/100];
    _balanceLabel.textColor = [UIColor whiteColor];
    //    _jfLabel.backgroundColor = GDRandomColor;
    [self addSubview:_balanceLabel];
    [_balanceLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-25);
        make.height.equalTo(50);
    }];
    
    UILabel *lb = [[UILabel alloc] init];
    lb.textColor = [UIColor whiteColor];
    lb.text = @"元";
    //    lb.backgroundColor = GDRandomColor;
    
    [self addSubview:lb];
    [lb makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_balanceLabel.right);
        make.bottom.equalTo(_balanceLabel).offset(-3);
    }];
    
    UIButton *chargeBtn = [self createBtnWithTitle:@"申请提现" target:self action:@selector(chargeBtnClick)];
    
    [self addSubview:chargeBtn];
    [chargeBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self).offset(-20);
        make.width.equalTo(90);
        make.centerX.equalTo(self);
    }];
}
- (void)chargeBtnClick
{
    if (self.chargeBtnClickBlock) {
        self.chargeBtnClickBlock();
    }
}
- (UIButton *)createBtnWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor = [UIColor whiteColor].CGColor;
    btn.layer.cornerRadius = 3;
    btn.titleLabel.font = GDFont(15);
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
@end
