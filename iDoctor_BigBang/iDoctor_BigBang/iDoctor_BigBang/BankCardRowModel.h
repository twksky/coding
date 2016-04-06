//
//  BankCardRowModel.h
//  iDoctor_BigBang
//
//  Created by hexy on 7/28/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "ArrowRowModel.h"

@interface BankCardRowModel : ArrowRowModel
+ (instancetype)bankCardRowModelWithIcon:(UIImage *)icon title:(NSString *)title subtitle:(NSString *)subtitle destVC:(Class)destVC;

@end
