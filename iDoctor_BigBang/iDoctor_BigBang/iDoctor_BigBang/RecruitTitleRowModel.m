//
//  RecruitTitleRowModel.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/21/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "RecruitTitleRowModel.h"

@implementation RecruitTitleRowModel
+ (instancetype)recruitTitleRowModelWithTitle:(NSString *)title placeholder:(NSString *)placeholder keyboardType:(UIKeyboardType)keyboardType
{
    return [self textFieldRowModelWithText:title placeholder:placeholder keyboardType:keyboardType];
}
@end
