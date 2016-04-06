//
//  IntegralListRowModel.h
//  iDoctor_BigBang
//
//  Created by hexy on 7/28/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "BaseRowModel.h"
#import "GlideManger.h"
@interface IntegralListRowModel : BaseRowModel

@property(nonatomic, strong) IntegralGlide *integralGlide;
+ (instancetype)integralListRowModelWithIntegralGlide:(IntegralGlide *)integralGlide;
@end
