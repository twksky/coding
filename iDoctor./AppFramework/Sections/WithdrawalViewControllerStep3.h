//
//  WithdrawalViewControllerStep3.h
//  AppFramework
//
//  Created by ABC on 7/8/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseMainViewController.h"

@class Bankcard;

@interface WithdrawalViewControllerStep3 : BaseMainViewController

- (id)initWithBankcard:(Bankcard *)bankcard withMoney:(CGFloat)money withActualMoney:(CGFloat)actualMoney;

@end
