//
//  CardListCardCellTableViewCell.m
//  AppFramework
//
//  Created by 周世阳 on 15/5/14.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "CardListCardCell.h"
#import "UIView+AutoLayout.h"

@interface CardListCardCell ()

@property (nonatomic, strong) UIImageView *cardIcon;
@property (nonatomic, strong) UIImageView *selectedImage;

@end


@implementation CardListCardCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupViews];
    }
    
    return self;
}

- (void)select:(id)sender {
    
    [self.selectedImage setHidden:NO];
}

- (void)setupViews {
    
    [self addSubview:self.cardIcon];
    [self addSubview:self.bankNameLabel];
    [self addSubview:self.cardNumberLabel];
    [self addSubview:self.selectedImage];
    
    //AutoLayout
    {
        [self addConstraint:[self.cardIcon autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15.0f]];
        [self addConstraint:[self.cardIcon autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f]];
        [self addConstraint:[self.cardIcon autoSetDimension:ALDimensionHeight toSize:15.0f]];
        [self addConstraint:[self.cardIcon autoSetDimension:ALDimensionWidth toSize:20.0f]];
        
        [self addConstraint:[self.bankNameLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.cardIcon]];
        [self addConstraint:[self.bankNameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.cardIcon withOffset:10.0f]];
        
        [self addConstraint:[self.cardNumberLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.bankNameLabel withOffset:3.0f]];
        [self addConstraint:[self.cardNumberLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.bankNameLabel]];
        
        [self addConstraint:[self.selectedImage autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20.0f]];
        [self addConstraint:[self.selectedImage autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
        [self addConstraint:[self.selectedImage autoSetDimension:ALDimensionHeight toSize:10.0f]];
        [self addConstraint:[self.selectedImage autoSetDimension:ALDimensionWidth toSize:12.0f]];
        
    }
}


- (UIImageView *)cardIcon {
    
    if (!_cardIcon) {
        
        _cardIcon = [[UIImageView alloc] init];
        [_cardIcon setImage:[UIImage imageNamed:@"icon_bank_card"]];
    }
    
    return _cardIcon;
}

- (UILabel *)bankNameLabel {
    
    if (!_bankNameLabel) {
        
        _bankNameLabel = [[UILabel alloc] init];
        _bankNameLabel.font = [UIFont systemFontOfSize:17.0];
        _bankNameLabel.textColor = UIColorFromRGB(0x333333);
    }
    
    return _bankNameLabel;
}

- (UILabel *)cardNumberLabel {
    
    if (!_cardNumberLabel) {
        
        _cardNumberLabel = [[UILabel alloc] init];
        _cardNumberLabel.font = [UIFont systemFontOfSize:13.0f];
        _cardNumberLabel.textColor = UIColorFromRGB(0x8e8e93);
    }
    
    return _cardNumberLabel;
}

- (UIImageView *)selectedImage {
    
    if (!_selectedImage) {
        
        _selectedImage = [[UIImageView alloc] init];
        [_selectedImage setImage:[UIImage imageNamed:@"icon_card_selected"]];
        [_selectedImage setHidden:YES];
    }
    
    return _selectedImage;
}

@end







