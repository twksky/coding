//
//  DoctorBalanceViewController.h
//  AppFramework
//
//  Created by 周世阳 on 15/5/13.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "BaseMainViewController.h"

static NSInteger BALANCE_VIEW_INDEX = 0;
static NSInteger CREDIT_VIEW_INDEX = 1;

@interface DoctorMoneyViewController : BaseMainViewController

- (instancetype)initWithSegmentIndex:(NSInteger)segmentIndex;

@end
