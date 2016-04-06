//
//  DoctorBalanceTransactionScoreCell.h
//  AppFramework
//
//  Created by 张丽 on 15/7/3.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import <UIKit/UIKit.h>

// 积分模型
@class  ScoreModel;

@interface DoctorBalanceTransactionScoreCell : UITableViewCell

- (void)loadDataWithScoreModel:(ScoreModel *)score;

@end
