//
//  GDComposeView.h
//  GoodDoctor
//
//  Created by hexy on 15/7/22.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CancalBtnClickBlock)(NSString *text);
typedef void(^SendBtnClickBlock)(NSString *text);

@interface GDComposeView : UIView



@property(nonatomic, copy) CancalBtnClickBlock cancalBtnClickBlock;
@property(nonatomic, copy) SendBtnClickBlock  sendBtnClickBlock;

- (void)setCancalBtnClickBlock:(CancalBtnClickBlock)cancalBtnClickBlock;
- (void)setSendBtnClickBlock:(SendBtnClickBlock)sendBtnClickBlock;
- (void)setComposeText:(NSString *)text;

- (void)show;
@end
