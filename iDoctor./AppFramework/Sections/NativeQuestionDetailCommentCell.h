//
//  NativeQuestionDetailCommentCellTableViewCell.h
//  AppFramework
//
//  Created by tianxiewuhua on 15/6/1.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Comment;

@interface NativeQuestionDetailCommentCell : UITableViewCell

- (void)loadComment:(Comment *)comment;

+ (CGFloat)cellHeightWithComment:(Comment *)question;

@end
