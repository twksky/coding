//
//  MyTemplateViewController.h
//  AppFramework
//
//  Created by 周世阳 on 15/6/17.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseMainViewController.h"

@class TemplateCategoryModel;
@class TemplateModel;

@protocol CategoryStandardTemplatesViewControllerDelegate <NSObject>

- (void) savedAnyTemplate:(TemplateModel *)templateModel;

@end

@interface CategoryStandardTemplatesViewController : BaseMainViewController

@property (nonatomic, weak) id<CategoryStandardTemplatesViewControllerDelegate> delegate;

- (instancetype)initWithCategory:(TemplateCategoryModel *)category;

@end
