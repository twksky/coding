//
//  CardListViewController.h
//  AppFramework
//
//  Created by 周世阳 on 15/5/14.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseMainViewController.h"

@class Bankcard;

@protocol CardListViewControllerDelegate <NSObject>

- (void)didSelectedCard:(Bankcard *)card;

@end


@interface CardListViewController : BaseMainViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id<CardListViewControllerDelegate> delegate;

@end
