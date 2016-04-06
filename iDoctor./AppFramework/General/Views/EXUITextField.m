//
//  EXUITextField.m
//  AppFramework
//
//  Created by ABC on 6/5/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "EXUITextField.h"

@implementation EXUITextField

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

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x + self.textEdgeInsets.left, bounds.origin.y + self.textEdgeInsets.top,
                      bounds.size.width - (self.textEdgeInsets.left + self.textEdgeInsets.right),
                      bounds.size.height - (self.textEdgeInsets.top + self.textEdgeInsets.bottom));
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x + self.textEdgeInsets.left, bounds.origin.y + self.textEdgeInsets.top,
                      bounds.size.width - (self.textEdgeInsets.left + self.textEdgeInsets.right),
                      bounds.size.height - (self.textEdgeInsets.top + self.textEdgeInsets.bottom));
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x + self.textEdgeInsets.left, bounds.origin.y + self.textEdgeInsets.top,
                      bounds.size.width - (self.textEdgeInsets.left + self.textEdgeInsets.right),
                      bounds.size.height - (self.textEdgeInsets.top + self.textEdgeInsets.bottom));
}

@end
