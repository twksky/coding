//
//  BlogCommentCell.m
//  iDoctor_BigBang
//
//  Created by twksky on 15/10/26.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import "BlogCommentCell.h"
#import <UIImageView+WebCache.h>
#import "Comment.h"
//#import "SkinManager.h"
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
    [self.doctorIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(50, 50));
        make.left.equalTo(10);
        make.top.equalTo(10);
    }];
    
    // 医生名字
    [self.contentView addSubview:self.doctorNameLabel];
    [self.doctorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.doctorIcon);
        make.left.equalTo(self.doctorIcon.right).offset(10);
    }];
    
    // 时间
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-10);
        make.bottom.equalTo(self.doctorNameLabel);
    }];
    
    // 医生信息
    [self.contentView addSubview:self.doctorInfoLabel];
    [self.doctorInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.doctorIcon.right).offset(10);
        make.top.equalTo(self.doctorNameLabel.bottom).offset(7);
    }];
    
    // 评论
    [self.contentView addSubview:self.commentDesc];
    [self.commentDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(70);
        make.top.equalTo(self.doctorInfoLabel.bottom).offset(7);
        make.width.equalTo(App_Frame_Width - 80);
    }];
    
    // 虚线
    UIImageView *dashImageView = [[UIImageView alloc] init];
    dashImageView.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:dashImageView];
    [dashImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(0);
        make.left.equalTo(60);
        make.right.equalTo(0);
        make.width.equalTo(App_Frame_Width - 60);
        make.height.equalTo(1);
    }];
    
}


#pragma mark - loadData

- (void)loadDataWithComment:(Comment *)comment {
    
    self.comment = comment;
    
    [self.doctorIcon sd_setImageWithURL:[NSURL URLWithString:comment.comment_from_account.avatar_url] placeholderImage:nil];
    
    self.doctorNameLabel.text = [comment.comment_from_account getDisplayName];
    self.timeLabel.text = comment.ctime_iso;
    self.doctorInfoLabel.text = [NSString stringWithFormat:@"%@, %@", comment.comment_from_account.hospital, comment.comment_from_account.title];
    
    self.commentDesc.text = comment.comment_description;
}

#pragma mark - cell height

+ (CGFloat)cellHeightWithComment:(Comment *)comment {
    
    NSString *text = comment.comment_description;
    
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
