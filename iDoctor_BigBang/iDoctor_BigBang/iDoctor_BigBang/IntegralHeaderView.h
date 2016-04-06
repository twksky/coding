//
//  IntegralHeaderView.h
//  iDoctor_BigBang
//
//  Created by hexy on 7/27/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ShopBtnClickBlock)(void);
typedef void(^ExchangeBtnClickBlock)(void);
@interface IntegralHeaderView : UIView

@property(nonatomic, assign) NSInteger score;

@property(nonatomic, copy) ShopBtnClickBlock shopBtnClickBlock;
@property(nonatomic, copy) ExchangeBtnClickBlock exchangeBtnClickBlock;

- (void)setShopBtnClickBlock:(ShopBtnClickBlock)shopBtnClickBlock;

- (void)setExchangeBtnClickBlock:(ExchangeBtnClickBlock)exchangeBtnClickBlock;
@end
