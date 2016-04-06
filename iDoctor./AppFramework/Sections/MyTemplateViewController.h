//
//  MyTemplateViewController.h
//  AppFramework
//
//  Created by 周世阳 on 15/6/17.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseMainViewController.h"

@class TemplateModel;

@protocol MyTemplateViewControllerDelegate <NSObject>

- (void)selectedTemplate:(TemplateModel *)templateModel;

@end

@interface MyTemplateViewController : BaseMainViewController

@property (nonatomic, weak) id<MyTemplateViewControllerDelegate> delegate;

@end
