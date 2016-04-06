//
//  DFDSubtitleTableViewCell.h
//  AppFramework
//
//  Created by DebugLife on 2/11/15.
//  Copyright (c) 2015 AppChina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"

#define kAvatarClickEvent                           @"C40DD0E7-C455-47A7-A881-AC16B52ADC71"
#define kTableViewCell                              @"tableViewCell"

@interface DFDSubtitleTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView   *avatarImageView;
@property (nonatomic, strong) TTTAttributedLabel       *titleLabel;
@property (nonatomic, strong) TTTAttributedLabel       *subtitleLabel;
@property (nonatomic, strong) TTTAttributedLabel       *timeLabel;

@end
