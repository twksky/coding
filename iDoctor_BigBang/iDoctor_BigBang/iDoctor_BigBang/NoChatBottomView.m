//
//  NoChatBottomView.m
//  iDoctor_BigBang
//
//  Created by hexy on 印度历1937/8/7.
//  Copyright © 印度历1937年 YDHL. All rights reserved.
//

#import "NoChatBottomView.h"

@interface NoChatBottomView ()

@property(nonatomic, strong) UIButton *inceptBtn;
@end

@implementation NoChatBottomView

- (void)setIsIncepted:(BOOL)isIncepted
{
    if (isIncepted) { // 已经接收了患者
        
        [self.inceptBtn setImage:[UIImage imageNamed:@"cancel_incept"] forState:UIControlStateNormal];
        [self.inceptBtn setTitle:@"取消接收" forState:UIControlStateNormal];
        
    } else { // 已经取消接收了患者
        
        [self.inceptBtn setImage:[UIImage imageNamed:@"incept_patient"] forState:UIControlStateNormal];
        [self.inceptBtn setTitle:@"接收患者" forState:UIControlStateNormal];
        
    }
}
- (void)setRevertBtnClickBlock:(RevertBtnClickBlock)revertBtnClickBlock
{
    _revertBtnClickBlock = revertBtnClickBlock;
}
- (void)setInceptBtnClickBlock:(InceptBtnClickBlock)inceptBtnClickBlock
{
    _inceptBtnClickBlock = inceptBtnClickBlock;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, App_Frame_Height - 44 - 60, App_Frame_Width, 60);
        self.backgroundColor = UIColorFromRGB(0xf8f8f8);
        [self setUpAllViews];
    }
    return self;
}

- (void)setUpAllViews
{
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = UIColorFromRGB(0xeaeaea);
    
    [self addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.equalTo(self);
        make.height.equalTo(1);
    }];
    UIButton *revert = [self createBtnWithIcon:[UIImage imageNamed:@"revert"] title:@"回复意见" target:self selector:@selector(revertBtnClick)];
    
    [self addSubview:revert];
    [revert makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.equalTo(self).offset(10);
        make.bottom.equalTo(self).offset(-10);
    }];
    
    self.inceptBtn = [self createBtnWithIcon:[UIImage imageNamed:@"incept_patient"] title:@"接收患者" target:self selector:@selector(inceptBtnClick)];
    
    [self addSubview:_inceptBtn];
    [_inceptBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(revert);
        make.right.bottom.equalTo(self).offset(-10);
        make.width.equalTo(revert);
        make.left.equalTo(revert.right).offset(10);
    }];
}
- (void)revertBtnClick
{
    if (self.revertBtnClickBlock) {
        self.revertBtnClickBlock();
    }

}
- (void)inceptBtnClick
{
    if (self.inceptBtnClickBlock) {
        self.inceptBtnClickBlock();
    }

}
- (UIButton *)createBtnWithIcon:(UIImage *)icon title:(NSString *)title target:(id)target selector:(SEL)selector
{
    UIButton *btn = [[UIButton alloc] init];
    btn.backgroundColor = kNavBarColor;
    btn.titleLabel.font = GDFont(16);
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    [btn setImage:icon forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}
@end
