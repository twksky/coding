//
//  DoctorCreditHeaderView.m
//  AppFramework
//
//  Created by tianxiewuhua on 15/5/13.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "DoctorCreditHeaderView.h"
#import <PureLayout.h>
#import "ImageUtils.h"

@interface DoctorCreditHeaderView ()

@property (nonatomic, strong) UILabel *creditLabel;
@property (nonatomic, strong) UIImageView *helpIcon;

@property (nonatomic, strong) UIButton *spendCreditButton;
@property (nonatomic, strong) UIButton *earnCreditButton;

@end


@implementation DoctorCreditHeaderView

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
    
    self.backgroundColor = UIColorFromRGB(0x33d2b4);
    
    [self addSubview:self.creditLabel];
    [self addSubview:self.helpIcon];
    [self addSubview:self.creditNumberLabel];
    [self addSubview:self.spendCreditButton];
    [self addSubview:self.earnCreditButton];
    
    //AutoLayout
    {
        [self addConstraints:[bgImageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero]];
        
        [self addConstraint:[self.creditLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:18.0f]];
        [self addConstraint:[self.creditLabel autoAlignAxisToSuperviewAxis:ALAxisVertical]];
        
        [self addConstraint:[self.creditNumberLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.creditLabel withOffset:13.0f]];
        [self addConstraint:[self.creditNumberLabel autoAlignAxisToSuperviewAxis:ALAxisVertical]];
        
        [self addConstraint:[self.helpIcon autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:18.0f]];
        [self addConstraint:[self.helpIcon autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:18.0f]];
        [self addConstraint:[self.helpIcon autoSetDimension:ALDimensionWidth toSize:20.0f]];
        [self addConstraint:[self.helpIcon autoSetDimension:ALDimensionHeight toSize:20.0f]];
        
        [self addConstraint:[self.spendCreditButton autoPinEdgeToSuperviewEdge:ALEdgeLeft]];
        [self addConstraints:[self.spendCreditButton autoSetDimensionsToSize:CGSizeMake(App_Frame_Width / 2, 50.0f)]];
        [self addConstraint:[self.spendCreditButton autoPinEdgeToSuperviewEdge:ALEdgeBottom]];
        
        [self addConstraint:[self.earnCreditButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.spendCreditButton]];
        [self addConstraints:[self.earnCreditButton autoSetDimensionsToSize:CGSizeMake(App_Frame_Width / 2, 50.0f)]];
        [self addConstraint:[self.earnCreditButton autoPinEdgeToSuperviewEdge:ALEdgeBottom]];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor whiteColor];
        [self addSubview:line];
        
        [self addConstraints:[line autoSetDimensionsToSize:CGSizeMake(1.0f, 50.0f)]];
        [self addConstraint:[line autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.spendCreditButton]];
        [self addConstraint:[line autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.spendCreditButton]];
    }
    
}

#pragma mark - set Button Action API

- (void)setSpendCreditButtonAction:(SEL)action withTarget:(id)target {
    
    [self.spendCreditButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)setEarnCreditButtonAction:(SEL)action withTarget:(id)target {
    
    [self.earnCreditButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - properties

- (UILabel *)creditLabel {
    
    if (!_creditLabel) {
        
        _creditLabel = [[UILabel alloc] init];
        _creditLabel.font = [UIFont systemFontOfSize:14.0f];
        _creditLabel.textColor = [UIColor whiteColor];
        _creditLabel.text = @"我的积分";
    }
    
    return _creditLabel;
}

- (UILabel *)creditNumberLabel {
    
    if (!_creditNumberLabel) {
        
        _creditNumberLabel = [[UILabel alloc] init];
        _creditNumberLabel.font = [UIFont systemFontOfSize:57.0f];
        _creditNumberLabel.textColor = [UIColor whiteColor];
    }
    
    return _creditNumberLabel;
}

- (UIImageView *)helpIcon {
    
    if (!_helpIcon) {
        
        _helpIcon = [[UIImageView alloc] init];
        [_helpIcon setImage:[UIImage imageNamed:@"icon_doctorcredit_help"]];
        [_helpIcon setHidden:YES];
    }
    
    return _helpIcon;
}

- (UIButton *)spendCreditButton {
    
    if (!_spendCreditButton) {
        
        _spendCreditButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _spendCreditButton.backgroundColor = UIColorFromRGB(0x11ad9c);
        _spendCreditButton.titleLabel.textColor = [UIColor whiteColor];
        [_spendCreditButton setTitle:@"花积分" forState:UIControlStateNormal];
    }
    
    return _spendCreditButton;
}

- (UIButton *)earnCreditButton {
    
    if (!_earnCreditButton) {
        
        _earnCreditButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _earnCreditButton.backgroundColor = UIColorFromRGB(0x11ad9c);
        _earnCreditButton.titleLabel.textColor = [UIColor whiteColor];
        [_earnCreditButton setTitle:@"赚积分" forState:UIControlStateNormal];
    }
    
    return _earnCreditButton;
}

@end
