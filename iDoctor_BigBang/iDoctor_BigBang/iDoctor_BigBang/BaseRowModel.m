//
//  BaseRowModel.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/18/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "BaseRowModel.h"

@implementation BaseRowModel

- (void)setRowSelectedBlock:(RowSelectedBlock)rowSelectedBlock
{
    _rowSelectedBlock = rowSelectedBlock;
}

+ (instancetype)baseRowModelWithTitle:(NSString *)title
{
    BaseRowModel *base = [[self alloc] init];
    base.title = title;
    return base;
}

+ (instancetype)baseRowModelWithIcon:(UIImage *)icon title:(NSString *)title
{
    BaseRowModel *base = [self baseRowModelWithTitle:title];
    base.icon = icon;
    return base;
}
+ (instancetype)baseRowModelWithTitle:(NSString *)title subtitle:(NSString *)subtitle
{
    BaseRowModel *base = [self baseRowModelWithTitle:title];
    base.subtitle = subtitle;
    return base;
}

@end
