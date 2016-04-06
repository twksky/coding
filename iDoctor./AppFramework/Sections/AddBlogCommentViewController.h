//
//  AddBlogCommentViewController.h
//  AppFramework
//
//  Created by 周世阳 on 15/7/2.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseMainViewController.h"

@class Comment;
@class BlogItem;

@protocol AddBlogCommentViewControllerDelegate <NSObject>

- (void)addedComment:(Comment *)comment withBlog:(BlogItem *)blog;

@end

@interface AddBlogCommentViewController : BaseMainViewController

@property (nonatomic, weak) id<AddBlogCommentViewControllerDelegate> delegate;

- (instancetype)initWithBlog:(BlogItem *)blog;

@end
