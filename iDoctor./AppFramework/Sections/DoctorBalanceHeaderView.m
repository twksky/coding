//
//  DoctorBalanceHeaderView.m
//  AppFramework
//
//  Created by 周世阳 on 15/5/13.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "DoctorBalanceHeaderView.h"
#import "UIView+AutoLayout.h"

@interface DoctorBalanceHeaderView ()

@property (nonatomic, strong) UILabel *balanceLabel;
@property (nonatomic, strong) UILabel *totalBalanceLabel;

@end

@implementation DoctorBalanceHeaderView

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        [self setupViews];
    }
    
    return self;
}

- (void)setupViews {
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"img_money_header_bg"] stretchableImageWithLeftCapWidth:1 topCapHeight:319]];
    [self addSubview:bgImageView];//背景图片
    
    UIView *topPartView = [[UIView alloc] init];
//    topPartView.backgroundColor = UIColorFromRGB(0x33d2b4);
    topPartView.backgroundColor = [UIColor clearColor];
    [topPartView addSubview:self.balanceLabel];
    [topPartView addSubview:self.balanceNumberLabel];
    
    UIView *middleLine = [[UIView alloc] init];
    middleLine.backgroundColor = UIColorFromRGB(0x93e1cf);
    
    UIView *bottomPartView = [[UIView alloc] init];
    bottomPartView.backgroundColor = UIColorFromRGB(0x33d2b4);
    [bottomPartView addSubview:self.totalBalanceLabel];
    [bottomPartView addSubview:self.totalBalanceNumberLabel];
    
    [self addSubview:topPartView];
    [self addSubview:middleLine];
//    [self addSubview:bottomPartView];
    
    //AutoLayout
    {
        [self addConstraints:[bgImageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero]];
        
        [self addConstraint:[topPartView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0]];
        [self addConstraint:[topPartView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f]];
        [self addConstraint:[topPartView autoSetDimension:ALDimensionWidth toSize:App_Frame_Width]];
        [self addConstraint:[topPartView autoSetDimension:ALDimensionHeight toSize:150.0f]];
        
        [topPartView addConstraint:[self.balanceLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:18.0f]];
        [topPartView addConstraint:[self.balanceLabel autoAlignAxisToSuperviewAxis:ALAxisVertical]];
        
        [topPartView addConstraint:[self.balanceNumberLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.balanceLabel withOffset:13.0f]];
        [topPartView addConstraint:[self.balanceNumberLabel autoAlignAxisToSuperviewAxis:ALAxisVertical]];
        
        [self addConstraint:[middleLine autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:topPartView]];
        [self addConstraint:[middleLine autoSetDimension:ALDimensionWidth toSize:App_Frame_Width]];
        [self addConstraint:[middleLine autoSetDimension:ALDimensionHeight toSize:1.0f]];
        
//        [self addConstraint:[bottomPartView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:middleLine]];
//        [self addConstraint:[bottomPartView autoSetDimension:ALDimensionWidth toSize:App_Frame_Width]];
//        [self addConstraint:[bottomPartView autoSetDimension:ALDimensionHeight toSize:70.0f]];
//        
//        [bottomPartView addConstraint:[self.totalBalanceLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15.0f]];
//        [bottomPartView addConstraint:[self.totalBalanceLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
//        
//        [bottomPartView addConstraint:[self.totalBalanceNumberLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0f]];
//        [bottomPartView addConstraint:[self.totalBalanceNumberLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
    }
    
}

#pragma mark - properties

- (UILabel *)balanceLabel {
    
    if (!_balanceLabel) {
        
        _balanceLabel = [[UILabel alloc] init];
        _balanceLabel.textColor = [UIColor whiteColor];
        _balanceLabel.font = [UIFont systemFontOfSize:14.0f];
        _balanceLabel.text = @"余额(元)";
    }
    
    return _balanceLabel;
}

- (UILabel *)balanceNumberLabel {
    
    if (!_balanceNumberLabel) {
        
        _balanceNumberLabel = [[UILabel alloc] init];
        _balanceNumberLabel.textColor = [UIColor whiteColor];
        _balanceNumberLabel.font = [UIFont systemFontOfSize:57.0f];
    }
    
    return _balanceNumberLabel;
}

- (UILabel *)totalBalanceLabel {
    
    if (!_totalBalanceLabel) {
        
        _totalBalanceLabel = [[UILabel alloc] init];
        _totalBalanceLabel.textColor = [UIColor whiteColor];
        _totalBalanceLabel.font = [UIFont systemFontOfSize:14.0f];
        _totalBalanceLabel.text = @"总收入(元)";
    }
    
    return _totalBalanceLabel;
}

- (UILabel *)totalBalanceNumberLabel {
    
    if (!_totalBalanceNumberLabel) {
        
        _totalBalanceNumberLabel = [[UILabel alloc] init];
        _totalBalanceNumberLabel.textColor = [UIColor whiteColor];
        _totalBalanceNumberLabel.font = [UIFont systemFontOfSize:30.0f];
    }
    
    return _totalBalanceNumberLabel;
}

@end








