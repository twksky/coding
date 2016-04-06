//
//  DoctorInfoViewItemCell.m
//  AppFramework
//
//  Created by tianxiewuhua on 15/5/12.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "DoctorInfoViewItemCell.h"
#import "UIView+AutoLayout.h"

@interface DoctorInfoViewItemCell ()

@property (nonatomic, strong) UIImageView *seeIconImageView;

@end

@implementation DoctorInfoViewItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupViews];
    }
    
    return self;
}

- (void)setupViews {
    
    [self addSubview:self.itemIconImageView];
    [self addSubview:self.itemTitleLabel];
    [self addSubview:self.seeIconImageView];
    
    //AutoLayout
    {
        [self addConstraint:[self.itemIconImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:15.0f]];
        [self addConstraint:[self.itemIconImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
        [self addConstraint:[self.itemIconImageView autoSetDimension:ALDimensionWidth toSize:23.0f]];
        [self addConstraint:[self.itemIconImageView autoSetDimension:ALDimensionHeight toSize:23.0f]];
        
        [self addConstraint:[self.itemTitleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.itemIconImageView withOffset:25.0f]];
        [self addConstraint:[self.itemTitleLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
        
        [self addConstraint:[self.seeIconImageView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView withOffset:-15.0f]];
        [self addConstraint:[self.seeIconImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
        [self addConstraint:[self.seeIconImageView autoSetDimension:ALDimensionHeight toSize:20.0f]];
        [self addConstraint:[self.seeIconImageView autoSetDimension:ALDimensionWidth toSize:20.0f]];
    }
}

#pragma mark - properties

- (UIImageView *)itemIconImageView {
    
    if (!_itemIconImageView) {
        
        _itemIconImageView = [[UIImageView alloc] init];
    }
    
    return _itemIconImageView;
}

- (UILabel *)itemTitleLabel {
    
    if (!_itemTitleLabel) {
        
        _itemTitleLabel = [[UILabel alloc] init];
        _itemTitleLabel.textColor = [UIColor blackColor];
        _itemTitleLabel.font = [UIFont systemFontOfSize:17.0f];
    }
    
    return _itemTitleLabel;
}

- (UIImageView *)seeIconImageView {
    
    if (!_seeIconImageView) {
        
        _seeIconImageView = [[UIImageView alloc] init];
        [_seeIconImageView setImage:[UIImage imageNamed:@"see_icon"]];
    }
    
    return _seeIconImageView;
}

@end
