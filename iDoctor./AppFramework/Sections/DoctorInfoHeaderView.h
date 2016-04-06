//
//  DoctorInfoHeaderView.h
//  AppFramework
//
//  Created by tianxiewuhua on 15/5/12.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Account;

@interface DoctorInfoHeaderView : UIView

@property (nonatomic, strong) UIImageView *doctorAvatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *docIdLabel;

- (void)addCreditViewTarget:(id)target action:(SEL)action;

- (void)addBalanceViewTarget:(id)target action:(SEL)action;

- (void)addHeaderViewTarget:(id)target action:(SEL)action;

- (void)loadDataWithAccount:(Account *)account;

@end
