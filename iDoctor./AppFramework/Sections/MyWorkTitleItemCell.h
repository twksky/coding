//
//  MyWorkTitleItemCell.h
//  AppFramework
//
//  Created by 周世阳 on 15/5/11.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TipView;

@interface MyWorkTitleItemCell : UITableViewCell

@property (nonatomic, strong) UILabel *workItemTitle;
@property (nonatomic, strong) UIImageView *workItemIcon;
@property (nonatomic, strong) UILabel *workItemMsg;
@property (nonatomic, strong) TipView *tipView;

@end
