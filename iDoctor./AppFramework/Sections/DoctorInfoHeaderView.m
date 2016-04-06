//
//  DoctorInfoHeaderView.m
//  AppFramework
//
//  Created by tianxiewuhua on 15/5/12.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "DoctorInfoHeaderView.h"
#import "SkinManager.h"
#import "UIView+AutoLayout.h"
#import "UIClickableView.h"
#import "Account.h"
#import "UIImageView+WebCache.h"
#import "AccountManager.h"
#import "ImageUtils.h"

@interface DoctorInfoHeaderView ()

@property (nonatomic, strong) UIClickableView *balanceView;
@property (nonatomic, strong) UIClickableView *creditView;

@property (nonatomic, strong) UILabel *balanceLabel;
@property (nonatomic, strong) UILabel *creditLabel;

@property (nonatomic, strong) UILabel *balanceNumberLabel;
@property (nonatomic, strong) UILabel *creditNumberLabel;

@end


@implementation DoctorInfoHeaderView

- (instancetype)init {
    
    self = [super init];
    if (self) {
    
        [self setupSubViews];
    }
    
    return self;
}

- (void)setupSubViews {

    self.backgroundColor = [SkinManager sharedInstance].defaultNavigationBarBackgroundColor;

    [self addSubview:self.doctorAvatarImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.docIdLabel];
    
    self.balanceView = [[UIClickableView alloc] init];
//    balanceView.backgroundColor = UIColorFromRGB(0x33d2b4);
    [self.balanceView addSubview:self.balanceLabel];
    [self.balanceView addSubview:self.balanceNumberLabel];
    
    self.balanceView.normalStateBackGroundColor = UIColorFromRGB(0x11ad9c);
    self.balanceView.hightlightStateBackGroundColor = UIColorFromRGB(0x2aa98f);
    
     self.creditView = [[UIClickableView alloc] init];
//    creditView.backgroundColor = UIColorFromRGB(0x479cea);
    [self.creditView addSubview:self.creditLabel];
    [self.creditView addSubview:self.creditNumberLabel];
    
    self.creditView.normalStateBackGroundColor = UIColorFromRGB(0x11ad9c);
    self.creditView.hightlightStateBackGroundColor = UIColorFromRGB(0x2aa98f);
    
    //TODO 测试
//    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Actiondo:)];
//    [self.balanceView addGestureRecognizer:tapGesture];
    
    [self addSubview:self.balanceView];
    [self addSubview:self.creditView];
    
    UIImageView *line = [[UIImageView alloc] initWithImage:[ImageUtils createImageWithColor:UIColorFromRGB(0x16c5a4)]];
    [self addSubview:line];
    
    //AutoLayout
    {
        [self addConstraint:[self.doctorAvatarImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:10.0f]];
        [self addConstraint:[self.doctorAvatarImageView autoAlignAxisToSuperviewAxis:ALAxisVertical]];
        [self addConstraint:[self.doctorAvatarImageView autoSetDimension:ALDimensionHeight toSize:109.0f]];
        [self addConstraint:[self.doctorAvatarImageView autoSetDimension:ALDimensionWidth toSize:109.0f]];
        
        [self addConstraint:[self.nameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.doctorAvatarImageView withOffset:10.0f]];
        [self addConstraint:[self.nameLabel autoAlignAxisToSuperviewAxis:ALAxisVertical]];
        
        [self addConstraint:[self.docIdLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.nameLabel withOffset:5.0f]];
        [self addConstraint:[self.docIdLabel autoAlignAxisToSuperviewAxis:ALAxisVertical]];
        
        [self addConstraint:[self.balanceView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self]];
        [self addConstraint:[self.balanceView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self]];
        [self addConstraint:[self.balanceView autoSetDimension:ALDimensionHeight toSize:45.0f]];
        [self addConstraint:[self.balanceView autoSetDimension:ALDimensionWidth toSize:App_Frame_Width / 2]];
        
        [self addConstraint:[self.creditView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self]];
        [self addConstraint:[self.creditView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self]];
        [self addConstraint:[self.creditView autoSetDimension:ALDimensionHeight toSize:45.0f]];
        [self addConstraint:[self.creditView autoSetDimension:ALDimensionWidth toSize:App_Frame_Width / 2]];
        
        [self.balanceView addConstraint:[self.balanceLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.balanceView withOffset:15.0f]];
        [self.balanceView addConstraint:[self.balanceLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
        [self.balanceView addConstraint:[self.balanceNumberLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.balanceView withOffset:-15.0f]];
        [self.balanceView addConstraint:[self.balanceNumberLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
        
        [self.creditView addConstraint:[self.creditLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.creditView withOffset:15.0f]];
        [self.creditView addConstraint:[self.creditLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
        [self.creditView addConstraint:[self.creditNumberLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.creditView withOffset:-15.0f]];
        [self.creditView addConstraint:[self.creditNumberLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
        
        [self addConstraints:[line autoSetDimensionsToSize:CGSizeMake(1.0f, 45.0f)]];
        [self addConstraint:[line autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.balanceView]];
        [self addConstraint:[line autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.balanceView]];
    }
}

#pragma mark - setAction for BalanceView and CreditView

- (void)addHeaderViewTarget:(id)target action:(SEL)action {
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tapGesture];
}


- (void)addBalanceViewTarget:(id)target action:(SEL)action {
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self.balanceView addGestureRecognizer:tapGesture];
}

- (void)addCreditViewTarget:(id)target action:(SEL)action {
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self.creditView addGestureRecognizer:tapGesture];
}

#pragma mark - properties

- (UIImageView *)doctorAvatarImageView {
    
    if (!_doctorAvatarImageView) {
        
        _doctorAvatarImageView = [[UIImageView alloc] init];
        _doctorAvatarImageView.layer.borderColor = [UIColorFromRGB(0x69e2cb) CGColor];
        _doctorAvatarImageView.layer.borderWidth = 5.0f;
        _doctorAvatarImageView.layer.cornerRadius = 54.5f;
        _doctorAvatarImageView.layer.masksToBounds = YES;
    }
    
    return _doctorAvatarImageView;
}

- (UILabel *)nameLabel {
    
    if (!_nameLabel) {
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont boldSystemFontOfSize:17.0f];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _nameLabel;
}

- (UILabel *)docIdLabel {
    
    if (!_docIdLabel) {
        
        _docIdLabel = [[UILabel alloc] init];
        _docIdLabel.textColor = [UIColor whiteColor];
        _docIdLabel.font = [UIFont systemFontOfSize:14.0f];
        _docIdLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _docIdLabel;
}

- (UILabel *)balanceLabel {
    
    if (!_balanceLabel) {
        
        _balanceLabel = [[UILabel alloc] init];
        _balanceLabel.textColor = [UIColor whiteColor];
        _balanceLabel.font = [UIFont systemFontOfSize:17.0f];
        _balanceLabel.textAlignment = NSTextAlignmentLeft;
        _balanceLabel.text = @"余额";
    }
    
    return _balanceLabel;
}

- (UILabel *)balanceNumberLabel {
    
    if (!_balanceNumberLabel) {
        
        _balanceNumberLabel = [[UILabel alloc] init];
        _balanceNumberLabel.textColor = [UIColor whiteColor];
        _balanceNumberLabel.font = [UIFont systemFontOfSize:17.0f];
        _balanceNumberLabel.textAlignment = NSTextAlignmentRight;
        _balanceNumberLabel.text = @"-.--";
    }
    
    return _balanceNumberLabel;
}

- (UILabel *)creditLabel {
    
    if (!_creditLabel) {
        
        _creditLabel = [[UILabel alloc] init];
        _creditLabel.textColor = [UIColor whiteColor];
        _creditLabel.font = [UIFont systemFontOfSize:17.0f];
        _creditLabel.textAlignment = NSTextAlignmentLeft;
        _creditLabel.text = @"积分";
    }
    
    return _creditLabel;
}

- (UILabel *)creditNumberLabel {
    
    if (!_creditNumberLabel) {
        
        _creditNumberLabel = [[UILabel alloc] init];
        _creditNumberLabel.textColor = [UIColor whiteColor];
        _creditNumberLabel.font = [UIFont systemFontOfSize:17.0f];
        _creditNumberLabel.textAlignment = NSTextAlignmentRight;
        _creditNumberLabel.text = @"-";
    }
    
    return _creditNumberLabel;
}

- (void)loadDataWithAccount:(Account *)account {
    
    [self.doctorAvatarImageView sd_setImageWithURL:[NSURL URLWithString:account.avatarImageURLString] placeholderImage:[SkinManager sharedInstance].defaultDoctorInfoAvatar];
    self.nameLabel.text = [account getDisplayName];
    self.docIdLabel.text = [NSString stringWithFormat:@"医生号: %lu", account.accountID];
    self.creditNumberLabel.text = [NSString stringWithFormat:@"%ld分", account.score];
    self.balanceNumberLabel.text = [NSString stringWithFormat:@"%.02f元", (CGFloat)(account.balance / 100.0f)];
}


@end






