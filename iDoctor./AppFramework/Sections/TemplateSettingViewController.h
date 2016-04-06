//
//  TemplateSettingViewController.h
//  AppFramework
//
//  Created by 周世阳 on 15/6/16.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseMainViewController.h"
/**
 *
 *此类过时,因为模板库被砍掉了, 但是后期很可能会加上, 所以这个类保留, 如果后面模板库的需求加上了再用这个类
 *
 *此类原有的功能-模板设置界面用TemplateSettingWithoutCategoriesViewController替代
 *
 **/
static NSString *MyTemplateCollectionViewReuseIdentifier = @"6836b11b-dd9c-4a65-bbde-01062f87bfb5";
static NSString *TemplateLibCollectionViewReuseIdentifier = @"fb9602f0-47ba-4411-8d51-9a0fa7f57cd8";

@interface TemplateSettingViewController : BaseMainViewController

@end
