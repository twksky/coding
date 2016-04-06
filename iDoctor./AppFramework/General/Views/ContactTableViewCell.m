//
//  ContactTableViewCell.m
//  AppFramework
//
//  Created by ABC on 8/14/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "ContactTableViewCell.h"
#import "UIView+Autolayout.h"
#import "Patient.h"
#import "SkinManager.h"
#import "UIImageView+WebCache.h"

@interface ContactTableViewCell ()

@property (nonatomic, strong) UIImageView   *sign1ImageView;
@property (nonatomic, strong) UIImageView   *sign2ImageView;
@property (nonatomic, strong) UILabel       *tipInfoLabel;

- (void)setupSubviews;
- (void)setupConstraints;

@end

@implementation ContactTableViewCell

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

- (UIImageView *)sign1ImageView
{
    if (!_sign1ImageView) {
        _sign1ImageView = [[UIImageView alloc] init];
    }
    return _sign1ImageView;
}

- (UIImageView *)sign2ImageView
{
    if (!_sign2ImageView) {
        _sign2ImageView = [[UIImageView alloc] init];
    }
    return _sign2ImageView;
}

- (UILabel *)infoLabel
{
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
        _infoLabel.font = [UIFont systemFontOfSize:12.0f];
        _infoLabel.textColor = UIColorFromRGB(0x8e8d93);
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


#pragma mark - Private Method

- (void)setupSubviews
{
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.nicknameLabel];
    [self.contentView addSubview:self.sign1ImageView];
    [self.contentView addSubview:self.sign2ImageView];
    [self.contentView addSubview:self.tipInfoLabel];
    [self.contentView addSubview:self.infoLabel];
    
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
    
    [self.contentView addConstraint:[self.infoLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.avatarImageView withOffset:12.0f]];
    [self.contentView addConstraint:[self.infoLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.nicknameLabel withOffset:10.0f]];
    [self.contentView addConstraint:[self.infoLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView withOffset:-15.0f]];
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
        [self.infoLabel setText:[NSString stringWithFormat:@"已经赠送花朵%ld朵，已经接收了%ld朵", (long)patient.flowerInvitation, (long)patient.flowerAcceptance]];
    }
}

- (void)contactAvatarImageClicked:(UIGestureRecognizer *)gestureRecognizer
{
    if ([self.delegate respondsToSelector:@selector(contactTableViewCellDidClickedAvatarImage:)]) {
        [self.delegate contactTableViewCellDidClickedAvatarImage:self];
    }
}

@end
