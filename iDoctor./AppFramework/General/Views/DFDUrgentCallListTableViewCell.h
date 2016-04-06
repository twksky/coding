//
//  DFDUrgentCallListTableViewCell.h
//  AppFramework
//
//  Created by DebugLife on 2/10/15.
//  Copyright (c) 2015 AppChina. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kAvatarClickEvent       @"487B25CB-6FF3-4EA3-B7AA-05D4584AD51F"
#define kCallButtonClickEvent   @"133957B2-29E7-4D35-A50D-56E54230F3D6"
#define kTableViewCell          @"tableViewCell"
#define kUrgentCallInfoThumbnailImageClickedEvent   @"F8BF6AD6-69B8-4426-8EAD-77FB00877C91"
#define kUrgentCallInfoKey                          @"urgentCallInfo"
#define kImageIndexKey              @"imageIndex"

@class UrgentCallInfo;

@interface DFDUrgentCallListTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView   *avatarImageView;
@property (nonatomic, strong) UILabel       *infoLabel;
@property (nonatomic, strong) UIButton      *callButton;
@property (nonatomic, strong) UILabel       *detailInfoLabel;

+ (CGFloat)cellHeightWithUrgentCallInfo:(UrgentCallInfo *)info;

- (void)loadUrgentCallInfo:(UrgentCallInfo *)info;

@end
