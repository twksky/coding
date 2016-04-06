//
//  GDComposeView.m
//  GoodDoctor
//
//  Created by hexy on 15/7/22.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "GDComposeView.h"
#import <FXBlurView.h>
#define topViewHeight 30
#define composeTextViewPadding 10

@interface GDComposeView()
@property(nonatomic, strong) UITextView *composeTextView;
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) UIView *titleView;
@property(nonatomic, strong) UIButton *cancelBtn;
@property(nonatomic, strong) UIButton *sendBtn;
@property(nonatomic, strong) UILabel *titleLabel;
/**
 *  毛玻璃View
 */
@property(nonatomic, strong) FXBlurView *blurView;

@end

@implementation GDComposeView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpAllViews];
        
        [GDNotificationCenter addObserver:self selector:@selector(textViewTextDidChange) name:UITextViewTextDidChangeNotification object:self.composeTextView];
        [GDNotificationCenter addObserver:self selector:@selector(keyboardWillChangeFrame:)
                                     name:UIKeyboardWillChangeFrameNotification
                                   object:nil];

    }
    return self;
}
#pragma mark - 键盘frame将要改变的通知
/**
  *  键盘frame将要改变的通知
  *
  *  @param notice
  */
- (void)keyboardWillChangeFrame:(NSNotification *)notice
{
    CGRect keyboardF = [notice.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat transformY = - (keyboardF.size.height + 160);
    
    [UIView animateWithDuration:0.4 animations:^{
        
        self.transform = CGAffineTransformMakeTranslation(0, transformY);
    }];
}
- (void)show
{
    [self addBlurView];
    [self addComposeView];
}
- (void)addComposeView
{
    self.frame = CGRectMake(0, App_Frame_Height, App_Frame_Width,250);
    self.backgroundColor = GDColorRGB(239, 239, 239);
    
    [GDAppTopView addSubview:self];
    
    // 去掉Done工具条
    self.composeTextView.inputAccessoryView = [[UIView alloc] init];
    
    // 成为第一响应者
    [self.composeTextView becomeFirstResponder];
}
#pragma mark - 添加毛玻璃蒙版
/**
 *  添加毛玻璃蒙版
 *
 *  @param type 蒙版类型
 */
- (void)addBlurView
{
    self.blurView = [[FXBlurView alloc] init];

    _blurView.frame = GDAppTopView.bounds;
    _blurView.blurRadius = 8;
    
    UIButton *button = [[UIButton alloc] init];
    button.frame = GDAppTopView.bounds;
    button.backgroundColor = GDColorRGBA(19, 29, 30, 0.0);
    
    [button addTarget:self action:@selector(blurViewBtnClick) forControlEvents:UIControlEventTouchDown];
    
    [_blurView addSubview:button];
    [GDAppTopView addSubview:_blurView];
    
    [UIView animateWithDuration:0.4 animations:^{
        
        button.backgroundColor = GDColorRGBA(19, 29, 30, 0.75);
    }];
}
- (void)blurViewBtnClick
{
    [self hidSelf];
}
- (void)hidSelf
{
    [self.blurView removeFromSuperview];
    [self removeFromSuperview];
}
- (void)setComposeText:(NSString *)text
{
    if (text) {
        self.composeTextView.text = text;
        self.sendBtn.enabled = YES;
    }
}
- (void)setCancalBtnClickBlock:(CancalBtnClickBlock)cancalBtnClickBlock
{
    _cancalBtnClickBlock = cancalBtnClickBlock;
}
-(void)setSendBtnClickBlock:(SendBtnClickBlock)sendBtnClickBlock
{
    _sendBtnClickBlock = sendBtnClickBlock;
}
#pragma mark - 私有方法

- (void)textViewTextDidChange
{
    self.sendBtn.enabled = (self.composeTextView.text.length != 0);
}

- (void)setUpAllViews
{
    self.contentView = [[UIView alloc] init];
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
         make.edges.equalTo(UIEdgeInsetsMake(composeTextViewPadding, composeTextViewPadding, composeTextViewPadding *10, composeTextViewPadding));
    }];
    
    UIView *superView = self.contentView;
    [superView addSubview:self.titleView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.equalTo(superView);
        make.height.equalTo(@(topViewHeight));
    }];

    [superView addSubview:self.composeTextView];
    [self.composeTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.titleView.bottom).offset(composeTextViewPadding);
        make.left.right.bottom.equalTo(superView);
    }];
    
}

- (void)sendCompose
{
    [self hidSelf];
    if (self.sendBtnClickBlock) {
        self.sendBtnClickBlock(self.composeTextView.text);
    }
}
- (void)cancelCompose
{
    [self hidSelf];
    if (self.cancalBtnClickBlock) {
        self.cancalBtnClickBlock(self.composeTextView.text);
    }
}

#pragma mark - 成员变量初始化

- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:GDColorRGB(53, 61, 63) forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelCompose) forControlEvents:UIControlEventTouchDown];
    }
    return _cancelBtn;
}
- (UIButton *)sendBtn
{
    if (!_sendBtn) {
        _sendBtn = [[UIButton alloc] init];
        _sendBtn.enabled = NO;
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:GDColorRGB(53, 61, 63) forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [_sendBtn addTarget:self action:@selector(sendCompose) forControlEvents:UIControlEventTouchDown];
    }
    return _sendBtn;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"写评论";
        _titleLabel.font = [UIFont systemFontOfSize:18.0];
        _titleLabel.textColor = GDColorRGB(53, 61, 63);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIView *)titleView
{
    if (!_titleView) {
        
        _titleView = [[UIView alloc] init];
        UIView *superView = _titleView;
        [superView addSubview:self.cancelBtn];
        [superView addSubview:self.titleLabel];
        [superView addSubview:self.sendBtn];
        
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.top.bottom.equalTo(superView);
            make.width.equalTo(@50);
        }];

        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.bottom.equalTo(superView);
            make.left.equalTo(self.cancelBtn.right);
        }];

        [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.bottom.right.equalTo(superView);
            make.left.equalTo(self.titleLabel.right);
            make.width.equalTo(self.cancelBtn.width);
        }];
    }
    return _titleView;
}

- (UITextView *)composeTextView
{
    if (!_composeTextView) {
        _composeTextView = [[UITextView alloc] init];
        _composeTextView.backgroundColor = [UIColor whiteColor];
        _composeTextView.font = [UIFont systemFontOfSize:16];
    }
    return _composeTextView;
}

- (void)dealloc
{
    [GDNotificationCenter removeObserver:self];
}
@end
