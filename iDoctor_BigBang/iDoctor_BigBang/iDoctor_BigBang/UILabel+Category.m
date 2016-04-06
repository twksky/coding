//
//  UILabel+Category.m
//  iDoctor_BigBang
//
//  Created by twksky on 15/9/16.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "UILabel+Category.h"

@implementation UILabel (Category)

-(CGSize)boundWithSize:(NSInteger)fontSize WithSize:(CGSize)size{
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    return [self.text boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
}

@end
