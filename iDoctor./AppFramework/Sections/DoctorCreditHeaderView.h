//
//  DoctorCreditHeaderView.h
//  AppFramework
//
//  Created by tianxiewuhua on 15/5/13.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoctorCreditHeaderView : UIView

@property (nonatomic, strong) UILabel *creditNumberLabel;

- (void)setSpendCreditButtonAction:(SEL)action withTarget:(id)target;

- (void)setEarnCreditButtonAction:(SEL)action withTarget:(id)target;

@end
