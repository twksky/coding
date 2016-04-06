//
//  DFDFollowUpItemTableViewCell.h
//  AppFramework
//
//  Created by DebugLife on 2/11/15.
//  Copyright (c) 2015 AppChina. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FollowUpItem;

#define kFollowUpItemTableViewCellKey   @"followUpItemTableViewCell"
#define kReplyButtonClickedEvent    @"38535D3C-DE6B-46B1-9FED-0AC7BB297FC7"
#define kFollowUpItemKey            @"followUpItem"
#define kFollowUpItemThumbnailImageClickedEvent @"A910B7D1-7105-44DB-9F76-FBBA0B9B8829"
#define kImageIndexKey              @"imageIndex"

@interface DFDFollowUpItemTableViewCell : UITableViewCell

+ (CGFloat)cellHeightWithFollowUpItem:(FollowUpItem *)item;

- (void)loadFollowUpItem:(FollowUpItem *)item;

@end
