//
//  IDRegistFieldView.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/11/11.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDRegistFieldView.h"

@implementation IDRegistFieldView

- (void)drawPlaceholderInRect:(CGRect)rect
{
    [super drawPlaceholderInRect:rect];
    
    [self setValue:UIColorFromRGB(0xa8a8a8) forKeyPath:@"_placeholderLabel.textColor"];
    [self setValue:[UIFont systemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
}


@end
