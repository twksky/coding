//
//  BlogCommentCell.h
//  AppFramework
//
//  Created by 周世阳 on 15/7/2.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Comment;

@interface BlogCommentCell : UITableViewCell

- (void)loadDataWithComment:(Comment *)comment;

+ (CGFloat)cellHeightWithComment:(Comment *)comment;

@end
