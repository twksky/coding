//
//  NativeQuestionDetailCommentCellTableViewCell.m
//  AppFramework
//
//  Created by tianxiewuhua on 15/6/1.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "NativeQuestionDetailCommentCell.h"
#import "Comment.h"
#import "Account.h"
#import <PureLayout.h>
#import "SkinManager.h"
#import "UIImageView+WebCache.h"


@interface NativeQuestionDetailCommentCell ()

@property (nonatomic ,strong) UIView *cellView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *positionLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation NativeQuestionDetailCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupViews];
    }
    
    return self;
}


- (void)setupViews {
    
    self.contentView.backgroundColor = UIColorFromRGB(0xedf2f1);
    [self.contentView addSubview:self.cellView];
    
    [self.cellView addSubview:self.avatarImageView];
    [self.cellView addSubview:self.nameLabel];
    [self.cellView addSubview:self.dateLabel];
    [self.cellView addSubview:self.positionLabel];
    [self.cellView addSubview:self.contentLabel];
    
    {
        [self.contentView addConstraints:[self.cellView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0.0f, 10.0f, 10.0f, 10.0f)]];
        
        [self.cellView addConstraint:[self.avatarImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f]];
        [self.cellView addConstraint:[self.avatarImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f]];
        [self.cellView addConstraint:[self.avatarImageView autoSetDimension:ALDimensionHeight toSize:50.0f]];
        [self.cellView addConstraint:[self.avatarImageView autoSetDimension:ALDimensionWidth toSize:50.0f]];
        
        [self.cellView addConstraint:[self.nameLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:11.0f]];
        [self.cellView addConstraint:[self.nameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.avatarImageView withOffset:10.0f]];
        
        [self.cellView addConstraint:[self.dateLabel autoPinEdgeToSuperviewEdge:ALEdgeRight]];
        [self.cellView addConstraint:[self.dateLabel autoAlignAxis:ALAxisBaseline toSameAxisOfView:self.nameLabel]];
        
        [self.cellView addConstraint:[self.positionLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.nameLabel withOffset:10.0f]];
        [self.cellView addConstraint:[self.positionLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.avatarImageView withOffset:10.0f]];
        
        [self.cellView addConstraint:[self.contentLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.avatarImageView withOffset:10.0f]];
        [self.cellView addConstraint:[self.contentLabel autoAlignAxisToSuperviewAxis:ALAxisVertical]];
        [self.cellView addConstraint:[self.contentLabel autoSetDimension:ALDimensionWidth toSize:App_Frame_Width - 40.0f]];
        [self.cellView addConstraint:[self.contentLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f]];
    }
}

- (void)loadComment:(Comment *)comment {
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:comment.doctor.avatarImageURLString] placeholderImage:[SkinManager sharedInstance].defaultUserInfoIcon];
    
    self.nameLabel.text = [comment.doctor getDisplayName];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:comment.ctimeISO];
    
    [dateFormatter setDateFormat:@"MM-dd  HH:mm:ss  "];
    
    self.dateLabel.text = [dateFormatter stringFromDate:date];
    
    self.positionLabel.text = comment.doctor.title;
    
    NSString *content = [NSString stringWithFormat:@"指导意见: %@", comment.commentDescription];
//    NSInteger strLen = content.length;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:content];
    [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x40b29b) range:NSMakeRange(0,5)];
    
    self.contentLabel.attributedText = str;
}


#pragma mark - properties

- (UIView *)cellView {
    
    if (!_cellView) {
        
        _cellView = [[UIView alloc] init];
        _cellView.backgroundColor = [UIColor whiteColor];
        _cellView.layer.cornerRadius = 6.0f;
    }
    
    return _cellView;
}

- (UIImageView *)avatarImageView {
    
    if (!_avatarImageView) {
        
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.cornerRadius = 6.0f;
        _avatarImageView.layer.masksToBounds = YES;
    }
    
    return _avatarImageView;
}

- (UILabel *)nameLabel {
    
    if (!_nameLabel) {
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = UIColorFromRGB(0x33d2b4);
        _nameLabel.font = [UIFont systemFontOfSize:17.0f];
    }
    
    return _nameLabel;
}

- (UILabel *)dateLabel {
    
    if (!_dateLabel) {
        
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.textColor = UIColorFromRGB(0x8e8e94);
        _dateLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    
    return _dateLabel;
}

- (UILabel *)positionLabel {
    
    if (!_positionLabel) {
        
        _positionLabel = [[UILabel alloc] init];
        _positionLabel.textColor = UIColorFromRGB(0x797979);
        _positionLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    
    return _positionLabel;
}

- (UILabel *)contentLabel {
    
    if (!_contentLabel) {
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = UIColorFromRGB(0x8f8f92);
        _contentLabel.font = [UIFont systemFontOfSize:14.0f];
        _contentLabel.numberOfLines = 0;
    }
    
    return _contentLabel;
}

#pragma mark - height For cell method

+ (CGFloat)cellHeightWithComment:(Comment *)comment
{
    NSString *infoText = [NSString stringWithFormat:@"指导意见: %@", comment.commentDescription];
    CGSize constraintSize = CGSizeMake(App_Frame_Width - 20.0f, MAXFLOAT);
    CGSize textSize = [infoText sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:constraintSize];
    return 90.0f + textSize.height;
}


@end
