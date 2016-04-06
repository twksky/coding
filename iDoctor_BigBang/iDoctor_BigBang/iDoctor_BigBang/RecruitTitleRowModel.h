//
//  RecruitTitleRowModel.h
//  iDoctor_BigBang
//
//  Created by hexy on 7/21/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "TextFieldRowModel.h"

@interface RecruitTitleRowModel : TextFieldRowModel

+ (instancetype)recruitTitleRowModelWithTitle:(NSString *)title placeholder:(NSString *)placeholder keyboardType:(UIKeyboardType)keyboardType;
@end
