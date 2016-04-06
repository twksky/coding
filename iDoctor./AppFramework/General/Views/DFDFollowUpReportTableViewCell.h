//
//  DFDFollowUpReportTableViewCell.h
//  AppFramework
//
//  Created by DebugLife on 2/11/15.
//  Copyright (c) 2015 AppChina. All rights reserved.
//

#import "DFDSubtitleTableViewCell.h"

@class FollowUpReport;

#define kFollowUpReportTableViewCellKey             @"followUpReportTableViewCell"
#define kFollowUpReportKey                          @"followUpReport"
#define kFollowUpReportThumbnailImageClickedEvent   @"9273A85E-9B2F-4A11-BC89-B5BFD085F5D1"
#define kImageIndexKey              @"imageIndex"

@interface DFDFollowUpReportTableViewCell : DFDSubtitleTableViewCell

+ (CGFloat)cellHeightWithFollowUpReport:(FollowUpReport *)report;

- (void)loadFollowUpReport:(FollowUpReport *)report;

@end
