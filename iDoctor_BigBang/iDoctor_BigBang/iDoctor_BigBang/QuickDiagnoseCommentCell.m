//
//  QuickDiagnoseCommentCell.m
//  iDoctor_BigBang
//
//  Created by 周世阳 on 15/10/20.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import "QuickDiagnoseCommentCell.h"
#import "QuickDiagnoseComment.h"
#import "Doctor.h"

@interface QuickDiagnoseCommentCell ()

@property (nonatomic, strong) UIImageView *doctorAvatar;
@property (nonatomic, strong) UILabel *doctorNameLabel;
@property (nonatomic, strong) UILabel *doctorInfoLabel;

@end

@implementation QuickDiagnoseCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupView];
    }
    
    return self;
}

- (void)setupView {
    
    UIView *contentView = self;
    
    [contentView addSubview:self.doctorAvatar];
    [self.doctorAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(contentView).with.offset(15.0f);
        make.left.equalTo(contentView).with.offset(15.0f);
        make.height.and.width.equalTo(50.0f);
    }];
    
    [contentView addSubview:self.doctorNameLabel];
    [self.doctorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.doctorAvatar.right).with.offset(11.0f);
        make.top.equalTo(self.doctorAvatar);
    }];
    
    [contentView addSubview:self.doctorTitleLabel];
    [self.doctorTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.doctorNameLabel.right).with.offset(8.0f);
        make.bottom.equalTo(self.doctorNameLabel);
    }];
    
    [contentView addSubview:self.doctorInfoLabel];
    [self.doctorInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.doctorAvatar.right).with.offset(11.0f);
        make.top.equalTo(self.doctorNameLabel.bottom).with.offset(15.0f);
    }];
    
    [contentView addSubview:self.commentContentLabel];
    [self.commentContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.doctorAvatar.bottom).with.offset(15.0f);
        make.centerX.equalTo(contentView);
        make.left.equalTo(contentView).with.offset(15.0f);
        make.right.equalTo(contentView).with.offset(-15.0f);
    }];
}

- (void)loadDataComment:(QuickDiagnoseComment *)comment {
    
    [self.doctorAvatar sd_setImageWithURL:[NSURL URLWithString:comment.doctor.avatar_url] placeholderImage:[UIImage imageNamed:@"defaut_doctor_avatar"]];
    self.doctorNameLabel.text = comment.doctor.realname;
    self.doctorTitleLabel.text = comment.doctor.title;
    self.doctorInfoLabel.text = [NSString stringWithFormat:@"%@ | %@", comment.doctor.hospital, comment.doctor.department];
    self.commentContentLabel.text = comment.commentContent;
}

#pragma mark - Cell Height
+ (CGFloat)cellHeight:(QuickDiagnoseComment *)comment {
    
    NSString *content = comment.commentContent;
    
    CGSize constraintSize = CGSizeMake(App_Frame_Width - 30.0f, MAXFLOAT);
    CGSize textSize = [content sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:constraintSize];
    return 95.0f + textSize.height;
}

#pragma mark - Properties
- (UIImageView *)doctorAvatar {
    
	if(_doctorAvatar == nil) {
        
		_doctorAvatar = [[UIImageView alloc] init];
        ViewRadius(_doctorAvatar, 25.0f);
	}
	return _doctorAvatar;
}

- (UILabel *)doctorNameLabel {
    
	if(_doctorNameLabel == nil) {
        
		_doctorNameLabel = [[UILabel alloc] init];
        _doctorNameLabel.font = [UIFont systemFontOfSize:14.0f];
        _doctorNameLabel.textColor = UIColorFromRGB(0x353d3f);
	}
	return _doctorNameLabel;
}

- (UILabel *)doctorTitleLabel {
    
	if(_doctorTitleLabel == nil) {
        
		_doctorTitleLabel = [[UILabel alloc] init];
        _doctorTitleLabel.font = [UIFont systemFontOfSize:12.0f];
        _doctorTitleLabel.textColor = UIColorFromRGB(0xa8a8aa);
	}
	return _doctorTitleLabel;
}

- (UILabel *)doctorInfoLabel {
    
	if(_doctorInfoLabel == nil) {
        
		_doctorInfoLabel = [[UILabel alloc] init];
        _doctorInfoLabel.font = [UIFont systemFontOfSize:12.0f];
        _doctorInfoLabel.textColor = UIColorFromRGB(0xd3d3d4);
	}
	return _doctorInfoLabel;
}

- (UILabel *)commentContentLabel {
    
	if(_commentContentLabel == nil) {
        
		_commentContentLabel = [[UILabel alloc] init];
        _commentContentLabel.font = [UIFont systemFontOfSize:14.0f];
        _commentContentLabel.textColor = UIColorFromRGB(0x353d3f);
        _commentContentLabel.numberOfLines = 0;
	}
	return _commentContentLabel;
}

@end
