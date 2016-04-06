//
//  BlogCommentCell.h
//  iDoctor_BigBang
//
//  Created by twksky on 15/10/26.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Comment;

@interface BlogCommentCell : UITableViewCell

- (void)loadDataWithComment:(Comment *)comment;

+ (CGFloat)cellHeightWithComment:(Comment *)comment;

@end