//
//  IDExchangeIntergerView.h
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/11/5.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectIntegerBlock)(NSString *text);
@interface IDExchangeIntergerView : UIView

@property (nonatomic, copy) selectIntegerBlock block;

@end
