//
//  AddrRowModel.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/20/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "AddrRowModel.h"

@implementation AddrRowModel
+ (instancetype)addrRowModelWithTitle:(NSString *)title value:(NSString *)value keyboardType:(UIKeyboardType)keyboardType
{
    AddrRowModel *addr = [self baseRowModelWithTitle:title];
    addr.value = value;
    addr.keyboardType = keyboardType;
    return addr;
}
@end
