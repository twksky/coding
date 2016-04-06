//
//  ArrowRowModel.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/18/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "ArrowRowModel.h"

@implementation ArrowRowModel

+ (instancetype)arrowRowWithTitle:(NSString *)title destVC:(Class)destVC
{
    ArrowRowModel *arrow = [self baseRowModelWithTitle:title];
    arrow.destVC = destVC;
    return arrow;
}

+ (instancetype)arrowRowWithIcon:(UIImage *)icon title:(NSString *)title destVC:(Class)destVC
{
    ArrowRowModel *arrow = [self baseRowModelWithIcon:icon title:title];
    arrow.destVC = destVC;
    return arrow;
}
+ (instancetype)arrowRowModelWithTitle:(NSString *)title subtitle:(NSString *)subtitle destVC:(Class)destVC
{
    ArrowRowModel *arrow = [self baseRowModelWithTitle:title subtitle:subtitle];
    arrow.destVC = destVC;
    return arrow;
}
+ (instancetype)arrowRowModelWithIcon:(UIImage *)icon title:(NSString *)title subtitle:(NSString *)subtitle destVC:(Class)destVC;
{
    ArrowRowModel *arrow = [self arrowRowWithIcon:icon title:title destVC:destVC];
    arrow.subtitle = subtitle;
    return arrow;
}
@end
