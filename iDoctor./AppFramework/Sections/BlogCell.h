//
//  BlogCell.h
//  AppFramework
//
//  Created by 周世阳 on 15/6/9.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BlogItem;

@interface BlogCell : UITableViewCell

- (void)loadBlog:(BlogItem *)blogItem;

@end
