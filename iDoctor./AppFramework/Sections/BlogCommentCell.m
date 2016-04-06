//
//  BlogCommentCell.m
//  AppFramework
//
//  Created by 周世阳 on 15/7/2.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "BlogCommentCell.h"
#import <UIImageView+WebCache.h>
#import <PureLayout.h>
#import "Comment.h"
#import "SkinManager.h"
#import "Account.h"

#define BlogCommentCellTextFont [UIFont systemFontOfSize:17.0f]

@interface BlogCommentCell ()

@property (nonatomic, strong) UIImageView *doctorIcon;
@property (nonatomic, strong) UILabel *doctorNameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *doctorInfoLabel;
@property (nonatomic, strong) UILabel *commentDesc;

@property (nonatomic, strong) Comment *comment;

@end

@implementation BlogCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupView];
    }
    
    return self;
}

- (void)setupView {
    
    // 医生头像
    [self.contentView addSubview:self.doctorIcon];
    {
        [self.contentView addConstraints:[self.doctorIcon autoSetDimensionsToSize:CGSizeMake(50.0f, 50.0f)]];
        [self.contentView addConstraint:[self.doctorIcon autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f]];
        [self.contentView addConstraint:[self.doctorIcon autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f]];
    }
    
    // 医生名字
    [self.contentView addSubview:self.doctorNameLabel];
    {
        [self addConstraint:[self.doctorNameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.doctorIcon]];
        [self addConstraint:[self.doctorNameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.doctorIcon withOffset:10.0f]];
    }
    
    // 时间
    [self.contentView addSubview:self.timeLabel];
    {
        [self addConstraint:[self.timeLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f]];
        [self addConstraint:[self.timeLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.doctorNameLabel]];
    }
    
    // 医生信息
    [self.contentView addSubview:self.doctorInfoLabel];
    {
        [self.contentView addConstraint:[self.doctorInfoLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.doctorIcon withOffset:10.0f]];
        [self.contentView addConstraint:[self.doctorInfoLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.doctorNameLabel withOffset:7.0f]];
    }
    
    // 评论
    [self.contentView addSubview:self.commentDesc];
    {
        [self.contentView addConstraint:[self.commentDesc autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:70.0f]];
        [self.contentView addConstraint:[self.commentDesc autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.doctorInfoLabel withOffset:10.0f]];
        [self.contentView addConstraint:[self.commentDesc autoSetDimension:ALDimensionWidth toSize:App_Frame_Width - 80.0f]];
    }
    
    // 虚线
    UIImageView *dashImageView = [[UIImageView alloc] init];
    dashImageView.image = [UIImage imageNamed:@"img_blog_dash"];
    [self.contentView addSubview:dashImageView];
    {
        // [self addConstraint:[dashImageView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self]];
        [self.contentView addConstraint:[dashImageView autoPinEdgeToSuperviewEdge:ALEdgeBottom]];
        [self.contentView addConstraint:[dashImageView autoSetDimension:ALDimensionWidth toSize:App_Frame_Width - 60.0f]];
        [self.contentView addConstraint:[dashImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:60.0f]];
        [self.contentView addConstraint:[dashImageView autoPinEdgeToSuperviewEdge:ALEdgeRight]];
    }
    
}


#pragma mark - loadData

- (void)loadDataWithComment:(Comment *)comment {
    
    self.comment = comment;
    
    [self.doctorIcon sd_setImageWithURL:[NSURL URLWithString:comment.doctor.avatarImageURLString] placeholderImage:[SkinManager sharedInstance].defaultUserInfoIcon];
    
    self.doctorNameLabel.text = [comment.doctor getDisplayName];
    self.timeLabel.text = comment.ctimeISO;
    self.doctorInfoLabel.text = [NSString stringWithFormat:@"%@, %@", comment.doctor.hospital.name, comment.doctor.title];
    
    self.commentDesc.text = comment.commentDescription;
}

#pragma mark - cell height

+ (CGFloat)cellHeightWithComment:(Comment *)comment {
    
    NSString *text = comment.commentDescription;
    
    CGSize constraintSize = CGSizeMake(App_Frame_Width - 80.0f, MAXFLOAT);
    CGSize textSize = [text sizeWithFont:BlogCommentCellTextFont constrainedToSize:constraintSize];
    return 80.0f + textSize.height;
}


#pragma mark - properties

- (UIImageView *)doctorIcon {
    
    if (!_doctorIcon) {
        
        _doctorIcon = [[UIImageView alloc] init];
        _doctorIcon.layer.cornerRadius = 3.0f;
        _doctorIcon.layer.masksToBounds = YES;
    }
    
    return _doctorIcon;
}

- (UILabel *)doctorNameLabel {
    
    if (!_doctorNameLabel) {
        
        _doctorNameLabel = [[UILabel alloc] init];
        _doctorNameLabel.textColor = UIColorFromRGB(0x3bc3a9);
        _doctorNameLabel.font = [UIFont systemFontOfSize:17.0f];
    }
    
    return _doctorNameLabel;
}

- (UILabel *)timeLabel {
    
    if (!_timeLabel) {
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:14.0f];
        _timeLabel.textColor = UIColorFromRGB(0x9a9c9c);
    }
    
    return _timeLabel;
}

- (UILabel *)doctorInfoLabel {
    
    if (!_doctorInfoLabel) {
        
        _doctorInfoLabel = [[UILabel alloc] init];
        _doctorInfoLabel.font = [UIFont systemFontOfSize:14.0f];
        _doctorInfoLabel.textColor = UIColorFromRGB(0x9a9c9c);
    }
    
    return _doctorInfoLabel;
}

- (UILabel *)commentDesc {
    
    if (!_commentDesc) {
        
        _commentDesc = [[UILabel alloc] init];
        _commentDesc.font = BlogCommentCellTextFont;
        _commentDesc.numberOfLines = 0;
    }
    
    return _commentDesc;
}

@end
