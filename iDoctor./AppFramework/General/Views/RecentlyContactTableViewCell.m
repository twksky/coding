//
//  RecentlyContactTableViewCell.m
//  AppFramework
//
//  Created by ABC on 8/17/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "RecentlyContactTableViewCell.h"
#import "UIView+Autolayout.h"
#import "SkinManager.h"
#import "Patient.h"
#import "TTTAttributedLabel.h"
#import "UIImageView+WebCache.h"

@interface RecentlyContactTableViewCell ()

@property (nonatomic, strong) UIImageView   *sign1ImageView;
@property (nonatomic, strong) UIImageView   *sign2ImageView;
@property (nonatomic, strong) UILabel       *tipInfoLabel;
@property (nonatomic, strong) UIImageView *seeImageView;

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
        _avatarImageView.layer.cornerRadius = 3.0f;
        _avatarImageView.layer.masksToBounds = YES;
        [_avatarImageView setBounds:CGRectMake(0.0f, 0.0f, 36.0f, 36.0f)];
    }
    return _avatarImageView;
}

- (UILabel *)nicknameLabel
{
    if (!_nicknameLabel) {
        _nicknameLabel = [[UILabel alloc] init];
        _nicknameLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
        _nicknameLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _nicknameLabel;
}

- (TTTAttributedLabel *)countLabel
{
    if (!_countLabel) {
        _countLabel = [[TTTAttributedLabel alloc] init];
        _countLabel.font = [UIFont systemFontOfSize:14.0f];
        _countLabel.backgroundColor = [UIColor redColor];
        _countLabel.textColor = [UIColor whiteColor];
        _countLabel.layer.cornerRadius = 8.0f;
        _countLabel.layer.masksToBounds = YES;
        _countLabel.textInsets = UIEdgeInsetsMake(0.0f, 5.0f, 0.0f, 5.0f);
    }
    return _countLabel;
}

- (UIImageView *)sign1ImageView
{
    if (!_sign1ImageView) {
        _sign1ImageView = [[UIImageView alloc] initWithImage:[SkinManager sharedInstance].defaultStarIcon];
    }
    return _sign1ImageView;
}

- (UIImageView *)sign2ImageView
{
    if (!_sign2ImageView) {
        _sign2ImageView = [[UIImageView alloc] initWithImage:[SkinManager sharedInstance].defaultStarIcon];
    }
    return _sign2ImageView;
}

- (UILabel *)infoLabel
{
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
        _infoLabel.font = [UIFont systemFontOfSize:10.0f];
        _infoLabel.textColor = UIColorFromRGB(0x42b39a);
    }
    return _infoLabel;
}

- (UILabel *)tipInfoLabel
{
    if (!_tipInfoLabel) {
        _tipInfoLabel = [[UILabel alloc] init];
        _tipInfoLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
        _tipInfoLabel.font = [UIFont systemFontOfSize:10.0f];
    }
    return _tipInfoLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
        _timeLabel.font = [UIFont systemFontOfSize:10.0f];
        _timeLabel.textColor = UIColorFromRGB(0x8f8f92);
    }
    return _timeLabel;
}

- (UILabel *)messageLabel
{
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
        _messageLabel.font = [UIFont systemFontOfSize:12.0f];
        _messageLabel.textColor = UIColorFromRGB(0x8e8d93);
    }
    return _messageLabel;
}

- (UIImageView *)seeImageView {
    
    if (!_seeImageView) {
        
        _seeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"see_icon"]];
    }
    
    return _seeImageView;
}


#pragma mark - Private Method

- (void)setupSubviews
{
    [self.contentView addSubview:self.avatarImageView];
        [self.contentView addSubview:self.countLabel];
    [self.contentView addSubview:self.nicknameLabel];
    [self.contentView addSubview:self.sign1ImageView];
    [self.contentView addSubview:self.sign2ImageView];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.infoLabel];
    [self.contentView addSubview:self.tipInfoLabel];
    [self.contentView addSubview:self.messageLabel];
    [self.contentView addSubview:self.seeImageView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contactAvatarImageClicked:)];
    [self.avatarImageView addGestureRecognizer:tapGestureRecognizer];
    self.avatarImageView.userInteractionEnabled = YES;
    
    [self setupConstraints];
}

