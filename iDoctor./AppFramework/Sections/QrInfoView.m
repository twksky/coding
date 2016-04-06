//
//  QrInfoView.m
//  AppFramework
//
//  Created by 周世阳 on 15/6/23.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "QrInfoView.h"
#import "Account.h"
#import <PureLayout.h>
#import <UIImageView+WebCache.h>
#import "HospitalItem.h"

@interface QrInfoView ()

@property (nonatomic, strong) UIView *qrCodeContainerView;
@property (nonatomic, strong) UIImageView *qrCodeImageView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *docIdLabel;
@property (nonatomic, strong) UILabel *hospitalLabel;

@end

@implementation QrInfoView

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        [self setupViews];
    }
    
    return self;
}

- (void)setupViews {
    
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    
    [self addSubview:self.qrCodeContainerView];
    {
        [self addConstraints:[self.qrCodeContainerView autoSetDimensionsToSize:CGSizeMake(App_Frame_Width - 20.0f, 400.0f)]];
        [self addConstraint:[self.qrCodeContainerView autoAlignAxisToSuperviewAxis:ALAxisVertical]];
        [self addConstraint:[self.qrCodeContainerView autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
    }
    
    [self.qrCodeContainerView addSubview:self.tipLabel];
    {
        [self addConstraint:[self.tipLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:30.0f]];
        [self addConstraint:[self.tipLabel autoAlignAxisToSuperviewAxis:ALAxisVertical]];
    }
    
    [self.qrCodeContainerView addSubview:self.qrCodeImageView];
    {
        [self addConstraints:[self.qrCodeImageView autoSetDimensionsToSize:CGSizeMake(200.0f, 200.0f)]];
        [self addConstraint:[self.qrCodeImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.tipLabel withOffset:10.0f]];
        [self addConstraint:[self.qrCodeImageView autoAlignAxisToSuperviewAxis:ALAxisVertical]];
    }
    
    [self.qrCodeContainerView addSubview:self.nameLabel];
    {
        [self addConstraint:[self.nameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.qrCodeImageView withOffset:10.0f]];
        [self addConstraint:[self.nameLabel autoAlignAxisToSuperviewAxis:ALAxisVertical]];
    }
    
    [self.qrCodeContainerView addSubview:self.docIdLabel];
    {
        [self addConstraint:[self.docIdLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.nameLabel withOffset:10.0f]];
        [self addConstraint:[self.docIdLabel autoAlignAxisToSuperviewAxis:ALAxisVertical]];
    }
    
    [self.qrCodeContainerView addSubview:self.hospitalLabel];
    {
        [self addConstraint:[self.hospitalLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.docIdLabel withOffset:10.0f]];
        [self addConstraint:[self.hospitalLabel autoAlignAxisToSuperviewAxis:ALAxisVertical]];
    }
    
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissSelf:)];
    [self addGestureRecognizer:tapGesture];
}

#pragma mark - selector

- (void)dismissSelf:(id)sender {
    
    [self removeFromSuperview];
}

#pragma mark - loadData

- (void)loadDataWithAccount:(Account *)account {
    
    [self.qrCodeImageView sd_setImageWithURL:[NSURL URLWithString:account.qCodeImageUrlString]];
    
    self.nameLabel.text = [account getDisplayName];
    self.docIdLabel.text = [NSString stringWithFormat:@"医生号: %ld", account.accountID];
    self.hospitalLabel.text = account.hospital.name;
}

#pragma mark - properties

- (UIView *)qrCodeContainerView {
    
    if (!_qrCodeContainerView) {
        
        _qrCodeContainerView = [[UIView alloc] init];
        _qrCodeContainerView.backgroundColor = [UIColor whiteColor];
    }
    
    return _qrCodeContainerView;
}

- (UILabel *)tipLabel {
    
    if (!_tipLabel) {
        
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font = [UIFont systemFontOfSize:16.0f];
        _tipLabel.textColor = [UIColor blackColor];
        _tipLabel.text = @"让患者微信扫一扫";
    }
    
    return _tipLabel;
}

- (UIImageView *)qrCodeImageView {
    
    if (!_qrCodeImageView) {
        
        _qrCodeImageView = [[UIImageView alloc] init];
    }
    
    return _qrCodeImageView;
}

- (UILabel *)nameLabel {
    
    if (!_nameLabel) {
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont boldSystemFontOfSize:19.0f];
        _nameLabel.textColor = [UIColor blackColor];
    }
    
    return _nameLabel;
}

- (UILabel *)docIdLabel {
    
    if (!_docIdLabel) {
        
        _docIdLabel = [[UILabel alloc] init];
        _docIdLabel.font = [UIFont systemFontOfSize:16.0f];
        _docIdLabel.textColor = UIColorFromRGB(0x8e8d93);
    }
    
    return _docIdLabel;
}

- (UILabel *)hospitalLabel {
    
    if (!_hospitalLabel) {
        
        _hospitalLabel = [[UILabel alloc] init];
        _hospitalLabel.font = [UIFont systemFontOfSize:16.0f];
        _hospitalLabel.textColor = UIColorFromRGB(0x8e8d93);
    }
    
    return _hospitalLabel;
}


@end
