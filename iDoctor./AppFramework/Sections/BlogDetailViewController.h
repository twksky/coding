//
//  BlogDetailViewController.h
//  AppFramework
//
//  Created by tianxiewuhua on 15/6/9.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseMainViewController.h"

@class BlogItem;

@interface BlogDetailViewController : BaseMainViewController

- (instancetype)initWithBlogItem:(BlogItem *)blogItem;

@end
