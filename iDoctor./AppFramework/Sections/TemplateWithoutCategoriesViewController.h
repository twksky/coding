//
//  TemplateSettingWithoutCategoriesViewController.h
//  AppFramework
//
//  Created by 周世阳 on 15/7/8.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseMainViewController.h"

@class TemplateModel;

@protocol TemplateWithoutCategoriesViewControllerDelegate <NSObject>

- (void)didSelectedTemplateModelFromTemplateSetting:(TemplateModel *)model;

@end

@interface TemplateWithoutCategoriesViewController : BaseMainViewController

@property (nonatomic, weak) id<TemplateWithoutCategoriesViewControllerDelegate> delegate;

@end
