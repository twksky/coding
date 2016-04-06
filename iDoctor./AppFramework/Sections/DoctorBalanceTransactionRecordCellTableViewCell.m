//
//  DoctorBalanceTransactionRecordCellTableViewCell.m
//  AppFramework
//
//  Created by tianxiewuhua on 15/5/13.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "DoctorBalanceTransactionRecordCellTableViewCell.h"
#import "UIView+AutoLayout.h"
#import "Payments.h"
#import "ScoreModel.h"

@interface DoctorBalanceTransactionRecordCellTableViewCell ()

@property (nonatomic, strong) UILabel *transactionTitleLabel;
@property (nonatomic, strong) UILabel *transactionDateLabel;
@property (nonatomic, strong) UILabel *transactionValueLabel;
@property (nonatomic, strong) UILabel *transactionStateLabel;

@end



@implementation DoctorBalanceTransactionRecordCellTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupViews];
    }
    
    return self;
}



- (void)setupViews {
    
    [self addSubview:self.transactionTitleLabel];
    [self addSubview:self.transactionDateLabel];
    [self addSubview:self.transactionValueLabel];
    [self addSubview:self.transactionStateLabel];
    
    //AutoLayout
    {
        [self addConstraint:[self.transactionTitleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:15.0f]];
        [self addConstraint:[self.transactionTitleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:20.0f]];
        
        [self addConstraint:[self.transactionDateLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.transactionTitleLabel withOffset:10.0f]];
        [self addConstraint:[self.transactionDateLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:15.0f]];
        
        [self addConstraint:[self.transactionValueLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:20.0f]];
        [self addConstraint:[self.transactionValueLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0f]];
        
        [self addConstraint:[self.transactionStateLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.transactionValueLabel withOffset:10.0f]];
        [self addConstraint:[self.transactionStateLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:15.0f]];
        
    }
}

#pragma mark - properties

- (UILabel *)transactionTitleLabel {
    
    if (!_transactionTitleLabel) {
        
        _transactionTitleLabel = [[UILabel alloc] init];
        _transactionTitleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
        _transactionTitleLabel.textColor = [UIColor blackColor];
    }
    
    return _transactionTitleLabel;
}

- (UILabel *)transactionDateLabel {
    
    if (!_transactionDateLabel) {
        
        _transactionDateLabel = [[UILabel alloc] init];
        _transactionDateLabel.font = [UIFont systemFontOfSize:14.0f];
        _transactionDateLabel.textColor = UIColorFromRGB(0x8f8e94);
    }
    
    return _transactionDateLabel;
}

- (UILabel *)transactionValueLabel {
    
    if (!_transactionValueLabel) {
        _transactionValueLabel = [[UILabel alloc] init];
        _transactionValueLabel.font = [UIFont systemFontOfSize:17.0f];
        _transactionValueLabel.textColor = [UIColor blackColor];
    }
    
    return _transactionValueLabel;
}

- (UILabel *)transactionStateLabel {
    
    if (!_transactionStateLabel) {
        
        _transactionStateLabel = [[UILabel alloc] init];
        _transactionStateLabel.font = [UIFont systemFontOfSize:14.0f];
        _transactionStateLabel.textColor = UIColorFromRGB(0x8f8e94);
    }
    
    return _transactionStateLabel;
}

#pragma mark - loadData Method

- (void)loadDataWithPayments:(Payments *)payments {
    
    self.transactionTitleLabel.text = payments.project;
    self.transactionDateLabel.text = payments.dateTimeISO;
    self.transactionValueLabel.text = [NSString stringWithFormat:@"%.02f元", (CGFloat)(payments.money / 100.0f)];
    self.transactionStateLabel.text = @"";
}

- (void)loadDataWithScoreModel:(ScoreModel *)score {
    
    self.transactionTitleLabel.text = score.scoreDescription;
    self.transactionValueLabel.text = [NSString stringWithFormat:@"%ld", score.count];
    self.transactionDateLabel.text = @"";
    self.transactionValueLabel.text = @"";
}

@end
