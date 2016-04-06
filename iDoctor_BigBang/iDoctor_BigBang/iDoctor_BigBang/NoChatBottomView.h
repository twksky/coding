//
//  NoChatBottomView.h
//  iDoctor_BigBang
//
//  Created by hexy on 印度历1937/8/7.
//  Copyright © 印度历1937年 YDHL. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^RevertBtnClickBlock)(void);
typedef void(^InceptBtnClickBlock)(void);

@interface NoChatBottomView : UIView

@property(nonatomic, assign) BOOL isIncepted;

@property(nonatomic, copy) RevertBtnClickBlock revertBtnClickBlock;
@property(nonatomic, copy) InceptBtnClickBlock inceptBtnClickBlock;


- (void)setRevertBtnClickBlock:(RevertBtnClickBlock)revertBtnClickBlock;
- (void)setInceptBtnClickBlock:(InceptBtnClickBlock)inceptBtnClickBlock;

@end
