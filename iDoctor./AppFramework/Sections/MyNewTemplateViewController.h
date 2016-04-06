//
//  TemplateSettingViewController.h
//  AppFramework
//
//  Created by 周世阳 on 15/6/16.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//


/**
 *
 *此类过时,因为模板库被砍掉了, 但是后期很可能会加上, 所以这个类保留, 如果后面模板库的需求加上了再用这个类
 *
 *此类原有的功能-聊天模板界面用TemplateWithoutCategoriesViewController替代
 *
 **/
#import <UIKit/UIKit.h>
#import "BaseMainViewController.h"

@class TemplateModel;

@protocol MyNewTemplateViewControllerDelegate <NSObject>

- (void)didSelectedTemplateModelFromTemplateSetting:(TemplateModel *)model;

@end

static NSString *NewMyTemplateCollectionViewReuseIdentifier = @"e7bde827-e71f-4ab1-9ef7-ca34250bef06";
static NSString *NewTemplateLibCollectionViewReuseIdentifier = @"7c1ba03b-432b-4c77-97a1-921eff041aed";

@interface MyNewTemplateViewController : BaseMainViewController

@property (nonatomic, weak) id<MyNewTemplateViewControllerDelegate> delegate;

@end
