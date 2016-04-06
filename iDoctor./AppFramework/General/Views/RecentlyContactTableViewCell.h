//
//  RecentlyContactTableViewCell.h
//  AppFramework
//
//  Created by ABC on 8/17/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Patient;
@class TTTAttributedLabel;
@class RecentlyContactTableViewCell;

@protocol RecentlyContactTableViewCellDelegate <NSObject>

- (void)recentlyContactTableViewCellDidClickedAvatarImage:(RecentlyContactTableViewCell *)cell;

@end

@interface RecentlyContactTableViewCell : UITableViewCell

+ (CGFloat)DefaultCellHeight;

@property (nonatomic, weak)   id<RecentlyContactTableViewCellDelegate> delegate;

@property (nonatomic, strong) UIImageView   *avatarImageView;
@property (nonatomic, strong) UILabel       *nicknameLabel;
@property (nonatomic, strong) TTTAttributedLabel     *countLabel;
@property (nonatomic, strong) UILabel       *timeLabel;
@property (nonatomic, strong) UILabel       *infoLabel;
@property (nonatomic, strong) UILabel       *messageLabel;

- (void)setContact:(Patient *)patient;

@end
