//
//  RegisterSuccessViewController.h
//  AppFramework
//
//  Created by 周世阳 on 15/6/12.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseMainViewController.h"

@class Account;

@interface RegisterSuccessViewController : BaseMainViewController

- (instancetype)initWithAccountCache:(Account *)accountCache;

@end
