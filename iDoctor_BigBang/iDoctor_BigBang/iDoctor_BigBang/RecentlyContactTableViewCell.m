//
//  RecentlyContactTableViewCell.m
//  iDoctor_BigBang
//
//  Created by twksky on 15/10/19.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import "RecentlyContactTableViewCell.h"
//#import "UIView+Autolayout.h"
//#import "SkinManager.h"
#import "IDGetDoctorPatient.h"
//#import "TTTAttributedLabel.h"
#import "UIImageView+WebCache.h"

@interface RecentlyContactTableViewCell ()

//@property (nonatomic, strong) UIImageView   *sign1ImageView;
//@property (nonatomic, strong) UIImageView   *sign2ImageView;
//@property (nonatomic, strong) UILabel       *tipInfoLabel;//设置黑名单的功能
//@property (nonatomic, strong) UIImageView *seeImageView;//最右边的三角小箭头

@end

@implementation RecentlyContactTableViewCell

+ (CGFloat)DefaultCellHeight
{
    return 70.0f;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
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

#pragma mark - Property

- (UIImageView *)avatarImageView
{
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
//        _avatarImageView.backgroundColor = [UIColor redColor];
        _avatarImageView.layer.cornerRadius = 18.0f;
        _avatarImageView.layer.masksToBounds = YES;
        [_avatarImageView setBounds:CGRectMake(0.0f, 0.0f, 36.0f, 36.0f)];
    }
    return _avatarImageView;
}

- (UILabel *)nicknameLabel
{
    if (!_nicknameLabel) {
        _nicknameLabel = [[UILabel alloc] init];
//        _nicknameLabel.backgroundColor = [UIColor greenColor];
//        _nicknameLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
        _nicknameLabel.font = [UIFont systemFontOfSize:15.0f];
    }
    return _nicknameLabel;
}

- (UILabel *)countLabel
{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.font = [UIFont systemFontOfSize:13.0f];
//        _countLabel.backgroundColor = [UIColor redColor];
        _countLabel.textColor = [UIColor whiteColor];
        _countLabel.layer.cornerRadius = 8.0f;
        _countLabel.layer.masksToBounds = YES;
        _countLabel.textAlignment = NSTextAlignmentCenter;
//        [_countLabel sizeToFit];
//        _countLabel. = UIEdgeInsetsMake(0.0f, 5.0f, 0.0f, 5.0f);
    }
    return _countLabel;
}

//- (UIImageView *)sign1ImageView
//{
//    if (!_sign1ImageView) {
//        //TODO
//        _sign1ImageView = [[UIImageView alloc] initWithImage:nil];
////                           [SkinManager sharedInstance].defaultStarIcon];
//    }
//    return _sign1ImageView;
//}

//- (UIImageView *)sign2ImageView
//{
//    if (!_sign1ImageView) {
//        //TODO
//        _sign1ImageView = [[UIImageView alloc] initWithImage:nil];
//        //                           [SkinManager sharedInstance].defaultStarIcon];
//    }
//    return _sign2ImageView;
//}

//- (UILabel *)infoLabel//送花的label
//{
//    if (!_infoLabel) {
//        _infoLabel = [[UILabel alloc] init];
////        _infoLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
//        _infoLabel.font = [UIFont systemFontOfSize:10.0f];
//        _infoLabel.textColor = UIColorFromRGB(0x42b39a);
//    }
//    return _infoLabel;
//}

//- (UILabel *)tipInfoLabel
//{
//    if (!_tipInfoLabel) {
//        _tipInfoLabel = [[UILabel alloc] init];
////        _tipInfoLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
//        _tipInfoLabel.font = [UIFont systemFontOfSize:10.0f];
//    }
//    return _tipInfoLabel;
//}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
//        _timeLabel.backgroundColor = [UIColor orangeColor];
//        _timeLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
        _timeLabel.font = [UIFont systemFontOfSize:11.0f];
        _timeLabel.textColor = UIColorFromRGB(0xc4c4c6);
    }
    return _timeLabel;
}

- (UILabel *)messageLabel
{
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
//        _messageLabel.backgroundColor = [UIColor yellowColor];
//        _messageLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
        _messageLabel.font = [UIFont systemFontOfSize:12.0f];
        _messageLabel.textColor = UIColorFromRGB(0xa8a8aa);
    }
    return _messageLabel;
}

//- (UIImageView *)seeImageView {
//    
//    if (!_seeImageView) {
//        _seeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"see_icon"]];
//        _seeImageView.backgroundColor = [UIColor purpleColor];
//    }
//    
//    return _seeImageView;
//}

