//
//  BalanceHeaderView.h
//  iDoctor_BigBang
//
//  Created by hexy on 7/27/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ChargeBtnClickBlock)(void);

@interface BalanceHeaderView : UIView


@property(nonatomic, copy) ChargeBtnClickBlock chargeBtnClickBlock;
- (void)setChargeBtnClickBlock:(ChargeBtnClickBlock)chargeBtnClickBlock;
@end
