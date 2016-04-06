//
//  UserGiftRecordTableViewCell.m
//  AppFramework
//
//  Created by ABC on 8/24/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "UserGiftRecordTableViewCell.h"
#import "UIView+Autolayout.h"
#import "GiftItem.h"
#import "SkinManager.h"

@interface UserGiftRecordTableViewCell ()

@property (nonatomic, strong) UILabel *giftNumberLabel;
@property (nonatomic, strong) UILabel *giftValueLabel;
@property (nonatomic, strong) UILabel *giftStateLabel;
@property (nonatomic, strong) UILabel *timeLabel;

- (void)setupSubviews;
- (void)setupConstraints;

@end

@implementation UserGiftRecordTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setupSubviews];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - Property

- (UILabel *)giftNumberLabel
{
    if (!_giftNumberLabel) {
        _giftNumberLabel = [[UILabel alloc] init];
        _giftNumberLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
        _giftNumberLabel.textAlignment = NSTextAlignmentCenter;
        _giftNumberLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _giftNumberLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = UIColorFromRGB(0x8e8d93);
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    return _timeLabel;
}

- (UILabel *)giftValueLabel {
    
    if (!_giftValueLabel) {
        
        _giftValueLabel = [[UILabel alloc] init];
        _giftValueLabel.font = [UIFont systemFontOfSize:17.0f];
        _giftValueLabel.textColor = [UIColor blackColor];
    }
    
    return _giftValueLabel;
}

- (UILabel *)giftStateLabel {
    
    if (!_giftStateLabel) {
        
        _giftStateLabel = [[UILabel alloc] init];
        _giftStateLabel.font = [UIFont systemFontOfSize:12.0f];
        _giftStateLabel.textColor = UIColorFromRGB(0x8e8d93);
    }
    
    return _giftStateLabel;
}


#pragma mark - Public Method

- (void)setGiftRecord:(GiftItem *)giftItem
{
    self.giftNumberLabel.text = [NSString stringWithFormat:@"%ld朵花", giftItem.number];
    self.timeLabel.text = giftItem.dateTimeISO;
    self.giftValueLabel.text = [NSString stringWithFormat:@"%.02f", giftItem.money / 100.0f];
    if (giftItem.acceptState) {
        
        self.giftStateLabel.text = @"送花成功";
    }
    else {
        
        self.giftStateLabel.text = @"送花失败"; //TODO 失败
    }
}


#pragma mark - Private Method

- (void)setupSubviews
{
    [self.contentView addSubview:self.giftNumberLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.giftValueLabel];
    [self.contentView addSubview:self.giftStateLabel];
    
    [self setupConstraints];
}

- (void)setupConstraints
{
    [self.contentView addConstraint:[self.giftNumberLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f]];
    [self.contentView addConstraint:[self.giftNumberLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f]];
    
    [self.contentView addConstraint:[self.timeLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f]];
    [self.contentView addConstraint:[self.timeLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f]];
    
    [self.contentView addConstraint:[self.giftValueLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f]];
    [self.contentView addConstraint:[self.giftValueLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f]];
    
    [self.contentView addConstraint:[self.giftStateLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f]];
    [self.contentView addConstraint:[self.giftStateLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f]];
}

@end








