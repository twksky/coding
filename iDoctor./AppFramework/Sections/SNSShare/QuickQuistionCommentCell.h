//
//  QuickQuistionCommentCell.h
//  AppFramework
//
//  Created by 周世阳 on 15/4/22.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIView+AutoLayout.h"
#import "Comment.h"


@interface QuickQuistionCommentCell : UITableViewCell

@property (nonatomic, strong) UILabel *commentContentLabel;

@property (nonatomic, strong) UILabel *titleLabel;

+ (CGFloat)cellHeightWithComment:(Comment *)comment;

@end
