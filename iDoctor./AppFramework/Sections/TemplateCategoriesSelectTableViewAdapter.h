//
//  TemplateCategoriesSelectTableViewDataSource.h
//  AppFramework
//
//  Created by tianxiewuhua on 15/6/22.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TemplateCategoryModel;

@protocol TemplateCategoriesSelectTableViewAdapterDelegate <NSObject>

- (void)templateCategorySelected:(TemplateCategoryModel *)templateCategoryModel;

@end

@interface TemplateCategoriesSelectTableViewAdapter : NSObject
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) NSArray *templateCategories;
@property (nonatomic, weak) id<TemplateCategoriesSelectTableViewAdapterDelegate> delegate;

@end
