//
//  MyCardCellTableViewCell.m
//  AppFramework
//
//  Created by 周世阳 on 15/5/11.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "MyCardCellTableViewCell.h"
#import "UIView+AutoLayout.h"
#import "SkinManager.h"

@interface MyCardCellTableViewCell ()

@property (nonatomic, strong) UILabel *myCardLabel;
@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation MyCardCellTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupViews];
    }
    
    return self;
}

- (void)setupViews {
    
    UIView *imageContainer = [[UIView alloc] initWithFrame:CGRectZero];
    imageContainer.layer.borderColor = [UIColorFromRGB(0x2B7FD8) CGColor];
    imageContainer.layer.borderWidth = 1.0f;
    imageContainer.layer.cornerRadius = 9.0f;
    
    [imageContainer addSubview:self.barCodeImageView];
    
    [self addSubview:imageContainer];
    [self addSubview:self.myCardLabel];
    [self addSubview:self.tipLabel];
    
    //AutoLayout
    {
        [self addConstraint:[imageContainer autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:17.5f]];
        [self addConstraint:[imageContainer autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:App_Frame_Width / 5]];
        [self addConstraint:[imageContainer autoSetDimension:ALDimensionWidth toSize:65.0f]];
        [self addConstraint:[imageContainer autoSetDimension:ALDimensionHeight toSize:65.0f]];
        
        [imageContainer addConstraint:[self.barCodeImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
        [imageContainer addConstraint:[self.barCodeImageView autoAlignAxisToSuperviewAxis:ALAxisVertical]];
        [imageContainer addConstraint:[self.barCodeImageView autoSetDimension:ALDimensionWidth toSize:60]];
        [imageContainer addConstraint:[self.barCodeImageView autoSetDimension:ALDimensionHeight toSize:60]];
        
        [self addConstraint:[self.myCardLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.barCodeImageView withOffset:10.0f]];
        [self addConstraint:[self.myCardLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.barCodeImageView withOffset:10.0f]];
        
        [self addConstraint:[self.tipLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.barCodeImageView withOffset:10.0f]];
        [self addConstraint:[self.tipLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.barCodeImageView withOffset:-10.0f]];
    }
}

#pragma mark - properties

- (UIImageView *)barCodeImageView {
    
    if (!_barCodeImageView) {
        
        _barCodeImageView = [[UIImageView alloc] init];
        [_barCodeImageView setImage:[SkinManager sharedInstance].defaultContactAvatarIcon]; //test
    }
    
    return _barCodeImageView;
}

- (UILabel *)myCardLabel {
    
    if (!_myCardLabel) {
        
        _myCardLabel = [[UILabel alloc] init];
        _myCardLabel.textColor = [UIColor blackColor];
        [_myCardLabel setText:@"我的名片"];
        _myCardLabel.font = [UIFont systemFontOfSize:17.0f];
    }
    
    return _myCardLabel;
}

- (UILabel *)tipLabel {
    
    if (!_tipLabel) {
        
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textColor = UIColorFromRGB(0x8e8e91);
        [_tipLabel setText:@"让患者微信扫一扫"];
        _tipLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    
    return _tipLabel;
}

@end
