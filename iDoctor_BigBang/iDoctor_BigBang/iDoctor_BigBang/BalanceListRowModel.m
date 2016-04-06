//
//  BalanceListRowModel.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/28/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "BalanceListRowModel.h"

@implementation BalanceListRowModel
+ (instancetype)balanceListRowModelWithBalanceGlide:(BalanceGlide *)balanceGlide
{
    BalanceListRowModel *m = [[self alloc] init];
    m.balanceGlide = balanceGlide;
    return m;
}
@end
