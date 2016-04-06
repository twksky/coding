//
//  TextViewRowModel.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/18/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "TextViewRowModel.h"

@implementation TextViewRowModel
- (void)setTextViewDidEndEditingBlock:(TextViewDidEndEditingBlock)textViewDidEndEditingBlock
{
    _textViewDidEndEditingBlock = textViewDidEndEditingBlock;
}
+ (instancetype)textViewRowModelWithText:(NSString *)text
{
    TextViewRowModel *textView = [[self alloc] init];
    textView.text = text;
    return textView;
}

@end
