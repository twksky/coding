//
//  ChatBottomView.m
//  iDoctor_BigBang
//
//  Created by hexy on 印度历1937/8/7.
//  Copyright © 印度历1937年 YDHL. All rights reserved.
//

#import "ChatBottomView.h"

@interface ChatBottomView ()

@property(nonatomic, strong) UIButton *inceptBtn;
@end
@implementation ChatBottomView

- (void)setIsIncepted:(BOOL)isIncepted
{
    if (isIncepted) {// yes
        
        [self.inceptBtn setImage:[UIImage imageNamed:@"cancel_incept"] forState:UIControlStateNormal];
        [self.inceptBtn setTitle:@"取消接收" forState:UIControlStateNormal];
        
    } else {// no
        
        [self.inceptBtn setImage:[UIImage imageNamed:@"incept_patient"] forState:UIControlStateNormal];
        [self.inceptBtn setTitle:@"接收患者" forState:UIControlStateNormal];

    }
}
- (void)setChatBtnClickBlock:(ChatBtnClickBlock)chatBtnClickBlock
{
    _chatBtnClickBlock = chatBtnClickBlock;
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
        self.frame = CGRectMake(0, App_Frame_Height - 44 - 50, App_Frame_Width, 50);
        self.backgroundColor = kNavBarColor;
        [self setUpAllViews];
        
    }
    return self;
}

- (void)setUpAllViews
{
    UIButton *chat = [self createBtnWithIcon:[UIImage imageNamed:@"chat"] title:@"聊天" target:self selector:@selector(chatBtnClick)];
     UIButton *revert = [self createBtnWithIcon:[UIImage imageNamed:@"revert"] title:@"回复意见" target:self selector:@selector(revertBtnClick)];
     self.inceptBtn = [self createBtnWithIcon:[UIImage imageNamed:@"incept_patient"] title:@"接收患者" target:self selector:@selector(inceptBtnClick)];
    
    [self addSubview:chat];
    [self addSubview:revert];
    [self addSubview:_inceptBtn];

    [chat makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.equalTo(self).offset(10);
        make.bottom.equalTo(self).offset(-10);
        make.width.equalTo(@[revert, _inceptBtn]);
    }];
    
   
    
    [revert makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.equalTo(chat);
        make.left.equalTo(chat.right).offset(5);
        make.width.equalTo(@[chat, _inceptBtn]);
    }];
    
   
    
    [_inceptBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(revert.right).offset(5);
        make.right.equalTo(self).offset(-10);
        make.top.bottom.equalTo(revert);
        make.width.equalTo(@[chat, revert]);
    }];

    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = UIColorFromRGB(0x86dfe0);
    
    [self addSubview:line1];
    [line1 makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(chat.right).offset(2);
        make.width.equalTo(1);
        make.height.equalTo(20);
        make.centerY.equalTo(self);

    }];
    
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = UIColorFromRGB(0x86dfe0);
    
    [self addSubview:line2];
    [line2 makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(revert.right).offset(2);
        make.width.equalTo(1);
        make.height.equalTo(20);
        make.centerY.equalTo(self);
    }];

}


- (void)chatBtnClick
{
    if (self.chatBtnClickBlock) {
        self.chatBtnClickBlock();
    }
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

    btn.titleLabel.font = GDFont(14);
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    [btn setImage:icon forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}


@end
