//
//  CheckBoxRowModel.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/23/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "CheckBoxRowModel.h"

@implementation CheckBoxRowModel
- (void)setCheckBoxCheckedBlock:(CheckBoxCheckedBlock)checkBoxCheckedBlock
{
    _checkBoxCheckedBlock = checkBoxCheckedBlock;
}
+ (instancetype)checkBoxRowModelWithTitle:(NSString *)title CheckboxTitleArray:(NSArray *)checkboxTitleArray
{
    CheckBoxRowModel *cb = [self baseRowModelWithTitle:title];
    cb.checkboxTitleArray = nil;
    cb.checkboxTitleArray = checkboxTitleArray;
    return cb;
}
@end
