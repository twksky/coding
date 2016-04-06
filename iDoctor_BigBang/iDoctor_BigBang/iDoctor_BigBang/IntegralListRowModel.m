//
//  IntegralListRowModel.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/28/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "IntegralListRowModel.h"

@implementation IntegralListRowModel
+ (instancetype)integralListRowModelWithIntegralGlide:(IntegralGlide *)integralGlide
{
    IntegralListRowModel *m = [[self alloc] init];
    m.integralGlide = integralGlide;
    return m;
}

@end
