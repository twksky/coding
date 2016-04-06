//
//  ChargeHeaderView.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/27/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "ChargeHeaderView.h"

@interface ChargeHeaderView ()

@property(nonatomic, strong) UILabel *balanceLabel;

@end
@implementation ChargeHeaderView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, App_Frame_Width, 110);
        self.backgroundColor = [UIColor whiteColor];
        [self setUpAllViews];
    }
    return self;
}
- (void)setUpAllViews
{
    
    UIView *hdBottomView = [[UIView alloc] init];
    hdBottomView.backgroundColor = UIColorFromRGB(0xf8f8f8);
    
    [self addSubview:hdBottomView];
    [hdBottomView makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.bottom.right.equalTo(self);
        make.height.equalTo(10);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = UIColorFromRGB(0xeaeaea);
    [self addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self);
        make.bottom.equalTo(hdBottomView.top);
        make.height.equalTo(1);
    }];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"可提现金额(元)";
    tipLabel.textColor = kDefaultFontColor;
    tipLabel.font = GDFont(12);
    
    [self addSubview:tipLabel];
    [tipLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.equalTo(self).offset(15);
    }];
    
    self.balanceLabel = [[UILabel alloc] init];
    _balanceLabel.font = [UIFont boldSystemFontOfSize:40];
    _balanceLabel.text = [NSString stringWithFormat:@"%ld",kAccount.balance/100];
    
    [self addSubview:_balanceLabel];
    [_balanceLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self);
    }];

}
@end
