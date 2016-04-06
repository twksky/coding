//
//  DoctorCreditShopCell.h
//  AppFramework
//
//  Created by tianxiewuhua on 15/6/25.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoodsModel;

@protocol DoctorCreditShopCellDelegate <NSObject>

- (void)exchangedWithGoods:(GoodsModel *)goods;

@end

@interface DoctorCreditShopCell : UITableViewCell

@property (nonatomic, weak) id<DoctorCreditShopCellDelegate> delegate;

- (void)loadDataWithGoods:(GoodsModel *)goods;

@end
