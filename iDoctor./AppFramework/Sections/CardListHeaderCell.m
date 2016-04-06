//
//  CardListHeaderCell.m
//  AppFramework
//
//  Created by 周世阳 on 15/5/14.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "CardListHeaderCell.h"
#import "UIView+AutoLayout.h"

@interface CardListHeaderCell ()

@end

@implementation CardListHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupViews];
    }
    
    return self;
}

- (void)setupViews {
    
    UIImageView *addCardIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_add_card"]];
    UILabel *addCardTitleLabel = [[UILabel alloc] init];
    addCardTitleLabel.textColor = UIColorFromRGB(0x41b29c);
    addCardTitleLabel.font = [UIFont systemFontOfSize:17.0f];
    addCardTitleLabel.text = @"添加银行卡";
    
    [self addSubview:addCardIconImageView];
    [self addSubview:addCardTitleLabel];
    
    //AutoLayout
    {
        [self addConstraint:[addCardIconImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
        [self addConstraint:[addCardIconImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15.0f]];
        [self addConstraint:[addCardIconImageView autoSetDimension:ALDimensionWidth toSize:20.0f]];
        [self addConstraint:[addCardIconImageView autoSetDimension:ALDimensionHeight toSize:20.0f]];
        
        [self addConstraint:[addCardTitleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:addCardIconImageView withOffset:10.0f]];
        [self addConstraint:[addCardTitleLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
    }
}


@end
