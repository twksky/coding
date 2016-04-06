//
//  ChatBottomView.h
//  iDoctor_BigBang
//
//  Created by hexy on 印度历1937/8/7.
//  Copyright © 印度历1937年 YDHL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChatBtnClickBlock)(void);

typedef void(^RevertBtnClickBlock)(void);
typedef void(^InceptBtnClickBlock)(void);

@interface ChatBottomView : UIView

@property(nonatomic, assign) BOOL isIncepted;

@property(nonatomic, copy) ChatBtnClickBlock chatBtnClickBlock;

@property(nonatomic, copy) RevertBtnClickBlock revertBtnClickBlock;
@property(nonatomic, copy) InceptBtnClickBlock inceptBtnClickBlock;

- (void)setChatBtnClickBlock:(ChatBtnClickBlock)chatBtnClickBlock;
- (void)setRevertBtnClickBlock:(RevertBtnClickBlock)revertBtnClickBlock;
- (void)setInceptBtnClickBlock:(InceptBtnClickBlock)inceptBtnClickBlock;
@end
