//
//  DFDUrgentCallCell.h
//  AppFramework
//
//  Created by 周世阳 on 15/5/20.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kUserIconClickEvent       @"7bbf3b16-9290-45ab-bebe-ddc65d065794"
#define kUgentCallBtnClickEvent   @"405ffba8-e8bf-4cef-b3b2-ff87965485ac"
#define kUrgentCallCell          @"urgentCallCell"
#define kUrgentCallCellDetailImageClickEvent   @"fdc96265-347f-45aa-9dac-85a2846e8f00"
#define kUrgentCallCellInfoKey                          @"urgentCallCellInfo"
#define kUrgentCallCellImageIndexKey              @"urgentCallCellImageIndex"

@class UrgentCallInfo;

@protocol DFDUrgentCallCellDelegate <NSObject>

- (void)reloadCellAtIndexPath:(NSIndexPath *)indexPath;
- (void)changeExpandStateWithIndexPath:(NSIndexPath *)indexPath isExpanded:(BOOL)isExpanded;

@end


@interface DFDUrgentCallCell : UITableViewCell

@property (nonatomic, weak) id<DFDUrgentCallCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)loadUrgentCallInfo:(UrgentCallInfo *)info;

+ (CGFloat)cellHeightWithUrgentCallInfo:(UrgentCallInfo *)info;

@end