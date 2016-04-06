//
//  AddBlogCommentViewController.h
//  iDoctor_BigBang
//
//  Created by twksky on 15/10/26.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import "BaseViewController.h"

@class Comment;
@class HomeInfoModel;

@protocol AddBlogCommentViewControllerDelegate <NSObject>

- (void)addedComment:(Comment *)comment withBlog:(HomeInfoModel *)blog;

@end

@interface AddBlogCommentViewController : BaseViewController

@property (nonatomic, weak) id<AddBlogCommentViewControllerDelegate> delegate;

- (instancetype)initWithBlog:(HomeInfoModel *)blog;

@end
