//
//  IDLoginTextField.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/10/9.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDLoginTextField.h"

@implementation IDLoginTextField

- (void)drawPlaceholderInRect:(CGRect)rect
{
    [super drawPlaceholderInRect:rect];
    
    [self setValue:UIColorFromRGB(0xa8e1e2) forKeyPath:@"_placeholderLabel.textColor"];
    [self setValue:[UIFont systemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
}

@end
