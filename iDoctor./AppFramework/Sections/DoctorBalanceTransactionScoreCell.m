//
//  DoctorBalanceTransactionScoreCell.m
//  AppFramework
//
//  Created by 张丽 on 15/7/3.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "DoctorBalanceTransactionScoreCell.h"
#import "ScoreModel.h"
#import "UIView+AutoLayout.h"



@interface DoctorBalanceTransactionScoreCell()

/**
 *  描述
 */
@property (nonatomic, strong) UILabel *transactionTitleLabel;

/**
 *  总数
 */
@property (nonatomic, strong) UILabel *transactionCountLabel;

/**
 *  时间
 */
@property (nonatomic, strong) UILabel *transactionDateLabel;

@end


@implementation DoctorBalanceTransactionScoreCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    
    if (self) {
        
        [self setUpViews];
    }
    
    return self;
}

- (void)setUpViews
{
    [self.contentView addSubview:self.transactionTitleLabel];
    [self.contentView addSubview:self.transactionCountLabel];
    [self.contentView addSubview:self.transactionDateLabel];
    
    // AutoLayoout
    {
        /**
         *  标题的约束
         */
        [self addConstraint:[self.transactionTitleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:15.0f]]; // 左边15
        [self addConstraint:[self.transactionTitleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:20.0f]]; // 上边10
        
        /**
         *  总数的约束
         */
        
        [self addConstraint:[self.transactionCountLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.transactionTitleLabel withOffset:10.0f]];
        [self addConstraint:[self.transactionCountLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20.0f]];
        
        /**
         *  时间的约束
         */
        [self addConstraint:[self.transactionDateLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20.0f]];
        [self addConstraint:[self.transactionDateLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f]];
    }
    
}

#pragma mark - 懒加载
// 标题
- (UILabel *)transactionTitleLabel
{
    if (!_transactionTitleLabel) {
        
        _transactionTitleLabel = [[UILabel alloc] init];
        _transactionTitleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
        _transactionTitleLabel.textColor = [UIColor blackColor];
        
    }
    
    return _transactionTitleLabel;
}

// 总数
- (UILabel *)transactionCountLabel
{
    if (!_transactionCountLabel) {
        _transactionCountLabel = [[UILabel alloc] init];
        _transactionCountLabel.font = [UIFont systemFontOfSize:17.0f];
        _transactionCountLabel.textColor = UIColorFromRGB(0x54d0b8);
    }
    
    return _transactionCountLabel;
}

// 时间
- (UILabel *)transactionDateLabel
{
    if (!_transactionDateLabel) {
        _transactionDateLabel = [[UILabel alloc] init];
        _transactionDateLabel.font = [UIFont systemFontOfSize:14.0f];
        _transactionDateLabel.textColor = UIColorFromRGB(0xbfc0c0);
    }
    
    return _transactionDateLabel;
}


- (void)loadDataWithScoreModel:(ScoreModel *)score
{
    self.transactionTitleLabel.text = score.scoreDescription;
    self.transactionCountLabel.text = [NSString stringWithFormat:@"%d 分", (int)score.count];
    
    // 得到时间 不需要年月日
    NSRange range = [score.scoreCtimeIso rangeOfString:@" "];
    
    NSString *date = [score.scoreCtimeIso substringFromIndex:range.location + 1];
    self.transactionDateLabel.text = date;
    
}

@end