-(UIImageView *)reSendIMG{
    if (!_reSendIMG) {
        _reSendIMG = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"发送失败"]];
//        _reSendIMG.backgroundColor = [UIColor redColor];
    }
    return _reSendIMG;
}


#pragma mark - Private Method

- (void)setupSubviews
{
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.countLabel];
    [self.contentView addSubview:self.nicknameLabel];
//    [self.contentView addSubview:self.sign1ImageView];
//    [self.contentView addSubview:self.sign2ImageView];
    [self.contentView addSubview:self.timeLabel];
//    [self.contentView addSubview:self.infoLabel];//送花的信息
//    [self.contentView addSubview:self.tipInfoLabel];//黑名单
    [self.contentView addSubview:self.messageLabel];
//    [self.contentView addSubview:self.seeImageView];
    [self.contentView addSubview:self.reSendIMG];//重新发送
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contactAvatarImageClicked:)];
    [self.avatarImageView addGestureRecognizer:tapGestureRecognizer];
    self.avatarImageView.userInteractionEnabled = YES;
    
    [self setupConstraints];
}

- (void)setupConstraints
{
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
//        make.bottom.equalTo(self.contentView).offset(-50);
//        make.right.equalTo(self.contentView).offset(-30);
        make.top.equalTo(self.contentView).offset(15);
        make.size.equalTo(CGSizeMake(40, 40));
    }];
    
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImageView.right).offset(12);
        //        make.bottom.equalTo(self.contentView).offset(-50);
//        make.right.equalTo(self.contentView).offset(-30);
        make.top.equalTo(self.avatarImageView.top).offset(0);
    }];
    
//    [self.contentView addConstraints:[self.avatarImageView autoSetDimensionsToSize:CGSizeMake(40.0f, 40.0f)]];
//    [self.contentView addConstraint:[self.avatarImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:15.0f]];
//    [self.contentView addConstraint:[self.avatarImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:15.0f]];
//    {
//        [self.contentView addConstraint:[self.countLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.avatarImageView withOffset:-5.0f]];
//        [self.contentView addConstraint:[self.countLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.avatarImageView withOffset:5.0f]];
//    }
//    [self.contentView addConstraint:[self.nicknameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.avatarImageView withOffset:12.0f]];
//    [self.contentView addConstraint:[self.nicknameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.avatarImageView withOffset:0.0f]];
    //[self.contentView addConstraint:[self.nicknameLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView withOffset:-15.0f]];
    
//    [self.contentView addConstraints:[self.sign1ImageView autoSetDimensionsToSize:CGSizeMake(12.0f, 12.0f)]];
//    [self.contentView addConstraint:[self.sign1ImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.nicknameLabel withOffset:0.0f]];
//    [self.contentView addConstraint:[self.sign1ImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.nicknameLabel withOffset:0.0f]];
    
//    [self.contentView addConstraints:[self.sign2ImageView autoSetDimensionsToSize:CGSizeMake(12.0f, 12.0f)]];
//    [self.contentView addConstraint:[self.sign2ImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.sign1ImageView withOffset:0.0f]];
//    [self.contentView addConstraint:[self.sign2ImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.sign1ImageView withOffset:0.0f]];
//    
//    [self.contentView addConstraint:[self.tipInfoLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.sign2ImageView withOffset:0.0f]];
//    [self.contentView addConstraint:[self.tipInfoLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.sign2ImageView withOffset:0.0f]];
    //[self.contentView addConstraint:[self.tipInfoLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.timeLabel withOffset:0.0f]];
    
//    //TODO
//    [self.contentView addConstraint:[self.seeImageView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.nicknameLabel]];
//    [self.contentView addConstraint:[self.seeImageView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView withOffset:-15.0f]];
//    [self.contentView addConstraint:[self.seeImageView autoSetDimension:ALDimensionWidth toSize:20.0f]];
//    [self.contentView addConstraint:[self.seeImageView autoSetDimension:ALDimensionHeight toSize:20.0f]];
    
//    [self.seeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.nicknameLabel);
//        make.right.equalTo(self.contentView.right).offset(-15);
//        make.size.equalTo(CGSizeMake(20, 20));
//    }];
    
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nicknameLabel);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
//    [self.contentView addConstraint:[self.timeLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.nicknameLabel]];
//    [self.contentView addConstraint:[self.timeLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.seeImageView withOffset:-15.0f]];
    
