//
//  TextFieldRowModel.h
//  iDoctor_BigBang
//
//  Created by hexy on 7/18/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "BaseRowModel.h"

typedef void(^TextFieldDidEndEditingBlock)(NSString *text);

@interface TextFieldRowModel : BaseRowModel
@property(nonatomic, copy) NSString *text;
@property(nonatomic, copy) NSString *placeholder;
@property(nonatomic, assign) UIKeyboardType keyboardType;

@property(nonatomic, copy) TextFieldDidEndEditingBlock textFieldDidEndEditingBlock;


- (void)setTextFieldDidEndEditingBlock:(TextFieldDidEndEditingBlock)textFieldDidEndEditingBlock;

+ (instancetype)textFieldRowModelWithText:(NSString *)text
                              placeholder:(NSString *)placeholder
                             keyboardType:(UIKeyboardType)keyboardType;
@end