- (void)setupConstraints
{
    [self.contentView addConstraints:[self.avatarImageView autoSetDimensionsToSize:CGSizeMake(40.0f, 40.0f)]];
    [self.contentView addConstraint:[self.avatarImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:15.0f]];
    [self.contentView addConstraint:[self.avatarImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:15.0f]];
    {
        [self.contentView addConstraint:[self.countLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.avatarImageView withOffset:-5.0f]];
        [self.contentView addConstraint:[self.countLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.avatarImageView withOffset:5.0f]];
    }
    [self.contentView addConstraint:[self.nicknameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.avatarImageView withOffset:12.0f]];
    [self.contentView addConstraint:[self.nicknameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.avatarImageView withOffset:0.0f]];
    //[self.contentView addConstraint:[self.nicknameLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView withOffset:-15.0f]];
    
    [self.contentView addConstraints:[self.sign1ImageView autoSetDimensionsToSize:CGSizeMake(12.0f, 12.0f)]];
    [self.contentView addConstraint:[self.sign1ImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.nicknameLabel withOffset:0.0f]];
    [self.contentView addConstraint:[self.sign1ImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.nicknameLabel withOffset:0.0f]];
    
    [self.contentView addConstraints:[self.sign2ImageView autoSetDimensionsToSize:CGSizeMake(12.0f, 12.0f)]];
    [self.contentView addConstraint:[self.sign2ImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.sign1ImageView withOffset:0.0f]];
    [self.contentView addConstraint:[self.sign2ImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.sign1ImageView withOffset:0.0f]];
    
    [self.contentView addConstraint:[self.tipInfoLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.sign2ImageView withOffset:0.0f]];
    [self.contentView addConstraint:[self.tipInfoLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.sign2ImageView withOffset:0.0f]];
    //[self.contentView addConstraint:[self.tipInfoLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.timeLabel withOffset:0.0f]];
    
    //TODO
    [self.contentView addConstraint:[self.seeImageView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.nicknameLabel]];
    [self.contentView addConstraint:[self.seeImageView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView withOffset:-15.0f]];
    [self.contentView addConstraint:[self.seeImageView autoSetDimension:ALDimensionWidth toSize:20.0f]];
    [self.contentView addConstraint:[self.seeImageView autoSetDimension:ALDimensionHeight toSize:20.0f]];
    
    
    [self.contentView addConstraint:[self.timeLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.nicknameLabel]];
    [self.contentView addConstraint:[self.timeLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.seeImageView withOffset:-15.0f]];
    
    [self.contentView addConstraint:[self.infoLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.nicknameLabel withOffset:12.0f]];
    [self.contentView addConstraint:[self.infoLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.nicknameLabel]];
    
    [self.contentView addConstraint:[self.messageLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.avatarImageView withOffset:12.0f]];
    [self.contentView addConstraint:[self.messageLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.nicknameLabel withOffset:8.0f]];
    [self.contentView addConstraint:[self.messageLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView withOffset:-15.0f]];
    //[self.contentView addConstraint:[self.messageLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView withOffset:0.0f]];
}


#pragma mark - Public Method

- (void)setContact:(Patient *)patient
{
    if (patient.userID != kDoctorAssistantID) {
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:patient.avatarURLString] placeholderImage:[SkinManager sharedInstance].defaultContactAvatarIcon];
    } else {
        [self.avatarImageView setImage:[UIImage imageNamed:@"icon_assistant"]];
    }
    
//    NSString *patientName = [patient getDisplayName];
//    if ([patient getNoteName]) {
//        patientName = [NSString stringWithFormat:@"%@(%@)", patientName, [patient getNoteName]];
//    }
    [self.nicknameLabel setText:[patient getDisplayName]];
    
    if (patient.isStarted && !patient.isBlocked) {
        [self.sign1ImageView setImage:[SkinManager sharedInstance].defaultStarIcon];
        [self.sign1ImageView setHidden:NO];
        
        [self.sign2ImageView setHidden:YES];
        
        [self.tipInfoLabel setHidden:YES];
    } else if (!patient.isStarted && patient.isBlocked) {
        [self.sign1ImageView setHidden:YES];
        
        [self.sign2ImageView setImage:[SkinManager sharedInstance].defaultBlockIcon];
        [self.sign2ImageView setHidden:NO];
        
        [self.tipInfoLabel setText:@"(黑名单)"];
        [self.tipInfoLabel setHidden:NO];
    } else if (patient.isStarted && patient.isBlocked) {
        [self.sign1ImageView setImage:[SkinManager sharedInstance].defaultStarIcon];
        [self.sign1ImageView setHidden:NO];
        
        [self.sign2ImageView setImage:[SkinManager sharedInstance].defaultBlockIcon];
        [self.sign2ImageView setHidden:NO];
        
        [self.tipInfoLabel setText:@"(黑名单)"];
        [self.tipInfoLabel setHidden:NO];
    } else {
        [self.sign1ImageView setHidden:YES];
        [self.sign2ImageView setHidden:YES];
        [self.tipInfoLabel setHidden:YES];
    }
    
    if (patient.userID != kDoctorAssistantID) {
//        [self.infoLabel setText:[NSString stringWithFormat:@"已经赠送花朵%ld朵，已经接收了%d朵", patient.flowerInvitation, patient.flowerAcceptance]];
        [self.infoLabel setText:[NSString stringWithFormat:@"已经赠送花朵%ld朵", patient.flowerInvitation]];
    }
}

- (void)contactAvatarImageClicked:(UIGestureRecognizer *)gestureRecognizer
{
    if ([self.delegate respondsToSelector:@selector(recentlyContactTableViewCellDidClickedAvatarImage:)]) {
        [self.delegate recentlyContactTableViewCellDidClickedAvatarImage:self];
    }
}

@end
