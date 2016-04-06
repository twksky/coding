//
//  NativeQuestionCellTableViewCell.m
//  AppFramework
//
//  Created by 周世阳 on 15/5/15.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "NativeQuestionCellTableViewCell.h"
#import <PureLayout.h>
#import "QuickQuestion.h"
#import "Patient.h"
#import <UIImageView+WebCache.h>
#import "SkinManager.h"

@interface NativeQuestionCellTableViewCell ()

@property (nonatomic, strong) UIImageView *userIconImageView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *docOfficeLabel;
@property (nonatomic, strong) UILabel *userSex;
@property (nonatomic, strong) UILabel *userAge;
@property (nonatomic, strong) UILabel *questionContentLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic ,strong) UILabel *imageNumberLabel;
@property (nonatomic, strong) UILabel *commentNumberLabel;
@property (nonatomic, strong) UIImageView *detailIconImageView;

@property (nonatomic, strong) Patient *patient;

@end

@implementation NativeQuestionCellTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupViews];
    }
    
    return self;
}

- (void)setupViews {
    
    self.contentView.backgroundColor = UIColorFromRGB(0xedf2f1);
    
    //TODO
    UIView *cellView = [[UIView alloc] init];
    cellView.backgroundColor = [UIColor whiteColor];
    cellView.layer.cornerRadius = 6.0f;
    
    UIImageView *line = [[UIImageView alloc] initWithImage:[SkinManager sharedInstance].defaultLineImage];
    
    [self.contentView addSubview:cellView];
    
    [cellView addSubview:self.userIconImageView];
    [cellView addSubview:self.userNameLabel];
    [cellView addSubview:self.userSex];
    [cellView addSubview:self.userAge];
    [cellView addSubview:self.docOfficeLabel];
    [cellView addSubview:self.questionContentLabel];
    [cellView addSubview:self.dateLabel];
    [cellView addSubview:self.imageNumberLabel];
    [cellView addSubview:self.commentNumberLabel];
    [cellView addSubview:self.detailIconImageView];
    [cellView addSubview:line];
    
    //AutoLayout
    {
        [self.contentView addConstraints:[cellView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(10.0f, 10.0f, 0, 10.0f)]];
        
        [cellView addConstraint:[self.userIconImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f]];
        [cellView addConstraint:[self.userIconImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f]];
        [cellView addConstraint:[self.userIconImageView autoSetDimension:ALDimensionHeight toSize:50.0f]];
        [cellView addConstraint:[self.userIconImageView autoSetDimension:ALDimensionWidth toSize:50.0f]];
        
        [cellView addConstraint:[self.userNameLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:11.0f]];
        [cellView addConstraint:[self.userNameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.userIconImageView withOffset:10.0f]];
        
        [cellView addConstraint:[self.userSex autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.userNameLabel withOffset:15.0f]];
        [cellView addConstraint:[self.userSex autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.userNameLabel]];
        
        [cellView addConstraint:[self.userAge autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.userSex withOffset:20.0f]];
        [cellView addConstraint:[self.userAge autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.userSex]];
        
        [cellView addConstraint:[self.docOfficeLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.userNameLabel withOffset:10.0f]];
        [cellView addConstraint:[self.docOfficeLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.userIconImageView withOffset:10.0f]];
        
        [cellView addConstraint:[self.questionContentLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.userIconImageView withOffset:10.0f]];
        [cellView addConstraint:[self.questionContentLabel autoAlignAxisToSuperviewAxis:ALAxisVertical]];
        [cellView addConstraint:[self.questionContentLabel autoSetDimension:ALDimensionWidth toSize:App_Frame_Width - 40.0f]];
        [cellView addConstraint:[self.questionContentLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f]];
        
        [cellView addConstraint:[self.dateLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f]];
        [cellView addConstraint:[self.dateLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f]];
        
        [cellView addConstraint:[self.detailIconImageView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f]];
        [cellView addConstraint:[self.detailIconImageView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f]];
        
        [cellView addConstraint:[self.commentNumberLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.detailIconImageView withOffset:-10.0f]];
        [cellView addConstraint:[self.commentNumberLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f]];
        
        [cellView addConstraint:[self.imageNumberLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.commentNumberLabel withOffset:-10.0f]];
        [cellView addConstraint:[self.imageNumberLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f]];
        
        [cellView addConstraints:[line autoSetDimensionsToSize:CGSizeMake(App_Frame_Width - 30.0f, 0.7f)]];
        [cellView addConstraint:[line autoPinEdgeToSuperviewEdge:ALEdgeRight]];
        [cellView addConstraint:[line autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:cellView withOffset:-30.0f]];
    }
}

