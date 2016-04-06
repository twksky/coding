//
//  AddrRowModel.h
//  iDoctor_BigBang
//
//  Created by hexy on 7/20/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "TextFieldRowModel.h"

@interface AddrRowModel : TextFieldRowModel

@property(nonatomic, copy) NSString *value;
@property(nonatomic, assign) UIKeyboardType keyboardType;

+ (instancetype)addrRowModelWithTitle:(NSString *)title
                                value:(NSString *)value
                         keyboardType:(UIKeyboardType)keyboardType;

@end
