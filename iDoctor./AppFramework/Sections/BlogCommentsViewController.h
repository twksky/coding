//
//  BlogCommentsViewController.h
//  AppFramework
//
//  Created by 周世阳 on 15/7/1.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseMainViewController.h"

@class BlogItem;

@interface BlogCommentsViewController : BaseMainViewController

- (instancetype)initWithBlog:(BlogItem *)blog;

@end
