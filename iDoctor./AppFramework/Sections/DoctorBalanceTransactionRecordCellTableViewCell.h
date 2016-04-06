//
//  DoctorBalanceTransactionRecordCellTableViewCell.h
//  AppFramework
//
//  Created by tianxiewuhua on 15/5/13.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import <UIKit/UIKit.h>

// 支付
@class Payments;

// 积分
@class ScoreModel;

@interface DoctorBalanceTransactionRecordCellTableViewCell : UITableViewCell

- (void)loadDataWithPayments:(Payments *)payments;

- (void)loadDataWithScoreModel:(ScoreModel *)score;

@end
