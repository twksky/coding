//
//  BalanceListRowModel.h
//  iDoctor_BigBang
//
//  Created by hexy on 7/28/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "BaseRowModel.h"
#import "GlideManger.h"
@interface BalanceListRowModel : BaseRowModel

@property(nonatomic, strong) BalanceGlide *balanceGlide;

+ (instancetype)balanceListRowModelWithBalanceGlide:(BalanceGlide *)balanceGlide;

@end

