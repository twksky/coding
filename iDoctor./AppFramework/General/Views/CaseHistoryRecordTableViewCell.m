//
//  CaseHistoryRecordTableViewCell.m
//  AppFramework
//
//  Created by ABC on 8/14/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "CaseHistoryRecordTableViewCell.h"
#import "UIView+Autolayout.h"
#import "MedicalRecord.h"
#import "SkinManager.h"

@interface CaseHistoryRecordTableViewCell ()

@property (nonatomic, strong) UIView    *lineView;
@property (nonatomic, strong) UIView    *pointView;
@property (nonatomic, strong) UILabel   *doctorLabel;
@property (nonatomic, strong) UILabel   *timeLabel;
@property (nonatomic, strong) UILabel   *patientLabel;
@property (nonatomic, strong) UILabel   *illnessLabel;
@property (nonatomic, strong) UILabel   *pictureCountLabel;
@property (nonatomic, strong) UILabel   *detailLabel;

- (void)setupSubviews;
- (void)setupConstraints;

@end

@implementation CaseHistoryRecordTableViewCell

+ (CGFloat)defaultCellHeight
{
    return 90.0f;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - Private Method

- (void)setupSubviews
{
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.pointView];
    [self.contentView addSubview:self.doctorLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.patientLabel];
    [self.contentView addSubview:self.illnessLabel];
    [self.contentView addSubview:self.pictureCountLabel];
    [self.contentView addSubview:self.detailLabel];
    
    [self setupConstraints];
}

- (void)setupConstraints
{
    [self.contentView addConstraint:[self.lineView autoSetDimension:ALDimensionWidth toSize:1.0f]];
    [self.contentView addConstraint:[self.lineView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:0.0f]];
    [self.contentView addConstraint:[self.lineView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:10.0f]];
    [self.contentView addConstraint:[self.lineView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView withOffset:0.0f]];
    
    //[self.contentView addConstraint:[self.pointView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.lineView]];
    [self.contentView addConstraints:[self.pointView autoSetDimensionsToSize:CGSizeMake(10.0f, 10.0f)]];
    [self.contentView addConstraint:[self.pointView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:5.0f]];
    [self.contentView addConstraint:[self.pointView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:5.0f]];
    
    [self.contentView addConstraint:[self.doctorLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.lineView withOffset:10.0f]];
    [self.contentView addConstraint:[self.doctorLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:5.0f]];
    [self.contentView addConstraint:[self.doctorLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.timeLabel withOffset:0.0f]];
    
    [self.contentView addConstraint:[self.timeLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:5.0f]];
    [self.contentView addConstraint:[self.timeLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView withOffset:-10.0f]];
    
    [self.contentView addConstraint:[self.patientLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.lineView withOffset:10.0f]];
    [self.contentView addConstraint:[self.patientLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.doctorLabel withOffset:0.0f]];
    [self.contentView addConstraint:[self.patientLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView withOffset:-10.0f]];
    
    [self.contentView addConstraint:[self.illnessLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.lineView withOffset:10.0f]];
    [self.contentView addConstraint:[self.illnessLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.patientLabel withOffset:0.0f]];
    [self.contentView addConstraint:[self.illnessLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView withOffset:-10.0f]];
    
    [self.contentView addConstraint:[self.pictureCountLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.lineView withOffset:10.0f]];
    [self.contentView addConstraint:[self.pictureCountLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.illnessLabel withOffset:0.0f]];
    [self.contentView addConstraint:[self.pictureCountLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView withOffset:-10.0f]];
    
    [self.contentView addConstraint:[self.detailLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.lineView withOffset:10.0f]];
    [self.contentView addConstraint:[self.detailLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.pictureCountLabel withOffset:0.0f]];
    [self.contentView addConstraint:[self.detailLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView withOffset:-10.0f]];
}


#pragma mark - Property

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor grayColor];
    }
    return _lineView;
}

