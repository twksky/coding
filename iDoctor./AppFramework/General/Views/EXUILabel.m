//
//  EXUILabel.m
//  AppFramework
//
//  Created by ABC on 6/11/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "EXUILabel.h"

@implementation EXUILabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)drawTextInRect:(CGRect)rect
{
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.textEdgeInsets)];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:UIEdgeInsetsInsetRect(rect, self.textEdgeInsets)];
}

- (void)drawRect:(CGRect)rect forViewPrintFormatter:(UIViewPrintFormatter *)formatter
{
    [super drawRect:UIEdgeInsetsInsetRect(rect, self.textEdgeInsets) forViewPrintFormatter:formatter];
}

@end
