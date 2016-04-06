//
//  TextFieldRowModel.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/18/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "TextFieldRowModel.h"

@implementation TextFieldRowModel

- (void)setTextFieldDidEndEditingBlock:(TextFieldDidEndEditingBlock)textFieldDidEndEditingBlock
{
    _textFieldDidEndEditingBlock = textFieldDidEndEditingBlock;
}
+ (instancetype)textFieldRowModelWithText:(NSString *)text placeholder:(NSString *)placeholder keyboardType:(UIKeyboardType)keyboardType
{
    TextFieldRowModel *textField = [[self alloc] init];
    textField.text = text;
    textField.placeholder = placeholder;
    textField.keyboardType = keyboardType;  
    return textField;
}
@end