#pragma mark - loadData Methods

- (void)loadData:(QuickQuestion *)question {
    
    self.patient = question.patient;
    
    [self.userIconImageView sd_setImageWithURL:[NSURL URLWithString:question.patient.avatarURLString] placeholderImage:[SkinManager sharedInstance].defaultContactAvatarIcon];
    self.userNameLabel.text = [question.patient getDisplayName];
    
    NSString *sex;
    if (question.sex) {
        
        sex = question.sex;
    }
    else {
        
        sex = @"未知";
    }
    
    self.userSex.text = sex;
    self.userAge.text = [NSString stringWithFormat:@"%ld岁", question.age];
    self.docOfficeLabel.text = question.department;
    self.questionContentLabel.text = question.conditionDescription;
    
    NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    self.dateLabel.text = [dateFormatter stringFromDate:question.createTime];
    self.imageNumberLabel.text = [NSString stringWithFormat:@"有图%ld张", question.imagesCount];
    self.commentNumberLabel.text = [NSString stringWithFormat:@"已有%ld条回复", question.comments.count];
}


#pragma mark - selector

- (void)userIconClicked {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(iconUserImageClickedWithPatient:)]) {
        
        [self.delegate iconUserImageClickedWithPatient:self.patient];
    }
}


#pragma mark - properties

- (UIImageView *)userIconImageView {

    if (!_userIconImageView) {
        
        _userIconImageView = [[UIImageView alloc] init];
        _userIconImageView.layer.cornerRadius = 6.0f;
        _userIconImageView.layer.masksToBounds = YES;
        _userIconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userIconClicked)];
        [_userIconImageView addGestureRecognizer:tap];
    }
    
    return _userIconImageView;
}

- (UILabel *)userNameLabel {
    
    if (!_userNameLabel) {
        
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.textColor = UIColorFromRGB(0x33d2b4);
        _userNameLabel.font = [UIFont systemFontOfSize:17.0f];
    }
    
    return _userNameLabel;
}

- (UILabel *)userSex {
    
    if (!_userSex) {
        
        _userSex = [[UILabel alloc] init];
        _userSex.textColor = UIColorFromRGB(0x33d2b4);
        _userSex.font = [UIFont systemFontOfSize:12.0f];
    }
    
    return _userSex;
}

- (UILabel *)userAge {
    
    if (!_userAge) {
        
        _userAge = [[UILabel alloc] init];
        _userAge.textColor = UIColorFromRGB(0x33d2b4);
        _userAge.font = [UIFont systemFontOfSize:12.0f];
    }
    
    return _userAge;
}

- (UILabel *)docOfficeLabel {
    
    if (!_docOfficeLabel) {
        
        _docOfficeLabel = [[UILabel alloc] init];
        _docOfficeLabel.textColor = UIColorFromRGB(0x797979);
        _docOfficeLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    
    return _docOfficeLabel;
}

- (UILabel *)questionContentLabel {
    
    if (!_questionContentLabel) {
        
        _questionContentLabel = [[UILabel alloc] init];
        _questionContentLabel.textColor = UIColorFromRGB(0x8f8f92);
        _questionContentLabel.font = [UIFont systemFontOfSize:14.0f];
        
        _questionContentLabel.numberOfLines = 2;
    }
    
    return _questionContentLabel;
}

- (UILabel *)dateLabel {
    
    if (!_dateLabel) {
        
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.textColor = UIColorFromRGB(0x8e8e94);
        _dateLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    
    return _dateLabel;
}

- (UILabel *)imageNumberLabel {
    
    if (!_imageNumberLabel) {
        
        _imageNumberLabel = [[UILabel alloc] init];
        _imageNumberLabel.textColor = UIColorFromRGB(0x40b49c);
        _imageNumberLabel.font = [UIFont systemFontOfSize:10.0f];
    }
    
    return _imageNumberLabel;
}

- (UILabel *)commentNumberLabel {
    
    if (!_commentNumberLabel) {
        
        _commentNumberLabel = [[UILabel alloc] init];
        _commentNumberLabel.textColor = UIColorFromRGB(0x40b49c);
        _commentNumberLabel.font = [UIFont systemFontOfSize:10.0f];
    }
    
    return _commentNumberLabel;
}

- (UIImageView *)detailIconImageView {
    
    if (!_detailIconImageView) {
        
        _detailIconImageView = [[UIImageView alloc] init];
        [_detailIconImageView setImage:[UIImage imageNamed:@""]];
    }
    
    return _detailIconImageView;
}


@end










