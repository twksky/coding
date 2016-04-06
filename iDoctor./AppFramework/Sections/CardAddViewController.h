//
//  CardAddViewController.h
//  AppFramework
//
//  Created by 周世阳 on 15/5/14.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseMainViewController.h"

@class Bankcard;

@protocol CardAddViewControllerDelegate <NSObject>

- (void)didAddCard:(Bankcard *)card;

@end

@interface CardAddViewController : BaseMainViewController

@property (nonatomic, weak) id<CardAddViewControllerDelegate> delegate;

@end