//    [self.contentView addConstraint:[self.infoLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.nicknameLabel withOffset:12.0f]];
//    [self.contentView addConstraint:[self.infoLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.nicknameLabel]];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.left.equalTo(self.avatarImageView).offset(15);
        make.top.equalTo(self.timeLabel.bottom).offset(10);
        make.right.equalTo(self.contentView).offset(-15);
        //        make.top.equalTo(self.avatarImageView).offset(15);
        //        make.size.equalTo(CGSizeMake(40, 40));
        make.left.equalTo(self.contentView).offset(self.contentView.frame.size.width + 15);
        make.bottom.equalTo(self.messageLabel);
    }];
    
    [self.reSendIMG mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.messageLabel);
        make.top.equalTo(self.nicknameLabel.bottom).offset(6);
        make.left.equalTo(self.nicknameLabel);
        make.size.equalTo(CGSizeMake(19, 19));
    }];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        if (self.reSendIMG.isHidden) {
//            make.left.equalTo(self.avatarImageView.right).offset(12);
//        }else{
        make.left.equalTo(self.avatarImageView.right).offset(12 + 19 +5);
//        }
        make.top.equalTo(self.nicknameLabel.bottom).offset(8);
        make.right.equalTo(self.countLabel.left).offset(-15);
    }];
    
//    [self.contentView addConstraint:[self.messageLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.avatarImageView withOffset:12.0f]];
//    [self.contentView addConstraint:[self.messageLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.nicknameLabel withOffset:8.0f]];
//    [self.contentView addConstraint:[self.messageLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView withOffset:-15.0f]];
    //[self.contentView addConstraint:[self.messageLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView withOffset:0.0f]];
    
}


#pragma mark - Public Method

- (void)setContact:(IDGetDoctorPatient *)patient
{
    if (![patient.patient_id isEqualToString:kDoctorAssistantID]) {
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:patient.avatar_url] placeholderImage:[UIImage imageNamed: @"wantP_avatar"]];
    } else {
        //TODO，医生助手默认图片
        [self.avatarImageView setImage:[UIImage imageNamed:@"fmale"]];
    }
    
    //    NSString *patientName = [patient getDisplayName];
    //    if ([patient getNoteName]) {
    //        patientName = [NSString stringWithFormat:@"%@(%@)", patientName, [patient getNoteName]];
    //    }
    
    
    [self.nicknameLabel setText:[patient getDisplayName]];
    
//    if (patient.isStarted && !patient.isBlocked) {
//        [self.sign1ImageView setImage:[SkinManager sharedInstance].defaultStarIcon];
//        [self.sign1ImageView setHidden:NO];
//        
//        [self.sign2ImageView setHidden:YES];
//        
//        [self.tipInfoLabel setHidden:YES];
//    } else if (!patient.isStarted && patient.isBlocked) {
//        [self.sign1ImageView setHidden:YES];
//        
//        [self.sign2ImageView setImage:[SkinManager sharedInstance].defaultBlockIcon];
//        [self.sign2ImageView setHidden:NO];
//        
//        [self.tipInfoLabel setText:@"(黑名单)"];
//        [self.tipInfoLabel setHidden:NO];
//    } else if (patient.isStarted && patient.isBlocked) {
//        [self.sign1ImageView setImage:[SkinManager sharedInstance].defaultStarIcon];
//        [self.sign1ImageView setHidden:NO];
//        
//        [self.sign2ImageView setImage:[SkinManager sharedInstance].defaultBlockIcon];
//        [self.sign2ImageView setHidden:NO];
//        
//        [self.tipInfoLabel setText:@"(黑名单)"];
//        [self.tipInfoLabel setHidden:NO];
//    } else {
//        [self.sign1ImageView setHidden:YES];
//        [self.sign2ImageView setHidden:YES];
//        [self.tipInfoLabel setHidden:YES];
//    }
    
//    if ([patient.patient_id isEqualToString:kDoctorAssistantID]) {
//        //        [self.infoLabel setText:[NSString stringWithFormat:@"已经赠送花朵%ld朵，已经接收了%d朵", patient.flowerInvitation, patient.flowerAcceptance]];
//        [self.infoLabel setText:[NSString stringWithFormat:@"已经赠送花朵%ld朵", patient.flowerInvitation]];
//    }
}

- (void)contactAvatarImageClicked:(UIGestureRecognizer *)gestureRecognizer
{
    if ([self.delegate respondsToSelector:@selector(recentlyContactTableViewCellDidClickedAvatarImage:)]) {
        [self.delegate recentlyContactTableViewCellDidClickedAvatarImage:self];
    }
}

@end