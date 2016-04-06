//
//  BankCardRowModel.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/28/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "BankCardRowModel.h"

@implementation BankCardRowModel
+ (instancetype)bankCardRowModelWithIcon:(UIImage *)icon title:(NSString *)title subtitle:(NSString *)subtitle destVC:(Class)destVC
{
    return [self arrowRowModelWithIcon:icon title:title subtitle:subtitle destVC:destVC];
}
@end
