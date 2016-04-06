//
//  CheckBoxRowModel.h
//  iDoctor_BigBang
//
//  Created by hexy on 7/23/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "BaseRowModel.h"
typedef void(^CheckBoxCheckedBlock)(NSString *text);
@interface CheckBoxRowModel : BaseRowModel
@property(nonatomic, strong) NSArray *checkboxTitleArray;
@property(nonatomic, copy) CheckBoxCheckedBlock checkBoxCheckedBlock;

+ (instancetype)checkBoxRowModelWithTitle:(NSString *)title CheckboxTitleArray:(NSArray *)checkboxTitleArray;
- (void)setCheckBoxCheckedBlock:(CheckBoxCheckedBlock)checkBoxCheckedBlock;
@end
