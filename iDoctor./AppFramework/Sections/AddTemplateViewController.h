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

@protocol AddTemplateViewControllerDelegate <NSObject>

- (void)didSavedNewTemplate:(TemplateModel *)templateModel;

@end

@interface AddTemplateViewController : BaseMainViewController

- (id)initWithDefaultTemplate:(TemplateModel *)templateModel;

@property (nonatomic, weak) id<AddTemplateViewControllerDelegate> delegate;

@end
