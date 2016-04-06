//
//  AddTemplateViewController.h
//  AppFramework
//
//  Created by 周世阳 on 15/6/17.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseMainViewController.h"

@class TemplateModel;

@protocol EditTemplateViewControllerDelegate <NSObject>

- (void)didUpdateTemplate:(TemplateModel *)templateModel;

@end

@interface EditTemplateViewController : BaseMainViewController

- (instancetype)initWithTemplate:(TemplateModel *)templateModel;

@property (nonatomic, weak) id<EditTemplateViewControllerDelegate> delegate;

@end
