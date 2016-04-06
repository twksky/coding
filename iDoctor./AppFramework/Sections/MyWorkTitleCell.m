//
//  MyWorkTitleCell.m
//  AppFramework
//
//  Created by 周世阳 on 15/5/11.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "MyWorkTitleCell.h"
#import "UIView+AutoLayout.h"

@interface MyWorkTitleCell()

@end

@implementation MyWorkTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupViews];
    }
    
    return self;
}

- (void)setupViews {
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.titleImageView];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = UIColorFromRGB(0xd4d4d4);
    
    [self addSubview:line];
    
    //AutoLayout
    {
        [self addConstraint:[self.titleImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
        [self addConstraint:[self.titleImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:15.0f]];
        [self addConstraint:[self.titleImageView autoSetDimension:ALDimensionWidth toSize:22.0f]];
        [self addConstraint:[self.titleImageView autoSetDimension:ALDimensionHeight toSize:22.0f]];
        
        [self addConstraint:[self.titleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.titleImageView withOffset:15.0f]];
        [self addConstraint:[self.titleLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
        
        [self addConstraint:[line autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView]];
        [self addConstraint:[line autoSetDimension:ALDimensionHeight toSize:0.5f]];
        [self addConstraint:[line autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:15.0f]];
        [self addConstraint:[line autoSetDimension:ALDimensionWidth toSize:App_Frame_Width - 15.0f]];
    }
}

#pragma mark - properties

- (UIImageView *)titleImageView {
    
    if (!_titleImageView) {
        
        _titleImageView = [[UIImageView alloc] init];
    }
    
    return _titleImageView;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = UIColorFromRGB(0x8e8e91);
        _titleLabel.font = [UIFont systemFontOfSize:17.0f];
    }
    
    return _titleLabel;
}

@end
