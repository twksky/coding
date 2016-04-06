//
//  TextViewRowModel.h
//  iDoctor_BigBang
//
//  Created by hexy on 7/18/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "BaseRowModel.h"

typedef void(^TextViewDidEndEditingBlock)(NSString *text);

@interface TextViewRowModel : BaseRowModel
@property(nonatomic, copy) NSString *text;

@property(nonatomic, copy) TextViewDidEndEditingBlock textViewDidEndEditingBlock;


- (void)setTextViewDidEndEditingBlock:(TextViewDidEndEditingBlock)textViewDidEndEditingBlock;
+ (instancetype)textViewRowModelWithText:(NSString *)text;

@end