- (UIView *)pointView
{
    if (!_pointView) {
        _pointView = [[UIView alloc] init];
        _pointView.layer.cornerRadius = 5.0f;
        _pointView.layer.masksToBounds = YES;
        _pointView.layer.backgroundColor = [[UIColor orangeColor] CGColor];
    }
    return _pointView;
}

- (UILabel *)doctorLabel
{
    if (!_doctorLabel) {
        _doctorLabel = [[UILabel alloc] init];
        _doctorLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
        _doctorLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _doctorLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _timeLabel;
}

- (UILabel *)patientLabel
{
    if (!_patientLabel) {
        _patientLabel = [[UILabel alloc] init];
        _patientLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
        _patientLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _patientLabel;
}

- (UILabel *)illnessLabel
{
    if (!_illnessLabel) {
        _illnessLabel = [[UILabel alloc] init];
        _illnessLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
        _illnessLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _illnessLabel;
}

- (UILabel *)pictureCountLabel
{
    if (!_pictureCountLabel) {
        _pictureCountLabel = [[UILabel alloc] init];
        _pictureCountLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
        _pictureCountLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _pictureCountLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
        _detailLabel.font = [UIFont systemFontOfSize:12.0f];
        _detailLabel.textColor = [UIColor orangeColor];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        [_detailLabel setText:@"点击查看详情"];
    }
    return _detailLabel;
}


#pragma mark - Public Method

- (void)setMedicalRecord:(MedicalRecord *)medicalRecord
{
    /*
    [_doctorLabel setText:@"医生：小三医生 天坛医院"];
    [_timeLabel setText:@"2014-08-17"];
    [_patientLabel setText:@"xiaojiahuo 男 30岁 海鲜牛奶过敏"];
    [_illnessLabel setText:@"基本病情：肚子疼肚子疼肚子疼肚子疼肚子疼肚子疼肚子疼肚子疼肚子疼肚子疼肚子疼肚子疼"];
    [_pictureCountLabel setText:@"图片：0张"];
     */
    NSMutableString *doctorText = [[NSMutableString alloc] initWithString:@"医生："];
    if (medicalRecord.doctorName) {
        [doctorText appendString:medicalRecord.doctorName];
        [doctorText appendString:@" "];
    }
    if (medicalRecord.hospitial) {
        [doctorText appendString:medicalRecord.hospitial];
    }
    [self.doctorLabel setText:doctorText];
    
    if (medicalRecord.dateISO) {
        [self.timeLabel setText:[NSString stringWithFormat:@"就诊时间：%@", medicalRecord.dateISO]];
    }
    
    NSMutableString *patientText = [[NSMutableString alloc] init];
    if (medicalRecord.name) {
        [patientText appendString:medicalRecord.name];
        [patientText appendString:@" "];
    }
    if (medicalRecord.gender) {
        if ([medicalRecord.gender isEqualToString:@"male"]) {
            [patientText appendString:@"男"];
        } else if ([medicalRecord.gender isEqualToString:@"female"]) {
            [patientText appendString:@"女"];
        }
        [patientText appendString:@" "];
    }
    [patientText appendString:[NSString stringWithFormat:@"%ld岁 ", (long)medicalRecord.age]];
    if (medicalRecord.allergies && ![medicalRecord.allergies isEqual:[NSNull null]]) {
        [patientText appendString:medicalRecord.allergies];
    }
    [self.patientLabel setText:patientText];
    
    NSMutableString *illnessText = [[NSMutableString alloc] initWithString:@"基本病情："];
    if (medicalRecord.recordDescription) {
        [illnessText appendString:medicalRecord.recordDescription];
        [illnessText appendString:@" "];
    }
    [self.illnessLabel setText:illnessText];
    
    [self.pictureCountLabel setText:[NSString stringWithFormat:@"图片：%ld张", (long)medicalRecord.imagesCount]];
}

@end
