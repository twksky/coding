//
//  DFDSubtitleTableViewCell.m
//  AppFramework
//
//  Created by DebugLife on 2/11/15.
//  Copyright (c) 2015 AppChina. All rights reserved.
//

#import "DFDSubtitleTableViewCell.h"
#import "UIView+AutoLayout.h"
#import "UIResponder+Router.h"

@implementation DFDSubtitleTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.avatarImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.subtitleLabel];
        [self.contentView addSubview:self.timeLabel];
        
        // Autolayout
        [self.contentView addConstraints:[self.avatarImageView autoSetDimensionsToSize:CGSizeMake(45.0f, 45.0f)]];
        [self.contentView addConstraint:[self.avatarImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:10.0f]];
        [self.contentView addConstraint:[self.avatarImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:10.0f]];
        
        [self.contentView addConstraint:[self.titleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.avatarImageView withOffset:10.0f]];
        [self.contentView addConstraint:[self.titleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.avatarImageView withOffset:0.0f]];
        [self.contentView addConstraint:[self.titleLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.timeLabel withOffset:-10.0f]];
        [self.contentView addConstraint:[self.titleLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.avatarImageView withOffset:0.0f]];
        
        //[self.contentView addConstraints:[self.timeLabel autoSetDimensionsToSize:CGSizeMake(90.0f, 18.0f)]];
        [self.contentView addConstraint:[self.timeLabel autoSetDimension:ALDimensionHeight toSize:18.0f]];
        [self.contentView addConstraint:[self.timeLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.avatarImageView withOffset:0.0f]];
        [self.contentView addConstraint:[self.timeLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView withOffset:0.0f]];
        
        [self.contentView addConstraint:[self.subtitleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:10.0f]];
        [self.contentView addConstraint:[self.subtitleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.avatarImageView withOffset:5.0f]];
        [self.contentView addConstraint:[self.subtitleLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView withOffset:-10.0f]];
        [self.contentView addConstraint:[self.subtitleLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView withOffset:-5.0f]];
    }
    return self;
}


#pragma mark - Property

- (UIImageView *)avatarImageView
{
    if (nil == _avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.cornerRadius = 3.0f;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarImageViewTapGestureRecognizerFired:)];
        [_avatarImageView addGestureRecognizer:tapGestureRecognizer];
    }
    return _avatarImageView;
}

- (TTTAttributedLabel *)titleLabel
{
    if (nil == _titleLabel) {
        _titleLabel = [[TTTAttributedLabel alloc] init];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (TTTAttributedLabel *)subtitleLabel
{
    if (nil == _subtitleLabel) {
        _subtitleLabel = [[TTTAttributedLabel alloc] init];
        _subtitleLabel.numberOfLines = 0;
    }
    return _subtitleLabel;
}

- (TTTAttributedLabel *)timeLabel
{
    if (nil == _timeLabel) {
        _timeLabel = [[TTTAttributedLabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
}


#pragma mark - Selector

- (void)avatarImageViewTapGestureRecognizerFired:(UIGestureRecognizer *)gestureRecognizer
{
    NSDictionary *userInfoDic = [NSDictionary dictionaryWithObjectsAndKeys:self, kTableViewCell, nil];
    [self routerEventWithName:kAvatarClickEvent userInfo:userInfoDic];
}

@end
