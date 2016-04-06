//
//  IntegralHeaderView.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/27/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "IntegralHeaderView.h"

@interface IntegralHeaderView ()

@property(nonatomic, strong) UILabel *jfLabel;

@end

@implementation IntegralHeaderView
- (void)setScore:(NSInteger)score
{
    self.jfLabel.text = [NSString stringWithFormat:@"%ld",score];
}
- (void)setExchangeBtnClickBlock:(ExchangeBtnClickBlock)exchangeBtnClickBlock
{
    _exchangeBtnClickBlock = exchangeBtnClickBlock;
}
- (void)setShopBtnClickBlock:(ShopBtnClickBlock)shopBtnClickBlock
{
    _shopBtnClickBlock = shopBtnClickBlock;
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
    self.jfLabel = [[UILabel alloc] init];
    _jfLabel.font = GDFont(55);
    _jfLabel.text = @"0";
    _jfLabel.textColor = [UIColor whiteColor];
//    _jfLabel.backgroundColor = GDRandomColor;
    [self addSubview:_jfLabel];
    [_jfLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-25);
        make.height.equalTo(50);
    }];
    
    UILabel *lb = [[UILabel alloc] init];
    lb.textColor = [UIColor whiteColor];
    lb.text = @"分";
//    lb.backgroundColor = GDRandomColor;
    
    [self addSubview:lb];
    [lb makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_jfLabel.right);
        make.bottom.equalTo(_jfLabel).offset(-3);
    }];
    
    UIView *btnWrap = [[UIView alloc] init];
//    btnWrap.backgroundColor = GDRandomColor;
    
    [self addSubview:btnWrap];
    [btnWrap makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self);
        make.height.equalTo(30);
        make.bottom.equalTo(self).offset(-20);
    }];
    
    UIButton *shopBtn = [self createBtnWithTitle:@"商城" target:self action:@selector(shopBtnClick)];
    
    [btnWrap addSubview:shopBtn];
    [shopBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.bottom.equalTo(btnWrap);
        make.width.equalTo(80);
    }];
    
    UIButton *exchangeBtn = [self createBtnWithTitle:@"兑换" target:self action:@selector(exchangeBtnClick)];
    
    [btnWrap addSubview:exchangeBtn];
    [exchangeBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.right.bottom.equalTo(btnWrap);
        make.left.equalTo(shopBtn.right).offset(10);
        make.width.equalTo(shopBtn);
    }];

}
- (void)shopBtnClick
{
    if (self.shopBtnClickBlock) {
        self.shopBtnClickBlock();
    }
}
- (void)exchangeBtnClick
{
    
    if (self.exchangeBtnClickBlock) {
        self.exchangeBtnClickBlock();
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
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
@end
